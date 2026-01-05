/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Tracks where the player currently is.
function ActiveContext() constructor {
    inHub = true;
    activePortalId = undefined;
    inhabitedCharacterId = undefined;

    toStruct = function() {
        return {
            inHub: inHub,
            activePortalId: activePortalId,
            inhabitedCharacterId: inhabitedCharacterId
        };
    };
}

function ActiveContext_FromStruct(s) {
    var c = new ActiveContext();
    c.inHub = s.inHub;
    c.activePortalId = s.activePortalId;
    c.inhabitedCharacterId = s.inhabitedCharacterId;
    return c;
}
