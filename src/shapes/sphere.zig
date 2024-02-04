const vec3 = @import("../vec3/vec3.zig");
const image = @import("../image/image.zig");

pub const Sphere = struct {
    position: vec3.Vec3,
    radius: f64,
    color: image.Color,
};
