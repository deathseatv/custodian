/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Updated for Bundle D integration (entityRegistry persisted)

/// @desc Complete in-memory world state to be serialized.
function WorldState() constructor {
    schemaVersion = 1; // set by VersionManager/SaveSystem
    hub = new HubState();
    portals = new PortalRegistryState();
    globalState = {}; // currencies, flags, unlocks, etc.
    activeContext = new ActiveContext();

    // Bundle D integration: persist entities (characters, etc.)
    entityRegistry = new EntityRegistry();

    toStruct = function() {
        return {
            hub: hub.toStruct(),
            portals: portals.toStruct(),
            globalState: globalState,
            activeContext: activeContext.toStruct(),

            // Bundle D integration
            entities: EntityRegistry_ToStruct(entityRegistry)
        };
    };

    destroy = function() {
        if (!is_undefined(portals)) portals.destroy();
        if (!is_undefined(entityRegistry)) entityRegistry.destroy();
    };
}

function WorldState_FromStruct(s, _schemaVersion) {
    var w = new WorldState();
    w.schemaVersion = is_undefined(_schemaVersion) ? 1 : _schemaVersion;

    // Defensive: s may be missing fields depending on schemaVersion
    if (!is_undefined(s) && is_struct(s)) {
        if (variable_struct_exists(s, "hub")) w.hub = HubState_FromStruct(s.hub);
        if (variable_struct_exists(s, "portals")) w.portals = PortalRegistryState_FromStruct(s.portals);
        if (variable_struct_exists(s, "globalState")) w.globalState = s.globalState;
        if (variable_struct_exists(s, "activeContext")) w.activeContext = ActiveContext_FromStruct(s.activeContext);

        // Bundle D integration: entities are optional for older saves
        if (variable_struct_exists(s, "entities")) w.entityRegistry = EntityRegistry_FromStruct(s.entities);
        else w.entityRegistry = new EntityRegistry();
    } else {
        // Totally invalid payload -> default
        w.entityRegistry = new EntityRegistry();
    }

    return w;
}

