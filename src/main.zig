const std = @import("std");
const JsonParsableScene = @import("objects/scene.zig").JsonParsableScene;
const render = @import("render.zig").render;
const ppm = @import("ppm.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn main() !void {
    var args = std.process.args();
    _ = args.skip();

    const manifest_path = args.next() orelse return error.NoManifest;
    const save_dir_path = args.next() orelse return error.NoSaveDir;

    const max_size = std.math.maxInt(u64);
    const manifest = try std.fs.cwd().readFileAlloc(allocator, manifest_path, max_size);

    var save_dir = try std.fs.cwd().makeOpenPath(save_dir_path, .{});
    defer save_dir.close();
    errdefer std.fs.cwd().deleteDir(save_dir_path) catch {};

    const parsed = try std.json.parseFromSlice(JsonParsableScene, allocator, manifest, .{});
    const scene = try parsed.value.toScene();
    for (try render(scene), 0..) |image, i| {
        const image_name = try std.fmt.allocPrint(allocator, "camera-{d}.ppm", .{i});
        const ppm_formatted_image = try ppm.format(image);
        try save_dir.writeFile(image_name, ppm_formatted_image);
    }
}
