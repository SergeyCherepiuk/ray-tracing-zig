# Ray tracing

Graphics library for generating 2D images from 3D scenes.

## Current state

Rendering several overlapping spheres (yes, these are spheres, not circles) painted in different colors. No source of light yet being added, so objects do not cast shadows.

Run the following command to generate an image:

```bash
$ zig run src/main.zig > assets/image.ppm
```

![Generated image of the spheres](./assets/image-converted.png)
