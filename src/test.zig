const std = @import("std");
const c = @import("c.zig");
const WrenConfig = @import("config.zig");
const WrenVM = @import("vm.zig");

fn errFn(vm: ?*c.WrenVM, errType: c_uint, module: [*c]const u8, ln: c_int, msg: [*c]const u8) callconv(.C) void {
    _ = module;
    _ = errType;
    _ = vm;
    std.debug.print("VM Error: {s}\nLine: {any}\n", .{ msg, ln });
}

fn writeFn(vm: ?*c.WrenVM, msg: [*c]const u8) callconv(.C) void {
    _ = vm;
    std.debug.print("VM Error: {s}\n", .{msg});
}

test "Initialize VM with Default Configuration" {
    var cfg = WrenConfig.newConfig(
        10000,
        10000,
        50,
        null,
        null,
        null,
        null,
        null,
        writeFn,
        errFn,
    );
    var vm = try WrenVM.new(&cfg);
    defer vm.free();
}

test "Run basic scripts inside default VM" {
    var cfg = WrenConfig.newConfig(
        10000,
        10000,
        50,
        null,
        null,
        null,
        null,
        null,
        writeFn,
        errFn,
    );
    var vm = try WrenVM.new(&cfg);
    defer vm.free();

    _ = try vm.interpret("main", "System.print(\"Hello! I am running in a VM! :)\")");
}

test "Run multiple VMs in sync" {
    var vms: [10]WrenVM = undefined;
    for (&vms) |*v| {
        var cfg = WrenConfig.newConfig(
            10000,
            10000,
            50,
            null,
            null,
            null,
            null,
            null,
            writeFn,
            errFn,
        );
        v.* = try WrenVM.new(&cfg);
    }
    defer {
        for (&vms) |*v| {
            v.*.free();
        }
    }

    for (vms, 0..) |vm, i| {
        const script = "System.print(\"VM " ++ i ++ " Ran Me!\")";
        _ = try vm.interpret("main", script);
    }
}
