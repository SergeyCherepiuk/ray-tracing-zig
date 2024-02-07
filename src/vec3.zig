const std = @import("std");

pub const zero = Vec3{};
pub const right = Vec3{ .x = 1 };
pub const left = Vec3{ .x = -1 };
pub const up = Vec3{ .y = 1 };
pub const down = Vec3{ .y = -1 };
pub const forward = Vec3{ .z = 1 };
pub const backward = Vec3{ .z = -1 };

const epsilon = 1e-9;

pub const Vec3 = struct {
    x: f64 = 0.0,
    y: f64 = 0.0,
    z: f64 = 0.0,

    pub fn add(self: Vec3, other: Vec3) Vec3 {
        return Vec3{
            .x = self.x + other.x,
            .y = self.y + other.y,
            .z = self.z + other.z,
        };
    }

    pub fn sub(self: Vec3, other: Vec3) Vec3 {
        return Vec3{
            .x = self.x - other.x,
            .y = self.y - other.y,
            .z = self.z - other.z,
        };
    }

    pub fn dot(self: Vec3, other: Vec3) f64 {
        return self.x * other.x +
            self.y * other.y +
            self.z * other.z;
    }

    pub fn cross(self: Vec3, other: Vec3) Vec3 {
        return Vec3{
            .x = self.y * other.z - self.z * other.y,
            .y = self.z * other.x - self.x * other.z,
            .z = self.x * other.y - self.y * other.x,
        };
    }

    pub fn mulScalar(self: Vec3, scalar: f64) Vec3 {
        return Vec3{
            .x = self.x * scalar,
            .y = self.y * scalar,
            .z = self.z * scalar,
        };
    }

    pub fn divScalar(self: Vec3, scalar: f64) Vec3 {
        if (scalar == 0) return zero;

        return Vec3{
            .x = self.x / scalar,
            .y = self.y / scalar,
            .z = self.z / scalar,
        };
    }

    pub fn length(self: Vec3) f64 {
        const xsq = self.x * self.x;
        const ysq = self.y * self.y;
        const zsq = self.z * self.z;
        return std.math.sqrt(xsq + ysq + zsq);
    }

    pub fn normalize(self: Vec3) Vec3 {
        return self.divScalar(self.length());
    }

    pub fn equals(self: Vec3, other: Vec3) bool {
        return std.math.approxEqAbs(f64, self.x, other.x, epsilon) and
            std.math.approxEqAbs(f64, self.y, other.y, epsilon) and
            std.math.approxEqAbs(f64, self.z, other.z, epsilon);
    }
};
