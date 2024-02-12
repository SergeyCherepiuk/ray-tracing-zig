const Color = @import("color.zig").Color;

pub const Image = struct { width: u64, height: u64, pixels: []Color };
