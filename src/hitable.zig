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
        return lightImpact(hit.sphere, hit.point, spheres, lights);
    } else Color{};
}

fn lightImpact(
    sphere: objects.Sphere,
    hit_point: Vec3,
    spheres: []const objects.Sphere,
    lights: []const objects.Light,
) Color {
    var result_color = sphere.color;

    outer: for (lights) |light| {
        const to_light = light.position.sub(hit_point).normalize();

        const ray = Ray{ .origin = &hit_point, .direction = to_light };
        for (spheres) |other_sphere| {
            if (other_sphere.equals(sphere)) continue;
            if (blocked(ray, light, sphere, other_sphere)) continue :outer;
        }

        const normal = sphere.position.sub(hit_point).mulScalar(-1).normalize();
        const light_directness = to_light.dot(normal);
        if (light_directness <= 0.0) continue;

        result_color = sphere.color.add(light.color.scale(light_directness));
    }

    return result_color;
}

fn blocked(
    ray: Ray,
    light: objects.Light,
    sphere: objects.Sphere,
    other_sphere: objects.Sphere,
) bool {
    return if (ray.intersects(other_sphere)) |_| {
        const other_sphere_to_light = light.position.sub(other_sphere.position);
        const sphere_to_light = light.position.sub(sphere.position);
        return other_sphere_to_light.length() < sphere_to_light.length();
    } else false;
}
