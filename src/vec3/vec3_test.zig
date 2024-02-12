const std = @import("std");
const vec3 = @import("vec3.zig");
const expect = std.testing.expect;
const approxEqAbs = std.math.approxEqAbs;

test "vectors addition" {
    const v1 = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 5.6 };
    const v2 = vec3.Vec3{ .x = -1.2, .y = 1.4, .z = 0 };

    const actual = v1.add(v2);
    const expected = vec3.Vec3{ .x = 0.0, .y = 4.8, .z = 5.6 };

    try expect(actual.equals(expected));
}

test "vectors subtraction" {
    const v1 = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 5.6 };
    const v2 = vec3.Vec3{ .x = -1.2, .y = 1.4, .z = 0 };

    const actual = v1.sub(v2);
    const expected = vec3.Vec3{ .x = 2.4, .y = 2.0, .z = 5.6 };

    try expect(actual.equals(expected));
}

test "vectors dot product" {
    const v1 = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 5.6 };
    const v2 = vec3.Vec3{ .x = -1.2, .y = 1.4, .z = 0 };

    const actual = v1.dot(v2);
    const expected: f64 = 3.32;

    try expect(actual == expected);
}

test "vectors cross product" {
    const v1 = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 5.6 };
    const v2 = vec3.Vec3{ .x = -1.2, .y = 1.4, .z = 0 };

    const actual = v1.cross(v2);
    const expected = vec3.Vec3{ .x = -7.84, .y = -6.72, .z = 5.76 };

    try expect(actual.equals(expected));
}

test "vector multiplication by a scalar (positive scalar)" {
    const v = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 5.6 };
    const s: f64 = 2.6;

    const actual = v.mulScalar(s);
    const expected = vec3.Vec3{ .x = 3.12, .y = 8.84, .z = 14.56 };

    try expect(actual.equals(expected));
}

test "vector multiplication by a scalar (negative scalar)" {
    const v = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 5.6 };
    const s: f64 = -2.6;

    const actual = v.mulScalar(s);
    const expected = vec3.Vec3{ .x = -3.12, .y = -8.84, .z = -14.56 };

    try expect(actual.equals(expected));
}

test "vector division by a scalar (non zero scalar)" {
    const v = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 5.6 };
    const s: f64 = 2.0;

    const actual = v.divScalar(s);
    const expected = vec3.Vec3{ .x = 0.6, .y = 1.7, .z = 2.8 };

    try expect(actual.equals(expected));
}

test "vector division by a scalar (zero scalar)" {
    const v = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 5.6 };
    const s: f64 = 0.0;

    const actual = v.divScalar(s);
    const expected = vec3.zero;

    try expect(actual.equals(expected));
}

test "vector normalization" {
    const v = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 5.6 };

    const actual = v.normalize();
    const expected = vec3.Vec3{
        .x = 0.18017124406,
        .y = 0.51048519151,
        .z = 0.84079913897,
    };

    try expect(actual.equals(expected));
}

test "vector length" {
    const v = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 5.6 };

    const actual = v.length();
    const expected: f64 = 6.660330322;

    const equal = approxEqAbs(f64, actual, expected, 1e-9);
    try expect(equal);
}

test "vectors equality (same)" {
    const v1 = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 5.6 };
    const v2 = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 5.6 };
    try expect(v1.equals(v2));
}

test "vectors equality (different x)" {
    const v1 = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 5.6 };
    const v2 = vec3.Vec3{ .x = 2.4, .y = 3.4, .z = 5.6 };
    try expect(!v1.equals(v2));
}

test "vectors equality (different y)" {
    const v1 = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 5.6 };
    const v2 = vec3.Vec3{ .x = 1.2, .y = 6.8, .z = 5.6 };
    try expect(!v1.equals(v2));
}

test "vectors equality (different z)" {
    const v1 = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 5.6 };
    const v2 = vec3.Vec3{ .x = 1.2, .y = 3.4, .z = 11.2 };
    try expect(!v1.equals(v2));
}
