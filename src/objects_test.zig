const expect = @import("std").testing.expect;
const objects = @import("objects.zig");
const vec3 = @import("vec3.zig");
const Color = @import("image.zig").Color;

test "camera right direction" {
    const c = objects.Camera{
        .position = vec3.zero,
        .direction = vec3.Vec3{ .x = 150.25, .y = -15.70, .z = 10.44 },
        .focal_length = 0,
        .screen = .{ .width = 0, .height = 0 },
    };

    const actual = c.right();
    const expected = vec3.Vec3{ .x = -0.069317061, .y = 0, .z = 0.997594679 };

    try expect(actual.equals(expected));
}

test "camera left direction" {
    const c = objects.Camera{
        .position = vec3.zero,
        .direction = vec3.Vec3{ .x = 150.25, .y = -15.70, .z = 10.44 },
        .focal_length = 0,
        .screen = .{ .width = 0, .height = 0 },
    };

    const actual = c.left();
    const expected = vec3.Vec3{ .x = 0.069317061, .y = 0, .z = -0.997594679 };

    try expect(actual.equals(expected));
}

test "camera up direction" {
    const c = objects.Camera{
        .position = vec3.zero,
        .direction = vec3.Vec3{ .x = 150.25, .y = -15.70, .z = 10.44 },
        .focal_length = 0,
        .screen = .{ .width = 0, .height = 0 },
    };

    const actual = c.up();
    const expected = vec3.Vec3{ .x = 0.103430012, .y = 0.994610769, .z = 0.007186750 };

    try expect(actual.equals(expected));
}

test "camera down direction" {
    const c = objects.Camera{
        .position = vec3.zero,
        .direction = vec3.Vec3{ .x = 150.25, .y = -15.70, .z = 10.44 },
        .focal_length = 0,
        .screen = .{ .width = 0, .height = 0 },
    };

    const actual = c.down();
    const expected = vec3.Vec3{ .x = -0.103430012, .y = -0.994610769, .z = -0.007186750 };

    try expect(actual.equals(expected));
}

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
