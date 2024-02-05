const std = @import("std");
const Image = @import("image.zig").Image;

/// Size of a single pixel record in bits. The size includes padding (if applicable)
/// and a new line character for each record.
const PixelRecordSize = 12;

pub const FormatError = error{
    OutOfMemory,
    NoSpaceLeft,
};

pub fn format(img: Image) FormatError![]const u8 {
    const allocator = std.heap.page_allocator;

    const header: []const u8 = try std.fmt.allocPrint(
        allocator,
        "P3\n{d} {d}\n255\n",
        .{ img.width, img.height },
    );

    const content_size = img.height * img.width * PixelRecordSize;
    const content: []u8 = try allocator.alloc(u8, content_size);

    for (img.pixels, 0..) |pixel, i| {
        const record = try std.fmt.bufPrint(
            try allocator.alloc(u8, PixelRecordSize),
            "{d:3} {d:3} {d:3}\n",
            .{ pixel.R, pixel.G, pixel.B },
        );

        const start = i * PixelRecordSize;
        const end = start + PixelRecordSize;
        std.mem.copy(u8, content[start..end], record);
    }

    return concat(header, content);
}

fn concat(s1: []const u8, s2: []const u8) ![]const u8 {
    const allocator = std.heap.page_allocator;
    const buf = try allocator.alloc(u8, s1.len + s2.len);
    std.mem.copy(u8, buf[0..s1.len], s1);
    std.mem.copy(u8, buf[s1.len..], s2);
    return buf;
}