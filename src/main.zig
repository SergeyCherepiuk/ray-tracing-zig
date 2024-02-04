const std = @import("std");
const sphereExample = @import("examples/sphere.zig").sphereExample;
const ppm = @import("image/ppm.zig");

pub fn main() !void {
    const img = try sphereExample();
    const formated = try ppm.format(img);
    _ = try std.io.getStdOut().write(formated);
}
