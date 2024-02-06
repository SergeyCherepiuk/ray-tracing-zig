const std = @import("std");
const Ray = @import("ray.zig").Ray;
const objects = @import("objects.zig");
const Color = @import("image.zig").Color;
const Vec3 = @import("vec3.zig").Vec3;

const HitRecord = struct { sphere: objects.Sphere, point: Vec3 };

pub fn hitColor(
    ray: Ray,
    lights: []const objects.Light,
    spheres: []const objects.Sphere,
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
        return lightImpact(hit.sphere, hit.point, ray.direction, spheres, lights);
    } else Color{};
}

fn lightImpact(
    sphere: objects.Sphere,
    hit_point: Vec3,
    ray_direction: Vec3,
    spheres: []const objects.Sphere,
    lights: []const objects.Light,
) Color {
    var result_color = sphere.color;

    outer: for (lights) |light| {
        const to_light = light.position.sub(hit_point).normalize();

        const ray_to_light = Ray{ .origin = &hit_point, .direction = to_light };
        for (spheres) |other_sphere| {
            if (other_sphere.equals(sphere)) continue;
            if (blocked(ray_to_light, light, sphere, other_sphere)) continue :outer;
        }

        const normal = sphere.position.sub(hit_point).mulScalar(-1).normalize();
        result_color = result_color
            .add(diffuse(light, to_light, normal))
            .add(specular(light, to_light, normal, ray_direction));
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

fn diffuse(light: objects.Light, to_light: Vec3, normal: Vec3) Color {
    const light_directness = to_light.dot(normal);
    return if (light_directness > 0.0) {
        return light.color.scale(light_directness);
    } else Color{};
}

fn specular(light: objects.Light, to_light: Vec3, normal: Vec3, ray_direction: Vec3) Color {
    const light_directness = to_light.dot(normal);
    if (light_directness <= 0) return Color{};

    const specular_exponent = 50;
    var specular_coefficient = normal
        .mulScalar(2.0 * light_directness)
        .sub(to_light)
        .dot(ray_direction.normalize());
    specular_coefficient = std.math.pow(f64, specular_coefficient, specular_exponent);

    return if (specular_coefficient > 0.0) {
        return light.color.scale(specular_coefficient);
    } else Color{};
}
