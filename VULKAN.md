# Vulkan renderer backend

ZEQ2-Lite can run its existing renderer front end on either OpenGL or a
Vulkan translation backend.  The backend switch is runtime-only: the same
scene, model, texture and GLSL shader code is used, while the `qgl*` entry
points resolve to either real OpenGL functions or the Vulkan emulation layer.

## Building

On desktop Linux the backend is enabled automatically when `pkg-config` finds
both `vulkan` and `shaderc`:

```sh
./build.sh deps        # installs libvulkan-dev, libshaderc-dev, mesa-vulkan-drivers, ...
./build.sh release
```

Set `USE_VULKAN=0` to build without it.  Other platforms keep the original
OpenGL-only renderer.

## Selecting the backend

The latched cvar `r_renderer` chooses the backend:

```sh
+set r_renderer vulkan   # requires a vid_restart to take effect
+set r_renderer opengl
```

It is also exposed as **Renderer: OpenGL / Vulkan** in the in-game graphics
settings menu; applying the menu settings executes `vid_restart`.  If Vulkan
cannot be initialized, the engine prints a message and falls back to OpenGL.

The Vulkan path currently creates an Xlib surface, so an X11 display is
required.  Headless smoke tests use Xvfb with lavapipe:

```sh
./build.sh test          # includes the Vulkan smoke test
./build.sh warnings      # clean release+debug rebuild, fails on any warning
```

## Implementation notes

* `qgl_dispatch.h` is generated from `qgl.h` by
  `Source/Tools/generate_qgl_dispatch.py`.  Re-run it whenever the set of
  `qgl*` macros or ARB function pointers changes.
* `Source/Engine/renderer/tr_vkgl.c` implements the Vulkan device, swapchain,
  render pass, descriptor sets, pipelines and GL-compatible state calls.
* GLSL 1.20-style sources are rewritten to GLSL 4.50 for Vulkan (explicit
  attribute/varying locations, std140 uniform block, sampler bindings) and
  compiled to SPIR-V with shaderc.  Both built-in fallback shaders and GLSL
  programs loaded from pk3 files go through this translator.
* The renderer's fixed-function calls that Vulkan does not have are ignored
  or emulated where they affect the visible result.
