const expect = @import("std").testing.expect;
const objects = @import("objects.zig");
const vec3 = @import("vec3.zig");
const Color = @import("image.zig").Color;

test "spheres equality (same)" {
    const s1 = objects.Sphere{ .position = vec3.zero, .radius = 0.0, .color = Color{} };
    const s2 = objects.Sphere{ .position = vec3.zero, .radius = 0.0, .color = Color{} };
    try expect(s1.equals(s2));
}

test "spheres equality (different position)" {
    const s1 = objects.Sphere{ .position = vec3.Vec3{ .x = 0 }, .radius = 0.0, .color = Color{} };
    const s2 = objects.Sphere{ .position = vec3.Vec3{ .x = 1 }, .radius = 0.0, .color = Color{} };
    try expect(!s1.equals(s2));
}

test "spheres equality (different radius)" {
    const s1 = objects.Sphere{ .position = vec3.zero, .radius = 0.0, .color = Color{} };
    const s2 = objects.Sphere{ .position = vec3.zero, .radius = 1.0, .color = Color{} };
    try expect(!s1.equals(s2));
}

test "spheres equality (different color)" {
    const s1 = objects.Sphere{ .position = vec3.zero, .radius = 0.0, .color = Color{ .R = 0 } };
    const s2 = objects.Sphere{ .position = vec3.zero, .radius = 0.0, .color = Color{ .R = 1 } };
    try expect(!s1.equals(s2));
}
