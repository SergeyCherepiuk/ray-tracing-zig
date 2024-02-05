# Ray tracing

Graphics library for generating 2D images from 3D scenes.

## Current state

Rendering several illuminated spheres painted in different colors. The light might be blocked by other spheres, resulting in a shadow.

Run the following command to generate an image:

```bash
$ zig run src/main.zig > assets/image.ppm
```

![Generated image of the spheres](./assets/image-converted.jpg)
