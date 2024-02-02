const std = @import("std");
var rng = std.rand.DefaultPrng.init(0);

pub const Image = struct {
    width: u64,
    height: u64,
    pixels: []Pixel,

    pub fn random(width: u64, height: u64) !Image {
        const allocator = std.heap.page_allocator;
        var pixels = try allocator.alloc(Pixel, width * height);
        var i: u64 = 0;
        while (i < width * height) : (i += 1) {
            pixels[i] = Pixel.random();
        }

        return Image{ .width = width, .height = height, .pixels = pixels };
    }
};

pub const Pixel = struct {
    R: u8,
    G: u8,
    B: u8,

    pub fn random() Pixel {
        return Pixel{
            .R = rng.random().int(u8),
            .G = rng.random().int(u8),
            .B = rng.random().int(u8),
        };
    }
};
