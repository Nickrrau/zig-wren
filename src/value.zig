const ObjType = enum {
    OBJ_CLASS,
    OBJ_CLOSURE,
    OBJ_FIBER,
    OBJ_FN,
    OBJ_FOREIGN,
    OBJ_INSTANCE,
    OBJ_LIST,
    OBJ_MAP,
    OBJ_MODULE,
    OBJ_RANGE,
    OBJ_STRING,
    OBJ_UPVALUE,
};

const Obj = struct {
    type: ObjType,
    isDark: bool,
    // class:
    next: *Obj,
};

const ValueType = enum {
    VAL_FALSE,
    VAL_NULL,
    VAL_NUM,
    VAL_TRUE,
    VAL_UNDEFINED,
    VAL_OBJ,
};

const Value = struct {
    type: ValueType,
    as: union {
        num: f64,
        obj: *Obj,
    },
};

const StringObj = struct {
    obj: Obj,
    len: u32,
    hash: u32,
};
