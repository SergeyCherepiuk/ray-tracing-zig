const std = @import("std");
const vec3 = @import("vec3.zig");
const Color = @import("image.zig").Color;

pub const Scene = struct {
    cameras: []const Camera = &[_]Camera{},
    lights: []const Light = &[_]Light{},
    spheres: []const Sphere = &[_]Sphere{},
};

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

pub const Light = struct {
    position: vec3.Vec3,
    color: Color,
};

pub const Sphere = struct {
    position: vec3.Vec3,
    radius: f64,
    color: Color,

    pub fn equals(self: Sphere, other: Sphere) bool {
        const same_position = self.position.x == other.position.x and
            self.position.y == other.position.y and
            self.position.z == other.position.z;
        const same_radius = std.math.approxEqAbs(f64, self.radius, other.radius, 1e-9);
        const same_color = self.color.R == other.color.R and
            self.color.G == other.color.G and
            self.color.B == other.color.B;
        return same_position and same_radius and same_color;
    }
};
