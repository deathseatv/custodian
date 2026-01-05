/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Updated: 20260104230427 UTC
/// Notes:
/// - Implements slot-based save/load pointers and hub/portal scoped persistence to satisfy Bundle A slices.

/// @desc Facade for save/load/snapshot/restore.
function SaveSystem(_repo, _serializerRegistry, _versionManager, _integrityChecker, _fallbackPolicy, _logger) constructor {
    logger = is_undefined(_logger) ? new Logger() : _logger;

    repo = is_undefined(_repo) ? new PersistenceRepository(undefined, logger) : _repo;
    serializers = is_undefined(_serializerRegistry) ? new SerializerRegistry() : _serializerRegistry;
    versions = is_undefined(_versionManager) ? new VersionManager(1) : _versionManager;
    integrity = is_undefined(_integrityChecker) ? new IntegrityChecker(logger) : _integrityChecker;
    fallback = is_undefined(_fallbackPolicy) ? new FallbackPolicy() : _fallbackPolicy;
    snapshots = new SnapshotManager(logger);

    _applyMigrationsIfNeeded = function(schemaVersion, payloadStruct) {
        // payloadStruct is a wrapper {kind, schemaVersion, data}
        if (versions.needsMigration(schemaVersion)) {
            // Migrate expects a bundle-like struct; keep interface stable.
            var bundle = { schemaVersion: schemaVersion, world: payloadStruct.data };
            bundle = versions.migrate(bundle);
            payloadStruct.schemaVersion = bundle.schemaVersion;
            payloadStruct.data = bundle.world;
        }
        return payloadStruct;
    };

    /// -------------------- SLOT SAVE/LOAD --------------------
    /// @desc Save current worldState to a slot (writes: hub.json, portal_*.json, snapshot pointer for atomic resume).
    saveGame = function(slotId, worldState) {
        try {
            worldState.schemaVersion = versions.currentSchemaVersion();

            var report = integrity.validate(worldState);
            if (!report.ok) logger.warn("WorldState validation failed; proceeding per policy.");

            // 1) Write hub + global + active context
            repo.writeHub(worldState.schemaVersion, worldState.hub, worldState.activeContext, worldState.globalState);

            // 2) Write each portal instance separately
            var portalIds = worldState.portals.keys();
            for (var i = 0; i < array_length(portalIds); i++) {
                var pid = portalIds[i];
                var inst = worldState.portals.get(pid);
                if (!is_undefined(inst)) repo.writePortalInstance(worldState.schemaVersion, inst);
            }

            // 3) Create a world snapshot pointer for exact resume semantics
            var snap = snapshots.createSnapshot(worldState);
            if (!repo.writeSnapshot(snap)) return false;
            repo.writeSlotPointer(slotId, snap);

            logger.info("Saved slot " + string(slotId) + " -> snapshot " + snap.id);
            return true;
        } catch (e) {
            logger.error("saveGame exception: " + string(e));
            return false;
        }
    };

    /// @desc Load worldState from a slot pointer (exact resume semantics). Falls back to hub/portal files if needed.
    loadGame = function(slotId) {
        var slotPtr = repo.readSlotPointer(slotId);
        if (!is_undefined(slotPtr) && !is_undefined(slotPtr.snapshotId)) {
            var w = loadSnapshot(slotPtr.snapshotId);
            if (!is_undefined(w)) return w;
        }

        // Fallback: reconstruct from hub + portal files (best-effort)
        var hubObj = repo.readHub();
        if (is_undefined(hubObj)) return undefined;

        var schemaVersion = hubObj.schemaVersion;
        var payloadHub = { kind: "hub", schemaVersion: schemaVersion, data: hubObj };
        payloadHub = _applyMigrationsIfNeeded(schemaVersion, payloadHub);

        var world = new WorldState();
        world.schemaVersion = payloadHub.schemaVersion;
        world.hub = HubState_FromStruct(payloadHub.data.hub);
        world.activeContext = ActiveContext_FromStruct(payloadHub.data.activeContext);
        world.globalState = payloadHub.data.globalState;

        // portals
        var portalIds = repo.listPortals();
        for (var i = 0; i < array_length(portalIds); i++) {
            var pObj = repo.readPortalInstance(portalIds[i]);
            if (is_undefined(pObj)) continue;

            var payloadPortal = { kind: "portal", schemaVersion: pObj.schemaVersion, data: pObj };
            payloadPortal = _applyMigrationsIfNeeded(pObj.schemaVersion, payloadPortal);

            if (!is_undefined(payloadPortal.data.portal)) {
                var inst = PortalInstanceState_FromStruct(payloadPortal.data.portal);
                world.portals.set(inst.portalId, inst);
            }
        }

        var report = integrity.validate(world);
        if (!report.ok) integrity.repair(world);

        return world;
    };

    /// -------------------- SNAPSHOT SAVE/LOAD --------------------
    /// @desc Load a snapshot by id (expects wrapper payload from SnapshotManager).
    loadSnapshot = function(snapshotId) {
        var snap = repo.readSnapshot(snapshotId);
        if (is_undefined(snap)) {
            logger.error("Snapshot not found: " + string(snapshotId));
            return undefined;
        }

        var snapReport = integrity.validateSnapshot(snap);
        if (!snapReport.ok) {
            logger.error("Snapshot invalid: " + string(snapshotId));
            if (fallback.onCorruptSnapshot == CorruptAction.Reject) return undefined;
            if (fallback.onCorruptSnapshot == CorruptAction.AttemptRepair) logger.warn("AttemptRepair: continuing with payload.");
            if (fallback.onCorruptSnapshot == CorruptAction.LoadLastGood) return undefined;
            if (fallback.onCorruptSnapshot == CorruptAction.CreateNew) return new WorldState();
        }

        var payload = json_parse(snap.payload); // {kind, schemaVersion, data}
        payload = _applyMigrationsIfNeeded(payload.schemaVersion, payload);

        if (payload.kind == "world") {
            var world = WorldState_FromStruct(payload.data, payload.schemaVersion);
            var report = integrity.validate(world);
            if (!report.ok) {
                logger.warn("Loaded world failed validation; applying repair.");
                integrity.repair(world);
            }
            return world;
        }

        // If a hub/portal snapshot is loaded directly, reconstruct minimal world.
        var w2 = new WorldState();
        w2.schemaVersion = payload.schemaVersion;

        if (payload.kind == "hub") {
            w2.hub = HubState_FromStruct(payload.data.hub);
            w2.activeContext = ActiveContext_FromStruct(payload.data.activeContext);
            w2.globalState = payload.data.globalState;
        } else if (payload.kind == "portal") {
            if (!is_undefined(payload.data.portal)) {
                var inst = PortalInstanceState_FromStruct(payload.data.portal);
                w2.portals.set(inst.portalId, inst);
            }
        }

        return w2;
    };

    createSnapshot = function(worldState) {
        worldState.schemaVersion = versions.currentSchemaVersion();
        return snapshots.createSnapshot(worldState);
    };

    restoreSnapshot = function(snapshotId) {
        return loadSnapshot(snapshotId);
    };
}
