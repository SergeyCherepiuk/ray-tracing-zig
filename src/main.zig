const std = @import("std");
const spheresScene = @import("scenes/spheres.zig").spheresScene;
const ppm = @import("ppm.zig");

pub fn main() !void {
    const img = try spheresScene();
    const formated = try ppm.format(img);
    _ = try std.io.getStdOut().write(formated);
}
