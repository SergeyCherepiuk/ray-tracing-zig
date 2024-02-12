const Vec3 = @import("../../vec3/vec3.zig").Vec3;
const camera = @import("../camera.zig");
const id = @import("../../common/id.zig");

pub const JsonParsableCamera = struct {
    position: Vec3,
    direction: Vec3,
    focal_length: f64,
    screen: struct { width: u32, height: u32 },

    pub fn toCamera(self: JsonParsableCamera) camera.Camera {
        return camera.Camera{
            .id = id.new(),
            .position = self.position,
            .direction = self.direction,
            .focal_length = self.focal_length,
            .screen = camera.Screen{
                .width = self.screen.width,
                .height = self.screen.height,
            },
        };
    }
};
