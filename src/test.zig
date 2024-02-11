const std = @import("std");
const c = @import("c.zig");
const WrenConfig = @import("config.zig");
const WrenVM = @import("vm.zig");

fn errFn(vm: ?*c.WrenVM, errType: c_uint, module: [*c]const u8, ln: c_int, msg: [*c]const u8) callconv(.C) void {
    _ = msg;
    _ = ln;
    _ = module;
    _ = errType;
    _ = vm;
}

fn writeFn(vm: ?*c.WrenVM, msg: [*c]const u8) callconv(.C) void {
    _ = msg;
    _ = vm;
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

    comptime var index: u8 = 0;

    inline for (vms) |vm| {
        const script: [*c]const u8 = std.fmt.comptimePrint("System.print(\"VM {d} Ran Me!\")", .{index});
        _ = try vm.interpret("main", script);
        index += 1;
    }
}

test "Run scripts with fibers" {
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

    const script =
        \\var msg1 = ["hello","world"]
        \\var msg2 = ["How","are","you?"]
        \\var msgs = [msg1,msg2]
        \\
        \\var f = Fiber.new {|list|
        \\  var fibers = []
        \\  for (m in list) {
        \\      fibers.add(Fiber.new {
        \\          var words = m
        \\          for (w in words) {
        \\              System.print(w)
        \\          }
        \\      })
        \\  }
        \\  for (f in fibers) {
        \\      f.call()
        \\      Fiber.yield()
        \\  }
        \\}
        \\
        \\for (i in 0..1) {
        \\  f.call(msgs)
        \\}
    ;
    _ = try vm.interpret("main", script);
}
