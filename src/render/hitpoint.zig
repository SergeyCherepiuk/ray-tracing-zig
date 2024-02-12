const std = @import("std");

const Vec3 = @import("../vec3/vec3.zig").Vec3;
const Ray = @import("ray.zig").Ray;
const World = @import("../objects/world.zig").World;
const Color = @import("../image/color.zig").Color;
const Intersectable = @import("../objects/intersectable.zig").Intersectable;

pub const Hitpoint = struct { point: Vec3, object: Intersectable };

pub fn closestHitpoint(ray: Ray, world: World) ?Hitpoint {
    var min_distance: f64 = std.math.floatMax(f64);
    var hitpoint: ?Hitpoint = null;

    for (world.objects) |object| {
        if (object.intersectedBy(ray)) |point| {
            const distance = ray.origin.sub(point).length();
            if (distance < min_distance) {
                min_distance = distance;
                hitpoint = Hitpoint{ .object = object, .point = point };
            }
        }
    }

    return hitpoint;
}
