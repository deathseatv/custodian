/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Updated: 20260104225901 UTC
/// Notes:
/// - Creates snapshots with a small wrapper describing the snapshot kind.

/// @desc Creates and manages snapshots (in memory). Storage is handled by PersistenceRepository.
function SnapshotManager(_logger) constructor {
    logger = is_undefined(_logger) ? new Logger() : _logger;
    _snapshots = []; // list of snapshot ids (most recent last)

    _wrap = function(kind, schemaVersion, dataStruct) {
        return {
            kind: kind,                 // "world" | "hub" | "portal"
            schemaVersion: schemaVersion,
            data: dataStruct
        };
    };

    createHubSnapshot = function(worldState) {
        var payloadStruct = _wrap("hub", worldState.schemaVersion, {
            hub: worldState.hub.toStruct(),
            activeContext: worldState.activeContext.toStruct(),
            globalState: worldState.globalState
        });
        var payload = json_stringify(payloadStruct);
        var snap = Snapshot_CreateFromPayload(payload, worldState.schemaVersion);
        array_push(_snapshots, snap.id);
		
		
        return snap;
    };

    createPortalSnapshot = function(worldState, portalId) {
        var inst = worldState.portals.get(portalId);
        var portalStruct = is_undefined(inst) ? undefined : inst.toStruct();

        var payloadStruct = _wrap("portal", worldState.schemaVersion, {
            portalId: portalId,
            portal: portalStruct
        });
        var payload = json_stringify(payloadStruct);
        var snap = Snapshot_CreateFromPayload(payload, worldState.schemaVersion);
        array_push(_snapshots, snap.id);
        return snap;
    };

    createSnapshot = function(worldState) {
        var payloadStruct = _wrap("world", worldState.schemaVersion, worldState.toStruct());
        var payload = json_stringify(payloadStruct);
        var snap = Snapshot_CreateFromPayload(payload, worldState.schemaVersion);
        array_push(_snapshots, snap.id);
        return snap;
    };

    listSnapshots = function() {
        return _snapshots;
    };

    pruneSnapshots = function(policy) {
        var maxKeep = 10;
        if (!is_undefined(policy) && variable_struct_exists(policy, "maxKeep")) maxKeep = policy.maxKeep;
        while (array_length(_snapshots) > maxKeep) {
            array_delete(_snapshots, 0, 1);
        }
    };
}
