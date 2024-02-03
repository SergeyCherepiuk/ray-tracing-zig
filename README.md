# Ray tracing

Graphics library for generating 2D images from 3D scenes.

## Current state

Rendering the sphere (yes, it's a sphere). No source of light yet being added, so objects do not cast shadows.

Run the following command to generate an image:

```bash
$ zig run src/main.zig > assets/image.ppm
```

![Generated image of a sphere](./assets/image-converted.png)
