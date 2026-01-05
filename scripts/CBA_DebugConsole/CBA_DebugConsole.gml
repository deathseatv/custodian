/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Updated: 20260104225901 UTC
/// Notes:
/// - resetSave now performs an actual delete-all via PersistenceRepository when available.

/// @desc Developer command surface. Wire these to your in-game console.
function DebugConsole(_saveSystem, _debugTools, _testDataFactory, _logger) constructor {
    logger = is_undefined(_logger) ? new Logger() : _logger;
    saveSystem = _saveSystem;
    tools = _debugTools;
    testData = _testDataFactory;

    resetSave = function() {
        if (!is_undefined(saveSystem) && !is_undefined(saveSystem.repo) && is_callable(saveSystem.repo.deleteAllSaves)) {
            saveSystem.repo.deleteAllSaves();
            logger.warn("All saves deleted.");
            return true;
        }
        logger.warn("resetSave failed: repository does not support deleteAllSaves.");
        return false;
    };

    dumpWorldState = function(worldState) {
        var txt = json_stringify(worldState.toStruct());
        show_debug_message(txt);
        return txt;
    };

    forceReload = function(snapshotId) {
        return saveSystem.loadSnapshot(snapshotId);
    };

    spawnTestData = function(profile) {
        if (profile == "hub") return testData.makeHubBaseline();
        if (profile == "portal") return testData.makePortalInstance("test_portal", PortalState.Open);
        return testData.makeEntities("default");
    };
}
