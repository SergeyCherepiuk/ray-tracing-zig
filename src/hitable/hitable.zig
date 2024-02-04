const std = @import("std");
const Ray = @import("../ray/ray.zig").Ray;
const Sphere = @import("../objects/sphere.zig").Sphere;
const Color = @import("../image/color.zig").Color;

pub fn hitColor(ray: Ray, spheres: []const Sphere) Color {
    var min_hit_distance: f64 = std.math.floatMax(f64);
    var hit_color = Color{ .R = 255, .G = 255, .B = 255 };

    for (spheres) |sphere| {
        if (ray.intersects(sphere)) |hit_point| {
            const hit_distance = ray.origin.sub(hit_point).length();
            if (hit_distance < min_hit_distance) {
                min_hit_distance = hit_distance;
                hit_color = sphere.color;
            }
        }
    }

    return hit_color;
}
