const std = @import("std");
const c = @import("c.zig");

const WrenConfig = @import("config.zig");
const WrenVM = @import("vm.zig");

const VERSION_MAJOR: i32 = c.WREN_VERSION_MAJOR;
const VERSION_MINOR: i32 = c.WREN_VERSION_MINOR;
const VERSION_PATCH: i32 = c.WREN_VERSION_PATCH;

const VERSION_NUMBER = VERSION_MAJOR * 1000000 + VERSION_MINOR * 1000 + VERSION_PATCH;

const WrenError = error{ ConfigInitFailed, VMInitFailed };

pub fn getVersionNumber() i32 {
    return VERSION_NUMBER;
}
