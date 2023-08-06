const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("zig-wren", .{
        .source_file = .{ .path = "src/main.zig" },
    });

    const lib = b.addStaticLibrary(.{
        .name = "zig-wren",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibrary(b.dependency("wren", .{
        .target = target,
        .optimize = optimize,
    }).artifact("wren"));

    lib.linkLibC();
    _ = b.addInstallHeaderFile("wren.h", "include/");
    b.installArtifact(lib);

    const main_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_main_tests = b.addRunArtifact(main_tests);
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_main_tests.step);
}
