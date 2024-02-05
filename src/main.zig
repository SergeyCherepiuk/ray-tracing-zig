const std = @import("std");
const spheresExample = @import("examples/sphere.zig").spheresExample;
const ppm = @import("ppm.zig");

pub fn main() !void {
    const img = try spheresExample();
    const formated = try ppm.format(img);
    _ = try std.io.getStdOut().write(formated);
}
