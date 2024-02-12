const Vec3 = @import("../vec3/vec3.zig").Vec3;
const Color = @import("../image/color.zig").Color;

pub const Light = struct { id: u64, position: Vec3, color: Color };
