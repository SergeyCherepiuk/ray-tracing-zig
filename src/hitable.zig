const std = @import("std");
const Ray = @import("ray.zig").Ray;
const objects = @import("objects.zig");
const Color = @import("image.zig").Color;
const Vec3 = @import("vec3.zig").Vec3;

const HitRecord = struct { sphere: objects.Sphere, point: Vec3 };

pub fn hitColor(
    ray: Ray,
    spheres: []const objects.Sphere,
    lights: []const objects.Light,
) Color {
    var min_hit_distance: f64 = std.math.floatMax(f64);
    var closest_hit: ?HitRecord = null;

    for (spheres) |sphere| {
        if (ray.intersects(sphere)) |hit_point| {
            const hit_distance = ray.origin.sub(hit_point).length();
            if (hit_distance < min_hit_distance) {
                min_hit_distance = hit_distance;
                closest_hit = HitRecord{ .sphere = sphere, .point = hit_point };
            }
        }
    }

    return if (closest_hit) |hit| {
        return lightImpact(hit.sphere, hit.point, lights);
    } else Color{};
}

// TODO: Implement light to be blocked by another sphere
fn lightImpact(
    sphere: objects.Sphere,
    hit_point: Vec3,
    lights: []const objects.Light,
) Color {
    var result_color = sphere.color;

    for (lights) |light| {
        const to_light = light.position.sub(hit_point).normalize();
        const normal = sphere.position.sub(hit_point).mulScalar(-1).normalize();
        const light_directness = to_light.dot(normal);
        if (light_directness <= 0.0) continue;

        result_color = Color{
            .R = @min(result_color.R + @as(u64, @intFromFloat(@as(f64, @floatFromInt(light.color.R)) * light_directness)), 255),
            .G = @min(result_color.G + @as(u64, @intFromFloat(@as(f64, @floatFromInt(light.color.G)) * light_directness)), 255),
            .B = @min(result_color.B + @as(u64, @intFromFloat(@as(f64, @floatFromInt(light.color.B)) * light_directness)), 255),
        };
    }

    return result_color;
}
