const std = @import("std");
const objects = @import("objects.zig");
const image = @import("image.zig");
const vec3 = @import("vec3.zig");
const Ray = @import("ray.zig").Ray;
const hitColor = @import("hitable.zig").hitColor;

// TODO: Make it thread safe and render all cameras concurrently
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn render(scene: objects.Scene) ![]image.Image {
    var images = try allocator.alloc(image.Image, scene.cameras.len);
    for (scene.cameras, 0..) |camera, i| {
        images[i] = try renderCamera(camera, scene.lights, scene.spheres);
    }
    return images;
}

fn renderCamera(
    camera: objects.Camera,
    lights: []const objects.Light,
    spheres: []const objects.Sphere,
) !image.Image {
    const img = image.Image{
        .width = camera.screen.width,
        .height = camera.screen.height,
        .pixels = try allocator.alloc(
            image.Color,
            camera.screen.width * camera.screen.height,
        ),
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
                .add(vec3.down.mulScalar(y))
                .add(vec3.right.mulScalar(x));

            const ray = Ray{
                .origin = &camera.position,
                .direction = pixel_position.sub(camera.position),
            };

            img.pixels[i * @as(usize, img.width) + j] = hitColor(ray, lights, spheres);
        }
    }

    return img;
}
