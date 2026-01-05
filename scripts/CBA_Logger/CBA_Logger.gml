/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Minimal logger with pluggable sink.
function Logger(_sink) constructor {
    sink = is_undefined(_sink) ? undefined : _sink;

    info = function(msg) {
        if (!is_undefined(sink)) sink("INFO", msg); else show_debug_message("[INFO] " + string(msg));
    };

    warn = function(msg) {
        if (!is_undefined(sink)) sink("WARN", msg); else show_debug_message("[WARN] " + string(msg));
    };

    error = function(msg) {
        if (!is_undefined(sink)) sink("ERROR", msg); else show_debug_message("[ERROR] " + string(msg));
    };
}
