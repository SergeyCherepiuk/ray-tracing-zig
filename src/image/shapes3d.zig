const std = @import("std");
const image = @import("image.zig");
const vec3 = @import("../vec3/vec3.zig");

pub fn sphere(width: u16, height: u16, sphere_radius: f64) !image.Image {
    const allocator = std.heap.page_allocator;

    const img = image.Image{
        .width = width,
        .height = height,
        .pixels = try allocator.alloc(image.Pixel, @as(u32, width) * height),
    };

    const sphere_position = vec3.zero;
    const camera_position = vec3.Vec3{ .z = -20 };
    const camera_sphere_distance = sphere_position.sub(camera_position);
    const focal_distance: f64 = 25.0;

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

            const ray_direction = pixel_position.sub(camera_position);

            const is_intersecting = isIntersecting(
                camera_sphere_distance,
                ray_direction,
                sphere_radius,
            );

            img.pixels[i * width + j] = if (is_intersecting)
                image.Pixel{ .R = 255, .G = 64, .B = 64 }
            else
                image.Pixel{ .R = 255, .G = 255, .B = 255 };
        }
    }

    return img;
}

fn isIntersecting(
    camera_sphere_distance: vec3.Vec3,
    ray_direction: vec3.Vec3,
    sphere_radius: f64,
) bool {
    const csd = camera_sphere_distance;

    const a = ray_direction.dot(ray_direction);
    const b = 2.0 * csd.dot(ray_direction);
    const c = csd.dot(csd) - sphere_radius * sphere_radius;

    const discriminant = b * b - 4.0 * a * c;

    return discriminant >= 0.0;
}
