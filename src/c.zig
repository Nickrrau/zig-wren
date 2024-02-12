const c = @cImport({
    @cInclude("wren.h");
});

pub const WrenVer = c.WREN_VERSION_NUMBER;
pub const WrenGetVer = c.wrenGetVersionNumber;

pub const WrenVM = c.WrenVM;
pub const wrenNewVM = c.wrenNewVM;
pub const wrenFreeVM = c.wrenFreeVM;

pub const WrenInterpret = c.wrenInterpret;
pub const WrenInterpretResult = c.WrenInterpretResult;

pub const WrenConfiguration = c.WrenConfiguration;

pub const WrenLoadModuleResult = c.WrenLoadModuleResult;
pub const WrenForeignMethodFn = c.WrenForeignMethodFn;
pub const WrenForeignClassMethods = c.WrenForeignClassMethods;
pub const WrenErrorType = c.WrenErrorType;
