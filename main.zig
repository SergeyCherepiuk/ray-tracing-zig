const std = @import("std");
const image = @import("image.zig");
const ppm = @import("ppm.zig");

pub fn main() !void {
    const img = try image.Image.random();
    std.debug.print("{s}", .{try ppm.format(img)});
}

fn printCircle() void {
    const width: i64 = 64;
    const height: i64 = 48;
    const radius: i64 = 10;

    var i: i64 = 0;
    while (i < height) : (i += 1) {
        const y: i64 = i - height / 2;

        var j: i64 = 0;
        while (j < width) : (j += 1) {
            const x: i64 = j - width / 2;

            const xsq = std.math.pow(i64, x, 2);
            const ysq = std.math.pow(i64, y, 2);
            const rsq = std.math.pow(i64, radius, 2);

            const insideCircle = @divFloor(xsq, 4) + ysq < rsq;

            std.debug.print("{s}", .{if (insideCircle) "#" else "."});
        }
        std.debug.print("\n", .{});
    }
}
