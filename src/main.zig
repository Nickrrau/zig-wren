const std = @import("std");
const c = @cImport({
    @cInclude("wren/wren.h");
});

pub const WrenVM = c.WrenVM;

const VERSION_MAJOR: i32 = c.WREN_VERSION_MAJOR;
const VERSION_MINOR: i32 = c.WREN_VERSION_MINOR;
const VERSION_PATCH: i32 = c.WREN_VERSION_PATCH;

const WrenError = error{ ConfigInitFailed, VMInitFailed };

pub fn getVersionNumber() i32 {
    return VERSION_MAJOR * 1000000 + VERSION_MINOR * 1000 + VERSION_PATCH;
}

pub fn initConfiguration() c.WrenConfiguration {
    var config: c.WrenConfiguration = undefined;
    c.wrenInitConfiguration(&config);
    return config;
}

pub fn newVM(cfg: *c.WrenConfiguration) WrenError!*WrenVM {
    return c.wrenNewVM(cfg) orelse WrenError.VMInitFailed;
}

pub fn freeVM(vm: *WrenVM) void {
    c.wrenFreeVM(vm);
}

pub fn interpret(vm: *WrenVM, module: [*c]const u8, script: [*c]const u8) c.WrenInterpretResult {
    return c.wrenInterpret(vm, module, script);
}
