const Color = @import("../image/color.zig").Color;
const Hitpoint = @import("../render/hitpoint.zig").Hitpoint;
const Light = @import("../objects/light.zig").Light;
const Intersectable = @import("../objects/intersectable.zig").Intersectable;
const Ray = @import("ray.zig").Ray;

pub fn isShadowed(hitpoint: Hitpoint, light: Light, objects: []const Intersectable) bool {
    const object_to_light = light.position.sub(hitpoint.point);
    const ray_to_light = Ray{
        .origin = &hitpoint.point,
        .direction = object_to_light.normalize(),
    };

    for (objects) |other_object| {
        if (hitpoint.object.id() == other_object.id()) continue;

        if (other_object.intersectedBy(ray_to_light)) |_| {
            const other_object_to_light = light.position.sub(other_object.position());
            const same_direction = object_to_light.dot(other_object_to_light) > 0.0;
            const other_object_is_closer = other_object_to_light.length() < object_to_light.length();
            if (same_direction and other_object_is_closer) return true;
        }
    }
    return false;
}
