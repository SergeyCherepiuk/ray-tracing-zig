const std = @import("std");
// const image = @import("image/image.zig");
// const shapes2d = @import("image/shapes2.zig");
const shapes3d = @import("image/shapes3d.zig");
const ppm = @import("image/ppm.zig");

pub fn main() !void {
    // const img = try image.Image.random(300, 300);
    // const img = try shapes2d.circle(300, 300, 50);
    const img = try shapes3d.sphere(500, 500, 50.0);

    const formated = try ppm.format(img);
    _ = try std.io.getStdOut().write(formated);
}
