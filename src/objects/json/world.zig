const std = @import("std");
const intersectable = @import("../intersectable.zig");
const jsonintersectable = @import("intersectable.zig");
const id = @import("../../common/id.zig");

const JsonParsableCamera = @import("camera.zig").JsonParsableCamera;
const JsonParsableLight = @import("light.zig").JsonParsableLight;

const Camera = @import("../camera.zig").Camera;
const Light = @import("../light.zig").Light;
const World = @import("../world.zig").World;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub const JsonParsableWorld = struct {
    cameras: []const JsonParsableCamera = &[_]JsonParsableCamera{},
    lights: []const JsonParsableLight = &[_]JsonParsableLight{},
    spheres: []const jsonintersectable.JsonParsableSphere = &[_]jsonintersectable.JsonParsableSphere{},
    planes: []const jsonintersectable.JsonParsablePlane = &[_]jsonintersectable.JsonParsablePlane{},

    pub const ConversionError = std.mem.Allocator.Error;

    pub fn toWorld(self: JsonParsableWorld) ConversionError!World {
        const cameras = try allocator.alloc(Camera, self.cameras.len);
        for (self.cameras, 0..) |camera, i| {
            cameras[i] = camera.toCamera();
        }

        const lights = try allocator.alloc(Light, self.lights.len);
        for (self.lights, 0..) |light, i| {
            lights[i] = light.toLight();
        }

        const objects_count = self.spheres.len + self.planes.len;
        const objects = try allocator.alloc(intersectable.Intersectable, objects_count);
        var i: usize = 0;
        for (self.spheres) |sphere| {
            objects[i] = intersectable.Intersectable{ .sphere = sphere.toSphere() };
            i += 1;
        }
        for (self.planes) |plane| {
            objects[i] = intersectable.Intersectable{ .plane = plane.toPlane() };
            i += 1;
        }

        return World{
            .id = id.new(),
            .cameras = cameras,
            .lights = lights,
            .objects = objects,
        };
    }
};
