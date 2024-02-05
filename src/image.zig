const std = @import("std");

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

pub const Color = struct {
    R: u8 = 0,
    G: u8 = 0,
    B: u8 = 0,

    pub fn random() Color {
        return Color{
            .R = rng.random().int(u8),
            .G = rng.random().int(u8),
            .B = rng.random().int(u8),
        };
    }
};
