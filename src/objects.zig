const std = @import("std");
const Vec3 = @import("vec3.zig").Vec3;
const Color = @import("image.zig").Color;

pub const Scene = struct {
    cameras: []const Camera = &[_]Camera{},
    lights: []const Light = &[_]Light{},
    spheres: []const Sphere = &[_]Sphere{},
};

pub const Camera = struct {
    position: Vec3,
    direction: Vec3,
    focal_length: f64,
    screen: struct { width: u32, height: u32 },
};

pub const Light = struct {
    position: Vec3,
    color: Color,
};

pub const Sphere = struct {
    position: Vec3,
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
