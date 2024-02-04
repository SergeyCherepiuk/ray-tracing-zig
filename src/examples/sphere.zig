const std = @import("std");
const image = @import("../image/image.zig");
const vec3 = @import("../vec3/vec3.zig");
const Sphere = @import("../shapes/sphere.zig").Sphere;
const Ray = @import("../ray/ray.zig").Ray;

const allocator = std.heap.page_allocator;

pub fn sphereExample() !image.Image {
    const width: u64 = 300;
    const height: u64 = 300;

    const img = image.Image{
        .width = width,
        .height = height,
        .pixels = try allocator.alloc(image.Pixel, @as(u32, width) * height),
    };

    const camera_position = vec3.Vec3{ .z = 100 };
    const focal_distance: f64 = 50.0;

    const screen_center = camera_position.add(
        vec3.forward.mulScalar(focal_distance),
    );

    const sphere = Sphere{ .position = vec3.zero, .radius = 50.0 };

    var i: usize = 0;
    while (i < height) : (i += 1) {
        const y = @as(isize, @intCast(i)) - @divFloor(height, 2);

        var j: usize = 0;
        while (j < width) : (j += 1) {
            const x = @as(isize, @intCast(j)) - @divFloor(width, 2);

            const pixel_position = screen_center
                .add(vec3.up.mulScalar(@floatFromInt(y)))
                .add(vec3.right.mulScalar(@floatFromInt(x)));

            const ray = Ray{
                .origin = &camera_position,
                .direction = pixel_position.sub(camera_position),
            };

            img.pixels[i * width + j] = if (ray.intersects(sphere))
                image.Pixel{ .R = 255, .G = 64, .B = 64 }
            else
                image.Pixel{ .R = 255, .G = 255, .B = 255 };
        }
    }

    return img;
}
