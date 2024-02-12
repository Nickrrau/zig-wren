const c = @import("c.zig");
const config = @import("config.zig");
const Self = @This();

const VMError = error{
    InitFailed,
};

const InterpretError = error{
    CompileError,
    RuntimeError,
};

internal_vm: *c.WrenVM,

pub fn new(cfg: *config) VMError!Self {
    const vm = c.wrenNewVM(@ptrCast(cfg)) orelse return VMError.InitFailed;
    return .{
        .internal_vm = vm,
    };
}

pub fn free(self: *Self) void {
    c.wrenFreeVM(self.internal_vm);
}

pub fn interpret(self: Self, module: [*c]const u8, script: [*c]const u8) InterpretError!void {
    const res = c.WrenInterpret(self.internal_vm, module, script);
    switch (res) {
        else => {
            return;
        },
        2 => {
            return InterpretError.CompileError;
        },
        3 => {
            return InterpretError.RuntimeError;
        },
    }
}
