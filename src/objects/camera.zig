const vec3 = @import("../vec3.zig");

pub const Camera = struct {
    position: vec3.Vec3,
    direction: vec3.Vec3,
    focal_length: f64,
    screen: struct { width: u32, height: u32 },

    pub fn right(self: Camera) vec3.Vec3 {
        return self.direction.cross(vec3.up).normalize();
    }

    pub fn left(self: Camera) vec3.Vec3 {
        return self.right().mulScalar(-1);
    }

    pub fn up(self: Camera) vec3.Vec3 {
        return self.right().cross(self.direction).normalize();
    }

    pub fn down(self: Camera) vec3.Vec3 {
        return self.up().mulScalar(-1);
    }
};
