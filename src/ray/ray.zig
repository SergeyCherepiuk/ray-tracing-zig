const std = @import("std");
const vec3 = @import("../vec3/vec3.zig");
const Sphere = @import("../shapes/sphere.zig").Sphere;

pub const Ray = struct {
    origin: *const vec3.Vec3,
    direction: vec3.Vec3,

    pub fn intersects(self: Ray, sphere: Sphere) ?vec3.Vec3 {
        const oc = sphere.position.sub(self.origin.*);
        const a = self.direction.dot(self.direction);
        const b = 2.0 * oc.dot(self.direction);
        const c = oc.dot(oc) - sphere.radius * sphere.radius;

        const d = b * b - 4.0 * a * c;
        if (d < 0.0) return null;

        const t = (-b - std.math.sqrt(d)) / 2.0 * a;
        return self.direction.mulScalar(t);
    }
};
