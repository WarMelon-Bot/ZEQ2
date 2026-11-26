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

Set `USE_VULKAN=0` to build without it.  Other desktop platforms, including
Windows, can opt in explicitly when the Vulkan headers and shaderc are
available.  Point `VULKAN_SDK` at the SDK root when it is not on the default
include/library path:

```sh
make USE_VULKAN=1 VULKAN_SDK=/path/to/vulkan/sdk
```

On Windows the Vulkan SDK plus shaderc must be available to the chosen
compiler; MinGW cross-builds use the same `USE_VULKAN=1` switch.  Without those
development dependencies, the renderer stays OpenGL-only.

## Selecting the backend

The latched cvar `r_renderer` chooses the backend.  Set it on the command line
before the renderer starts:

```sh
+set r_renderer vulkan
+set r_renderer opengl
```

It is also exposed as **Renderer: OpenGL / Vulkan** in the in-game graphics
settings menu; because the cvar is latched, applying a change from the menu
executes `vid_restart`.  If Vulkan cannot be initialized, the engine prints a
message and falls back to OpenGL.

## Window system surfaces

The backend chooses the surface extension from the SDL window information
instead of assuming X11:

* **Windows:** native `VK_KHR_win32_surface` from the SDL `HWND`.
* **X11/Unix (including XWayland):** `VK_KHR_xlib_surface` from the SDL X11
  display and window.

SDL 1.2 does not expose native Wayland or Quartz window handles through
`SDL_GetWMInfo`, so native Wayland and native macOS sessions use the OpenGL
backend.  Headless smoke tests use Xvfb with lavapipe:

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
* The GL compatibility layer covers the renderer's state calls and immediate
  submission path, but it is not a complete OpenGL implementation.  Legacy
  fixed-function features without a direct Vulkan equivalent may be partially
  emulated or ignored; shaders are still authoritative for final color and
  alpha.
* The renderer back end can run on a second thread with `r_smp 1`, just like
  the OpenGL path.  Vulkan does not need the GLX context hand-off, so the
  thread starts on any SDL video driver that can create the window.
* The framebuffer uses a packed depth/stencil attachment (`D24_UNORM_S8_UINT`
  where available, otherwise `D32_SFLOAT_S8_UINT` or `D16_UNORM_S8_UINT`).
  The backend reports 8 stencil bits through `GL_STENCIL_BITS` and
  `glConfig.stencilBits`, so stencil shadows and overdraw measurement can run.
* `qglReadPixels(GL_DEPTH_COMPONENT, ...)` copies the depth/stencil image to a
  staging buffer and converts the selected format to GL-compatible depth
  values.  `GL_STENCIL_INDEX` readback uses the same staging copy.
