const c = @import("c.zig");
const std = @import("std");
const Self = @This();

internal_config: c.WrenConfiguration,

fn defaultReallocate(ptr: ?*anyopaque, newSize: usize, _: ?*anyopaque) callconv(.C) ?*anyopaque {
    // alloc = std.c.
    if (newSize == 0) {
        std.c.free(ptr);
        return null;
    }

    return std.c.realloc(ptr, newSize);
}

test "Init with default configuration" {
    var cfg = newConfig(
        10000,
        10000,
        50,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
    );

    try std.testing.expect(cfg.internal_config.initialHeapSize == 10000);
    try std.testing.expect(cfg.internal_config.minHeapSize == 10000);
}

pub fn newConfig(
    initial_heap_size: usize,
    min_heap_size: usize,
    heap_growth_percent: c_int,
    reallocateFn: ?*const fn (
        ?*anyopaque,
        usize,
        ?*anyopaque,
    ) callconv(.C) ?*anyopaque,
    resolveModuleFn: ?*const fn (
        ?*c.WrenVM,
        [*c]const u8,
        [*c]const u8,
    ) callconv(.C) [*c]const u8,
    loadModuleFn: ?*const fn (
        ?*c.WrenVM,
        [*c]const u8,
    ) callconv(.C) c.WrenLoadModuleResult,
    bindForeignMethodFn: ?*const fn (
        ?*c.WrenVM,
        [*c]const u8,
        [*c]const u8,
        bool,
        [*c]const u8,
    ) callconv(.C) c.WrenForeignMethodFn,
    bindForeignClassFn: ?*const fn (
        ?*c.WrenVM,
        [*c]const u8,
        [*c]const u8,
    ) callconv(.C) c.WrenForeignClassMethods,
    writeFn: ?*const fn (
        ?*c.WrenVM,
        [*c]const u8,
    ) callconv(.C) void,
    errorFn: ?*const fn (
        ?*c.WrenVM,
        c.WrenErrorType,
        [*c]const u8,
        c_int,
        [*c]const u8,
    ) callconv(.C) void,
) Self {
    var cfg = .{
        .initialHeapSize = initial_heap_size,
        .minHeapSize = min_heap_size,
        .heapGrowthPercent = heap_growth_percent,
        .reallocateFn = if (reallocateFn == null) defaultReallocate else reallocateFn,
        .resolveModuleFn = resolveModuleFn,
        .loadModuleFn = loadModuleFn,
        .bindForeignMethodFn = bindForeignMethodFn,
        .bindForeignClassFn = bindForeignClassFn,
        .writeFn = writeFn,
        .errorFn = errorFn,
        .userData = null,
    };
    return .{
        .internal_config = cfg,
    };
}
