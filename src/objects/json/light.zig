const Vec3 = @import("../../vec3/vec3.zig").Vec3;
const Color = @import("../../image/color.zig").Color;
const Light = @import("../light.zig").Light;
const id = @import("../../common/id.zig");

pub const JsonParsableLight = struct {
    position: Vec3,
    color: Color,

    pub fn toLight(self: JsonParsableLight) Light {
        return Light{
            .id = id.new(),
            .position = self.position,
            .color = self.color,
        };
    }
};
