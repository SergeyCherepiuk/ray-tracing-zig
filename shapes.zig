const std = @import("std");
const image = @import("image.zig");

pub fn circle(width: u16, height: u16, radius: u16) !image.Image {
    const allocator = std.heap.page_allocator;

    const img = image.Image{
        .width = width,
        .height = height,
        .pixels = try allocator.alloc(image.Pixel, @as(u32, width) * height),
    };

    const rsq = std.math.pow(u32, @as(u32, radius), 2);

    var i: usize = 0;
    while (i < height) : (i += 1) {
        const y = @as(isize, @intCast(i)) - @divFloor(height, 2);
        const ysq = @as(usize, @intCast(std.math.pow(isize, y, 2)));

        var j: usize = 0;
        while (j < width) : (j += 1) {
            const x = @as(isize, @intCast(j)) - @divFloor(width, 2);
            const xsq = @as(usize, @intCast(std.math.pow(isize, x, 2)));

            const inside = xsq + ysq < rsq;
            img.pixels[i * height + j] = if (inside)
                image.Pixel{ .R = 255, .G = 64, .B = 64 }
            else
                image.Pixel{ .R = 255, .G = 255, .B = 255 };
        }
    }

    return img;
}
