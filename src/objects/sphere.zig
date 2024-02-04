const Vec3 = @import("../vec3/vec3.zig").Vec3;
const Color = @import("../image/color.zig").Color;

pub const Sphere = struct {
    position: Vec3,
    radius: f64,
    color: Color,
};
