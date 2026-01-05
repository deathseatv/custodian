/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc A single instanced portal run state.
function PortalInstanceState(_portalId) constructor {
    portalId = string(_portalId);
    state = PortalState.Empty;
    arenaId = "";
    entities = [];      // entity IDs
    droppedItems = [];  // entity IDs
    stasis = false;

    toStruct = function() {
        return {
            portalId: portalId,
            state: state,
            arenaId: arenaId,
            entities: entities,
            droppedItems: droppedItems,
            stasis: stasis
        };
    };
}

function PortalInstanceState_FromStruct(s) {
    var p = new PortalInstanceState(s.portalId);
    p.state = s.state;
    p.arenaId = s.arenaId;
    p.entities = is_array(s.entities) ? s.entities : [];
    p.droppedItems = is_array(s.droppedItems) ? s.droppedItems : [];
    p.stasis = s.stasis;
    return p;
}
