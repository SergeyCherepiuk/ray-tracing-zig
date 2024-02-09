const Vec3 = @import("../vec3.zig").Vec3;
const Color = @import("../image.zig").Color;

pub const Light = struct { position: Vec3, color: Color };
