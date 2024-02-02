const std = @import("std");
// const image = @import("image.zig");
const shapes = @import("shapes.zig");
const ppm = @import("ppm.zig");

pub fn main() !void {
    // const img = try image.Image.random(300, 300);
    const img = try shapes.circle(300, 300, 50);

    const formated = try ppm.format(img);
    _ = try std.io.getStdOut().write(formated);
}
