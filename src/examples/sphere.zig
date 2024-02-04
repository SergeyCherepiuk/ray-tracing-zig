const std = @import("std");
const Image = @import("../image/image.zig").Image;
const Color = @import("../image/color.zig").Color;
const vec3 = @import("../vec3/vec3.zig");
const Sphere = @import("../objects/sphere.zig").Sphere;
const Ray = @import("../ray/ray.zig").Ray;
const hitColor = @import("../hitable/hitable.zig").hitColor;

const allocator = std.heap.page_allocator;
const spheres = [_]Sphere{
    Sphere{
        .position = vec3.Vec3{ .x = -50 },
        .radius = 50.0,
        .color = Color{ .R = 255 },
    },
    Sphere{
        .position = vec3.Vec3{ .z = -30 },
        .radius = 35.0,
        .color = Color{ .G = 255 },
    },
    Sphere{
        .position = vec3.Vec3{ .x = 200, .z = -50 },
        .radius = 100.0,
        .color = Color{ .B = 255 },
    },
};

pub fn spheresExample() !Image {
    const width: u64 = 300;
    const height: u64 = 300;

    const img = Image{
        .width = width,
        .height = height,
        .pixels = try allocator.alloc(Color, @as(u32, width) * height),
    };

    const camera_position = vec3.Vec3{ .z = 100 };
    const focal_distance: f64 = 50.0;

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
                .add(vec3.up.mulScalar(@floatFromInt(y)))
                .add(vec3.right.mulScalar(@floatFromInt(x)));

            const ray = Ray{
                .origin = &camera_position,
                .direction = pixel_position.sub(camera_position),
            };

            img.pixels[i * width + j] = hitColor(ray, &spheres);
        }
    }

    return img;
}
