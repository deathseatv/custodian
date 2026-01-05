/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Shared hub state.
function HubState() constructor {
    entities = [];          // array of Entity IDs (string)
    sharedStorageId = "";   // e.g., stash id
    portalSlots = [];       // portal slot ids

    toStruct = function() {
        return {
            entities: entities,
            sharedStorageId: sharedStorageId,
            portalSlots: portalSlots
        };
    };
}

function HubState_FromStruct(s) {
    var h = new HubState();
    h.entities = is_array(s.entities) ? s.entities : [];
    h.sharedStorageId = s.sharedStorageId;
    h.portalSlots = is_array(s.portalSlots) ? s.portalSlots : [];
    return h;
}
