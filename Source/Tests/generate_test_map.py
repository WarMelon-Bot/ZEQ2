#!/usr/bin/env python3
"""Generate a tiny, self-contained BSP map for client/server integration tests.

The engine test runs have no game assets installed.  This script builds a
minimal IBSP (version 46) level containing a solid floor box and a handful of
player start points so a dedicated server can spawn a real game and a client
can connect, move, and act in it.

Usage: generate_test_map.py OUTPUT.bsp
"""

import os
import struct
import sys

BSP_VERSION = 46
MAX_QPATH = 64
HEADER_LUMPS = 17

LUMP_ENTITIES = 0
LUMP_SHADERS = 1
LUMP_PLANES = 2
LUMP_NODES = 3
LUMP_LEAFS = 4
LUMP_LEAFSURFACES = 5
LUMP_LEAFBRUSHES = 6
LUMP_MODELS = 7
LUMP_BRUSHES = 8
LUMP_BRUSHSIDES = 9
LUMP_DRAWVERTS = 10
LUMP_DRAWINDEXES = 11
LUMP_FOGS = 12
LUMP_SURFACES = 13
LUMP_LIGHTMAPS = 14
LUMP_LIGHTGRID = 15
LUMP_VISIBILITY = 16

CONTENTS_SOLID = 1

# Room bounds.  The brush top is z=0 and starts float above it.
ROOM_X = 1024
ROOM_Y = 1024
ROOM_Z_MIN = -256

ENTITIES = b'''{
"classname" "worldspawn"
"message" "ZEQ2-Lite integration test room"
}
{
"classname" "info_player_deathmatch"
"origin" "0 0 64"
"angle" "0"
"spawnflags" "1"
}
{
"classname" "info_player_deathmatch"
"origin" "256 0 64"
"angle" "90"
}
{
"classname" "info_player_deathmatch"
"origin" "-256 256 64"
"angle" "180"
}
{
"classname" "info_player_deathmatch"
"origin" "256 -256 64"
"angle" "270"
}
'''

# dshader_t: char[MAX_QPATH], surfaceFlags, contentFlags
shader = struct.pack('<64sii', b'textures/test/floor', 0, CONTENTS_SOLID)

# dplane_t: float normal[3], float dist.  Normals point out of the brush.
planes = [
    ((-1.0, 0.0, 0.0), ROOM_X),
    ((1.0, 0.0, 0.0), ROOM_X),
    ((0.0, -1.0, 0.0), ROOM_Y),
    ((0.0, 1.0, 0.0), ROOM_Y),
    ((0.0, 0.0, -1.0), -ROOM_Z_MIN),
    ((0.0, 0.0, 1.0), 0.0),
]
planes_data = b''.join(struct.pack('<4f', *normal, dist) for normal, dist in planes)

# dnode_t: planeNum, children[2], mins[3], maxs[3]
# Both children are leafs; dleaf_t encoding is -(leafNum + 1).
node = struct.pack('<9i', 0, -1, -2, 0, 0, 0, 0, 0, 0)


def leaf(cluster=0):
    return struct.pack('<12i', cluster, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)


# Both leafs reference the single worldbrush so collision works no matter
# which side of the split plane a query point lands on.
leafs = leaf(0) + leaf(0)
leaf_brushes = struct.pack('<2i', 0, 0)

# dmodel_t: mins[3], maxs[3], firstSurface, numSurfaces, firstBrush, numBrushes
model = struct.pack(
    '<6f4i',
    -ROOM_X, -ROOM_Y, ROOM_Z_MIN,
    ROOM_X, ROOM_Y, 0.0,
    0, 0, 0, 1,
)

# dbrush_t: firstSide, numSides, shaderNum
brush = struct.pack('<3i', 0, len(planes), 0)

# dbrushside_t: planeNum, shaderNum
brush_sides = b''.join(struct.pack('<2i', i, 0) for i in range(len(planes)))

lumps = {
    LUMP_ENTITIES: ENTITIES,
    LUMP_SHADERS: shader,
    LUMP_PLANES: planes_data,
    LUMP_NODES: node,
    LUMP_LEAFS: leafs,
    LUMP_LEAFBRUSHES: leaf_brushes,
    LUMP_MODELS: model,
    LUMP_BRUSHES: brush,
    LUMP_BRUSHSIDES: brush_sides,
}

header_size = 8 + HEADER_LUMPS * 8
blob = bytearray()
offsets = []
for index in range(HEADER_LUMPS):
    data = lumps.get(index, b'')
    blob.extend(b'\x00' * ((4 - len(blob) % 4) % 4))
    offsets.append(header_size + len(blob))
    blob.extend(data)

header = struct.pack('<4s i', b'IBSP', BSP_VERSION)
for index in range(HEADER_LUMPS):
    header += struct.pack('<ii', offsets[index], len(lumps.get(index, b'')))
assert len(header) == header_size

output = sys.argv[1] if len(sys.argv) > 1 else 'testroom.bsp'
os.makedirs(os.path.dirname(os.path.abspath(output)), exist_ok=True)
with open(output, 'wb') as f:
    f.write(header + bytes(blob))
print(f'Wrote {output} ({len(header) + len(blob)} bytes)')
