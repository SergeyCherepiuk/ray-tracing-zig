const Vec3 = @import("../vec3.zig").Vec3;
const Color = @import("../image.zig").Color;
const Ray = @import("ray.zig").Ray;

pub const Intersectable = union(enum) {
    sphere: Sphere,
    plane: Plane,

    pub fn position(self: Intersectable) Vec3 {
        return switch (self) {
            .sphere => |s| s.position,
            .plane => |p| p.position,
        };
    }

    pub fn color(self: Intersectable) Color {
        return switch (self) {
            .sphere => |s| s.color,
            .plane => |p| p.color,
        };
    }

    pub fn normalFrom(self: Intersectable, point: Vec3) Vec3 {
        return switch (self) {
            .sphere => |s| s.normalFrom(point),
            .plane => |p| p.normalFrom(point),
        };
    }

    pub fn intersectedBy(self: Intersectable, ray: Ray) ?Vec3 {
        return switch (self) {
            .sphere => |s| s.intersectedBy(ray),
            .plane => |p| p.intersectedBy(ray),
        };
    }
};

pub const Sphere = struct {
    position: Vec3,
    radius: f64,
    color: Color,

    pub fn normalFrom(self: Sphere, point: Vec3) Vec3 {
        return point.sub(self.position).normalize();
    }

    pub fn intersectedBy(self: Sphere, ray: Ray) ?Vec3 {
        const direction_normalized = ray.direction.normalize();

        const L = self.position.sub(ray.origin.*);
        const tc = direction_normalized.dot(L);
        if (tc < 0.0) return null;

        const r2 = self.radius * self.radius;
        const d2 = L.dot(L) - tc * tc;
        if (d2 > r2) return null;

        const thc = @sqrt(r2 - d2); // Beep boop beep!
        const t0 = tc - thc;
        const t1 = tc + thc;

        // TODO: Approach used from this line of code up until
        // the end of the function is quite inefficient
        const p0 = direction_normalized.mulScalar(t0).add(ray.origin.*);
        const p1 = direction_normalized.mulScalar(t1).add(ray.origin.*);

        const l0 = p0.sub(ray.origin.*).length();
        const l1 = p1.sub(ray.origin.*).length();

        return if (l0 < l1) p0 else p1;
    }
};

pub const Plane = struct {
    position: Vec3,
    normal: Vec3,
    color: Color,

    pub fn normalFrom(self: Plane, _: Vec3) Vec3 {
        return self.normal.normalize();
    }

    pub fn intersectedBy(self: Plane, ray: Ray) ?Vec3 {
        const eps = 1e-9;

        const ray_direction_normalized = ray.direction.normalize();
        const plane_normal_normalized = self.normal.normalize();

        const denominator = ray_direction_normalized.dot(plane_normal_normalized);
        if (@fabs(denominator) < eps) return null;

        const L = self.position.sub(ray.origin.*);
        const t = plane_normal_normalized.dot(L) / denominator;
        if (t < eps) return null;

        return ray_direction_normalized.mulScalar(t).add(ray.origin.*);
    }
};
