const std = @import("std");

pub fn build(b: *std.Build) void {
    const test_step = b.step("test", "runs all tests");
    addTest(b, test_step, "src/vec3/vec3_test.zig");
    addTest(b, test_step, "src/image/color_test.zig");
}

fn addTest(b: *std.Build, test_step: *std.Build.Step, path: []const u8) void {
    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = path },
    });
    const run_unit_tests = b.addRunArtifact(unit_tests);
    test_step.dependOn(&run_unit_tests.step);
}
