const std = @import("std");
const Camera = @import("camera.zig").Camera;
const Light = @import("light.zig").Light;
const intersectable = @import("intersectable.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const AllocationError = std.mem.Allocator.Error;

pub const JsonParsableScene = struct {
    cameras: []const Camera = &[_]Camera{},
    lights: []const Light = &[_]Light{},
    spheres: []const intersectable.Sphere = &[_]intersectable.Sphere{},
    planes: []const intersectable.Plane = &[_]intersectable.Plane{},

    const allocator = gpa.allocator();

    pub fn toScene(self: JsonParsableScene) AllocationError!Scene {
        const objects_count = self.spheres.len + self.planes.len;
        const objects = try allocator.alloc(intersectable.Intersectable, objects_count);

        var i: usize = 0;
        for (self.spheres) |sphere| {
            objects[i] = intersectable.Intersectable{ .sphere = sphere };
            i += 1;
        }
        for (self.planes) |plane| {
            objects[i] = intersectable.Intersectable{ .plane = plane };
            i += 1;
        }

        return Scene{
            .cameras = self.cameras,
            .lights = self.lights,
            .objects = objects,
        };
    }
};

pub const Scene = struct {
    cameras: []const Camera = &[_]Camera{},
    lights: []const Light = &[_]Light{},
    objects: []const intersectable.Intersectable = &[_]intersectable.Intersectable{},
};
