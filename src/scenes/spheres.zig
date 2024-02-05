const std = @import("std");
const image = @import("../image.zig");
const vec3 = @import("../vec3.zig");
const objects = @import("../objects.zig");
const Ray = @import("../ray.zig").Ray;
const hitColor = @import("../hitable.zig").hitColor;

const allocator = std.heap.page_allocator;

const spheres = [_]objects.Sphere{
    objects.Sphere{
        .position = vec3.Vec3{ .x = -700 },
        .radius = 150.0,
        .color = image.Color{ .G = 92, .B = 48 },
    },
    objects.Sphere{
        .position = vec3.zero,
        .radius = 400.0,
        .color = image.Color{ .R = 92 },
    },
    objects.Sphere{
        .position = vec3.Vec3{ .x = 100, .y = 500, .z = -20 },
        .radius = 50.0,
        .color = image.Color{ .R = 92, .G = 92 },
    },
    objects.Sphere{
        .position = vec3.Vec3{ .x = 700 },
        .radius = 250.0,
        .color = image.Color{ .R = 48, .B = 92 },
    },
};

const lights = [_]objects.Light{
    objects.Light{
        .position = vec3.Vec3{ .x = -500, .y = -300, .z = -200 },
        .color = image.Color{ .G = 192 },
    },
    objects.Light{
        .position = vec3.Vec3{ .x = 1000, .y = 1000, .z = -500 },
        .color = image.Color{ .R = 172, .B = 128 },
    },
};

pub fn spheresScene() !image.Image {
    const width: u64 = 2000;
    const height: u64 = 1000;

    const img = image.Image{
        .width = width,
        .height = height,
        .pixels = try allocator.alloc(image.Color, @as(u32, width) * height),
    };

    const camera_position = vec3.Vec3{ .z = -2000 };
    const focal_distance: f64 = 1500;

    const screen_center = camera_position.add(
        vec3.forward.mulScalar(focal_distance),
    );

    var i: usize = 0;
    while (i < height) : (i += 1) {
        const y = @as(isize, @intCast(i)) - @divFloor(height, 2);

        var j: usize = 0;
        while (j < width) : (j += 1) {
            const x = @as(isize, @intCast(j)) - @divFloor(width, 2);

            const pixel_position = screen_center
                .add(vec3.up.mulScalar(-@as(f64, @floatFromInt(y))))
                .add(vec3.right.mulScalar(@floatFromInt(x)));

            const ray = Ray{
                .origin = &camera_position,
                .direction = pixel_position.sub(camera_position),
            };

            img.pixels[i * width + j] = hitColor(ray, &spheres, &lights);
        }
    }

    return img;
}
