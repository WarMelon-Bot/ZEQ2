# Multi-core support

ZEQ2-Lite's graphical client can run the renderer back end on a second core
while the front end builds the next frame's command buffer.  The threaded
code is built into the regular `ZEQ2` client; `r_smp` decides at run time
whether it is used.

## Using the threaded renderer

```sh
./build.sh build          # builds ZEQ2, ZEQ2-smp and ZEQ2Dedicated
./build.sh smp            # runs ZEQ2 with +set r_smp 1
```

`r_smp` defaults to `1` and is a latched cvar, so set it before the renderer
starts if you want to override it.  Set `r_smp 0` in `zeq2config.cfg` to keep
the historical single-threaded path.  `ZEQ2-smp` is kept as a compatibility
symlink to `ZEQ2`; it is the same binary, not a second build.

On X11 the SDL 1.2 GL context is moved between the main thread and the render
thread with `glXMakeCurrent()` at each hand-off.  If SDL is using a video
driver without an X11/GLX context (for example `dummy` or `fbcon`), the
renderer detects this and safely falls back to the original single-threaded
path instead of crashing.  macOS still uses the historical stubs for the
OpenGL backend.  When the thread cannot be started, only one command buffer is
allocated and both front end and back end stay on the main thread.

The Vulkan backend also runs its back end on the render thread.  It records
and submits its own command buffers, so no GL context migration is needed and
the X11/GLX restrictions do not apply.  Use `+set r_renderer vulkan` with
`r_smp 1` to enable it.

## Build performance

* `./build.sh release` builds only the optimized client/server/QVMs; this is
  the fastest way to get a runnable build.
* `./build.sh build` builds release and debug in a single parallel `make`
  invocation, so both configurations can use all available cores.
* `ccache` is used automatically when installed; explicit cross builds and
  user-supplied `CC` values are left untouched.
* `JOBS` (or `-j N`) controls how many compile jobs `make` runs in parallel:

```sh
JOBS=8 ./build.sh build
```

## Testing

```sh
./build.sh test
```

This starts the dedicated server, then runs three headless client checks under
Xvfb: the default `ZEQ2` client with `r_smp` at its default value (`1`), the
same client with `r_smp 0` to verify the single-threaded fallback, and the
`ZEQ2-smp` compatibility symlink with `r_smp 1`.  Each client renders a few
frames and quits.  The threaded checks fail if the render thread does not
start or is not joined cleanly during shutdown, and the `r_smp 0` check fails
if a thread is started anyway.  Two more checks repeat the Vulkan test with
`r_smp 0` and `r_smp 1` to cover both back ends.  The headless client tests
are skipped when `xvfb-run` is not installed.
