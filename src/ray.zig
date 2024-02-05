const std = @import("std");
const Vec3 = @import("vec3.zig").Vec3;
const Sphere = @import("objects.zig").Sphere;

pub const Ray = struct {
    origin: *const Vec3,
    direction: Vec3,

    pub fn intersects(self: Ray, sphere: Sphere) ?Vec3 {
        const oc = sphere.position.sub(self.origin.*);
        const a = self.direction.dot(self.direction);
        const b = 2.0 * oc.dot(self.direction);
        const c = oc.dot(oc) - sphere.radius * sphere.radius;

        const d = b * b - 4.0 * a * c;
        if (d < 0.0) return null;

        const t = (-b - std.math.sqrt(d)) / (2.0 * a);
        return self.origin.*.add(self.direction.mulScalar(-t));
    }
};
