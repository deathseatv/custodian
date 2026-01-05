/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Complete in-memory world state to be serialized.
function WorldState() constructor {
    schemaVersion = 1; // set by VersionManager/SaveSystem
    hub = new HubState();
    portals = new PortalRegistryState();
    globalState = {}; // currencies, flags, unlocks, etc.
    activeContext = new ActiveContext();

    toStruct = function() {
        return {
            hub: hub.toStruct(),
            portals: portals.toStruct(),
            globalState: globalState,
            activeContext: activeContext.toStruct()
        };
    };

    destroy = function() {
        if (!is_undefined(portals)) portals.destroy();
    };
}

function WorldState_FromStruct(s, _schemaVersion) {
    var w = new WorldState();
    w.schemaVersion = is_undefined(_schemaVersion) ? 1 : _schemaVersion;
    w.hub = HubState_FromStruct(s.hub);
    w.portals = PortalRegistryState_FromStruct(s.portals);
    w.globalState = s.globalState;
    w.activeContext = ActiveContext_FromStruct(s.activeContext);
    return w;
}
