const Vec3 = @import("../vec3.zig").Vec3;

pub const Ray = struct { origin: *const Vec3, direction: Vec3 };
