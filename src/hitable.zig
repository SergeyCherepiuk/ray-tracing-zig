const std = @import("std");

const Ray = @import("objects/ray.zig").Ray;
const Light = @import("objects/light.zig").Light;
const Intersectable = @import("objects/intersectable.zig").Intersectable;

const Color = @import("image.zig").Color;
const Vec3 = @import("vec3.zig").Vec3;

const HitRecord = struct { object: *const Intersectable, point: Vec3 };

pub fn hitColor(
    ray: Ray,
    lights: []const Light,
    objects: []const Intersectable,
) Color {
    var min_hit_distance: f64 = std.math.floatMax(f64);
    var closest_hit: ?HitRecord = null;

    for (objects) |*object| {
        if (object.intersectedBy(ray)) |hit_point| {
            const hit_distance = ray.origin.sub(hit_point).length();
            if (hit_distance < min_hit_distance) {
                min_hit_distance = hit_distance;
                closest_hit = HitRecord{ .object = object, .point = hit_point };
            }
        }
    }

    return if (closest_hit) |hit| lightImpact(ray, hit, objects, lights) else Color{};
}

fn lightImpact(
    ray: Ray,
    hit: HitRecord,
    objects: []const Intersectable,
    lights: []const Light,
) Color {
    var result_color = hit.object.color();

    outer: for (lights) |light| {
        const to_light = light.position.sub(hit.point).normalize();

        const ray_to_light = Ray{ .origin = &hit.point, .direction = to_light };
        for (objects) |*other_object| {
            if (hit.object == other_object) continue;

            const is_blocked = blocked(ray_to_light, other_object.*, light);
            if (is_blocked) continue :outer;
        }

        const normal = hit.object.normalFrom(hit.point);
        result_color = result_color
            .add(diffuse(light, to_light, normal))
            .add(specular(light, to_light, normal, ray.direction));
    }

    return result_color;
}

fn blocked(
    ray_to_light: Ray,
    other_object: Intersectable,
    light: Light,
) bool {
    return if (other_object.intersectedBy(ray_to_light)) |other_object_hit_point| {
        const object_to_light = light.position.sub(ray_to_light.origin.*);
        const other_object_to_light = light.position.sub(other_object_hit_point);

        const same_direction = object_to_light.dot(other_object_to_light) > 0.0;
        const other_object_is_closer = other_object_to_light.length() < object_to_light.length();
        return same_direction and other_object_is_closer;
    } else false;
}

fn diffuse(light: Light, to_light: Vec3, normal: Vec3) Color {
    const light_directness = to_light.dot(normal);
    return if (light_directness > 0.0) {
        return light.color.scale(light_directness);
    } else Color{};
}

fn specular(light: Light, to_light: Vec3, normal: Vec3, ray_direction: Vec3) Color {
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
