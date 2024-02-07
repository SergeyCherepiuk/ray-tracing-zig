const std = @import("std");
const Vec3 = @import("vec3.zig").Vec3;
const Sphere = @import("objects.zig").Sphere;

pub const Ray = struct {
    origin: *const Vec3,
    direction: Vec3,

    pub fn intersects(self: Ray, sphere: Sphere) ?Vec3 {
        const direction_normalized = self.direction.normalize();

        const L = sphere.position.sub(self.origin.*);
        const tc = direction_normalized.dot(L);
        if (tc < 0.0) return null;

        const r2 = sphere.radius * sphere.radius;
        const d2 = L.dot(L) - tc * tc;
        if (d2 > r2) return null;

        const thc = std.math.sqrt(r2 - d2); // Beep boop beep!
        const t0 = tc - thc;
        const t1 = tc + thc;

        // TODO: Approach used from this line of code up until
        // the end of the function is quite inefficient
        const p0 = direction_normalized.mulScalar(t0).add(self.origin.*);
        const p1 = direction_normalized.mulScalar(t1).add(self.origin.*);

        const l0 = p0.sub(self.origin.*).length();
        const l1 = p1.sub(self.origin.*).length();

        return if (l0 < l1) p0 else p1;
    }
};
