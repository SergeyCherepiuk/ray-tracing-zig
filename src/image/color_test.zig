const expect = @import("std").testing.expect;
const Color = @import("color.zig").Color;

test "colors equality (same)" {
    const c1 = Color{ .R = 50, .G = 75, .B = 100 };
    const c2 = Color{ .R = 50, .G = 75, .B = 100 };
    try expect(c1.equals(c2));
}

test "colors equality (different red)" {
    const c1 = Color{ .R = 50, .G = 75, .B = 100 };
    const c2 = Color{ .R = 100, .G = 75, .B = 100 };
    try expect(!c1.equals(c2));
}

test "colors equality (different green)" {
    const c1 = Color{ .R = 50, .G = 75, .B = 100 };
    const c2 = Color{ .R = 50, .G = 125, .B = 100 };
    try expect(!c1.equals(c2));
}

test "colors equality (different blue)" {
    const c1 = Color{ .R = 50, .G = 75, .B = 100 };
    const c2 = Color{ .R = 50, .G = 75, .B = 150 };
    try expect(!c1.equals(c2));
}

test "colors addition (without overflow)" {
    const c1 = Color{ .R = 50, .G = 75, .B = 100 };
    const c2 = Color{ .R = 75, .G = 100, .B = 50 };

    const actual = c1.add(c2);
    const expected = Color{ .R = 125, .G = 175, .B = 150 };

    try expect(actual.equals(expected));
}

test "colors addition (with overflow)" {
    const c1 = Color{ .R = 250, .G = 75, .B = 100 };
    const c2 = Color{ .R = 75, .G = 200, .B = 50 };

    const actual = c1.add(c2);
    const expected = Color{ .R = 255, .G = 255, .B = 150 };

    try expect(actual.equals(expected));
}

test "color scale (without overflow)" {
    const c = Color{ .R = 50, .G = 75, .B = 100 };
    const f: f64 = 2;

    const actual = c.scale(f);
    const expected = Color{ .R = 100, .G = 150, .B = 200 };

    try expect(actual.equals(expected));
}

test "color scale (with overflow)" {
    const c = Color{ .R = 200, .G = 75, .B = 100 };
    const f: f64 = 2;

    const actual = c.scale(f);
    const expected = Color{ .R = 255, .G = 150, .B = 200 };

    try expect(actual.equals(expected));
}

test "color scale (negative factor)" {
    const c = Color{ .R = 200, .G = 75, .B = 100 };
    const f: f64 = -1.5;

    const actual = c.scale(f);
    const expected = Color{};

    try expect(actual.equals(expected));
}
