# Memory allocator modernization

`Source/Shared/common.c` implements the two allocators used throughout the
engine: the zone allocator for short-lived, tagged allocations and the hunk for
large, frame- or level-lifetime allocations. This change modernizes both while
keeping every public allocator declaration in `Source/Shared/qcommon.h` source
compatible.

## Zone allocator

* Free blocks are kept in segregated power-of-two size buckets with a bitmask
  of non-empty buckets. Allocation picks the smallest suitable block in the
  first non-empty bucket at or above the requested size instead of walking the
  entire zone from a rotating `rover`.
* Free-list removal is O(1) through `freePrev`, and adjacent free blocks are
  still coalesced on free.
* Block sizes and zone accounting use `size_t`; public availability queries
  clamp to `INT_MAX` so the API stays unchanged.
* All user pointers and block headers are 16-byte aligned. Static strings used
  by `CopyString` reserve the same header padding as real blocks, so they can
  be passed to `Z_Free` safely.
* `Z_Malloc` still zeroes memory; `Z_TagMalloc` still does not.
* Zone arenas are allocated with `malloc` rather than zero-filling the whole
  region with `calloc`; `Z_ClearZone` only initializes bookkeeping. The raw
  pointer is retained so reinitialization cannot leak or free an aligned
  interior pointer.
* `com_zoneMegs` is clamped to a sane 1 GiB ceiling.

## Hunk allocator

* Hunk memory is 64-byte (cache-line) aligned. The raw allocation pointer is
  retained separately so the arena can be freed or reinitialized safely.
* The arena is allocated with `malloc`; pages are committed as they are used
  rather than by touching 512 MB up front. `Hunk_Alloc` still zeroes the bytes
  it hands out.
* `com_hunkMegs` is clamped to 4 GiB and checked for overflow before the byte
  count is computed.
* Capacity checks use the high-water value of each bank (`temp` or
  `permanent`, whichever is larger) instead of only `permanent`, preventing
  temporary allocations from overwriting live data.
* Temporary allocation headers occupy a full cache line so payloads stay
  aligned; `Hunk_FreeTempMemory` validates the header offset and magic.
* `Com_TouchMemory`, `Com_Meminfo_f`, and the debug hunk logs use `size_t`
  consistently and no longer truncate large hunks.
* The old unused `key` assignments and the unused `fs_game` cvar fetch in
  `Com_Frame`/`Com_WriteConfiguration` were removed.

## Tests

`Source/Tests/test_memory.c` links the real allocator from `common.c` against a
small set of engine stubs (`Source/Tests/engine_stubs.c`) and checks:

* zeroing, alignment, and overlap of zone allocations;
* availability accounting and coalescing after frees;
* tagged allocation and `Z_FreeTags`;
* static `CopyString` buffers;
* hunk alignment, zeroing, bank separation, temp allocation/free, marks, and
  remaining-memory accounting;
* a 20,000-operation randomized zone stress loop with heap validation.

Run the allocator tests alone with:

```sh
./build.sh memory-test
./build.sh memory-test-asan   # same tests under AddressSanitizer + UBSan
```

They also run automatically as the first step of `./build.sh test` and
`./build.sh all`, before the existing dedicated-server and client smoke tests.

Note that `S_Malloc` uses `Z_TagMalloc` and deliberately does **not** zero its
block; only `Z_Malloc` guarantees zeroed memory. The tests assert this
difference so that a future change cannot silently introduce the wrong
expectation.
