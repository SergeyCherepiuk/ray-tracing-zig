const Vec3 = @import("../../vec3/vec3.zig").Vec3;
const Color = @import("../../image/color.zig").Color;
const intersectable = @import("../intersectable.zig");
const id = @import("../../common/id.zig");

pub const JsonParsableSphere = struct {
    position: Vec3,
    radius: f64,
    color: Color,

    pub fn toSphere(self: JsonParsableSphere) intersectable.Sphere {
        return intersectable.Sphere{
            .id = id.new(),
            .position = self.position,
            .radius = self.radius,
            .color = self.color,
        };
    }
};

pub const JsonParsablePlane = struct {
    position: Vec3,
    normal: Vec3,
    color: Color,

    pub fn toPlane(self: JsonParsablePlane) intersectable.Plane {
        return intersectable.Plane{
            .id = id.new(),
            .position = self.position,
            .normal = self.normal,
            .color = self.color,
        };
    }
};
