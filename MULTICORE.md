# Multi-core support

ZEQ2-Lite was originally built around a single-threaded renderer.  On Linux
and macOS the build now also produces `ZEQ2-smp`, a client that runs the
renderer back end on a second thread while the front end keeps building the
next frame's command buffer.

## Using the threaded renderer

```sh
./build.sh build          # builds ZEQ2, ZEQ2-smp and ZEQ2Dedicated
./build.sh smp            # runs ZEQ2-smp with +set r_smp 1
```

`r_smp` is a latched cvar, so set it before the renderer starts (as the `smp`
command does).  It defaults to `0` in the regular client.  Set it to `1` in
`zeq2config.cfg` if you always want the threaded client.

On X11 the SDL 1.2 GL context is moved between the main thread and the render
thread with `glXMakeCurrent()` at each hand-off.  If SDL is using a video
driver without an X11/GLX context (for example `dummy` or `fbcon`), the
renderer detects this and safely falls back to the original single-threaded
path instead of crashing.  macOS still uses the historical stubs.

## Testing

```sh
./build.sh test
```

This starts the dedicated server, then starts `ZEQ2-smp` under Xvfb, enables
`r_smp`, renders a few frames and quits.  The test fails if the render thread
does not start or is not joined cleanly during shutdown.  `JOBS` (or `-j N`)
controls how many compile jobs `make` runs in parallel:

```sh
JOBS=8 ./build.sh build
```

The headless render-thread test is skipped when `xvfb-run` is not installed.
