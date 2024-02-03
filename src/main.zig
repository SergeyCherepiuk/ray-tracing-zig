const std = @import("std");
// const image = @import("image/image.zig");
const shapes2d = @import("image/shapes2.zig");
const ppm = @import("image/ppm.zig");

pub fn main() !void {
    // const img = try image.Image.random(300, 300);
    const img = try shapes2d.circle(300, 300, 50);

    const formated = try ppm.format(img);
    _ = try std.io.getStdOut().write(formated);
}
