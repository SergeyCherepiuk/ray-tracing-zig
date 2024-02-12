const std = @import("std");
const shadow = @import("shadow.zig");

const Ray = @import("ray.zig").Ray;
const Hitpoint = @import("hitpoint.zig").Hitpoint;
const World = @import("../objects/world.zig").World;
const Color = @import("../image/color.zig").Color;
const Light = @import("../objects/light.zig").Light;

pub fn lightImpact(ray: Ray, hitpoint: Hitpoint, world: World) Color {
    var result_color = hitpoint.object.color();

    for (world.lights) |light| {
        if (shadow.isShadowed(hitpoint, light, world.objects)) continue;

        result_color = result_color
            .add(diffuse(hitpoint, light))
            .add(specular(ray, hitpoint, light));
    }

    return result_color;
}

fn diffuse(hitpoint: Hitpoint, light: Light) Color {
    const to_light = light.position.sub(hitpoint.point);
    const normal = hitpoint.object.normalFrom(hitpoint.point);

    const light_directness = to_light.normalize().dot(normal);
    if (light_directness <= 0.0) return Color{};

    return light.color.scale(light_directness);
}

fn specular(ray: Ray, hitpoint: Hitpoint, light: Light) Color {
    const to_light = light.position.sub(hitpoint.point);
    const to_light_normalized = to_light.normalize();
    const normal = hitpoint.object.normalFrom(hitpoint.point);

    const light_directness = to_light_normalized.dot(normal);
    if (light_directness <= 0.0) return Color{};

    const specular_exponent = 50;
    var specular_coefficient = normal
        .mulScalar(2.0 * light_directness)
        .sub(to_light_normalized)
        .dot(ray.direction.normalize());
    specular_coefficient = std.math.pow(f64, specular_coefficient, specular_exponent);

    if (specular_coefficient <= 0.0) return Color{};

    return light.color.scale(specular_coefficient);
}
