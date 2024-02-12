const std = @import("std");
const vec3 = @import("../vec3/vec3.zig");

const Image = @import("../image/image.zig").Image;
const Color = @import("../image/color.zig").Color;
const World = @import("../objects/world.zig").World;
const Camera = @import("../objects/camera.zig").Camera;
const Ray = @import("ray.zig").Ray;

const closestHitpoint = @import("hitpoint.zig").closestHitpoint;
const lightImpact = @import("light.zig").lightImpact;

// TODO: Make it thread safe and render all cameras concurrently
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub const BackgroupColor = Color{};

pub const RenderError = std.mem.Allocator.Error;

pub fn render(world: World) RenderError![]Image {
    var images = try allocator.alloc(Image, world.cameras.len);
    for (world.cameras, 0..) |camera, i| {
        images[i] = try renderCamera(camera, world);
    }
    return images;
}

fn renderCamera(camera: Camera, world: World) RenderError!Image {
    const pixels_count = camera.screen.width * camera.screen.height;
    const img = Image{
        .width = camera.screen.width,
        .height = camera.screen.height,
        .pixels = try allocator.alloc(Color, pixels_count),
    };

    const screen_center = camera.direction.normalize()
        .mulScalar(camera.focal_length)
        .add(camera.position);

    var i: usize = 0;
    while (i < img.height) : (i += 1) {
        const y: f64 = @as(f64, @floatFromInt(i)) - @as(f64, @floatFromInt(img.height)) / 2.0;

        var j: usize = 0;
        while (j < img.width) : (j += 1) {
            const x: f64 = @as(f64, @floatFromInt(j)) - @as(f64, @floatFromInt(img.width)) / 2.0;

            const pixel_position = screen_center
                .add(camera.down().mulScalar(y))
                .add(camera.left().mulScalar(x));

            const ray = Ray{
                .origin = &camera.position,
                .direction = pixel_position.sub(camera.position),
            };

            const hitpoint = closestHitpoint(ray, world);
            const pixel_color = if (hitpoint) |h| lightImpact(ray, h, world) else BackgroupColor;
            img.pixels[i * @as(usize, img.width) + j] = pixel_color;
        }
    }

    return img;
}
