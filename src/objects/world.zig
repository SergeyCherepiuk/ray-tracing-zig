const Camera = @import("camera.zig").Camera;
const Light = @import("light.zig").Light;
const intersectable = @import("intersectable.zig");

pub const World = struct {
    id: u64,
    cameras: []const Camera = &[_]Camera{},
    lights: []const Light = &[_]Light{},
    objects: []const intersectable.Intersectable = &[_]intersectable.Intersectable{},
};
