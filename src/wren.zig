const std = @import("std");
const Version = std.SemanticVersion;

const WREN_VERSION: Version = .{
    .major = 0,
    .minor = 4,
    .patch = 0,
};

const WrenError = error{ ConfigInitFailed, VMInitFailed };

pub fn getVersionNumber() i32 {
    return WREN_VERSION.major * 1000000 + WREN_VERSION.minor * 1000 + WREN_VERSION.patch;
}
