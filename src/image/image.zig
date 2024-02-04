const std = @import("std");
const Color = @import("color.zig").Color;

var rng = std.rand.DefaultPrng.init(0);

pub const Image = struct {
    width: u64,
    height: u64,
    pixels: []Color,

    pub fn random(width: u64, height: u64) !Image {
        const allocator = std.heap.page_allocator;
        var pixels = try allocator.alloc(Color, width * height);
        var i: u64 = 0;
        while (i < width * height) : (i += 1) {
            pixels[i] = Color.random();
        }

        return Image{ .width = width, .height = height, .pixels = pixels };
    }
};
