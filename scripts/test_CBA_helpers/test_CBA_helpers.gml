/// GameMaker Testing Library (GMTL) test suites for Bundle A
/// Generated: 20260104231007 UTC
/// Requires: GameMaker Testing Library (GMTL). See tutorial for suite/section/test/expect usage. 
///
/// Conventions:
/// - Each file declares a top-level suite(function(){ ... })
/// - Tests are designed to be deterministic and to clean up files they write.

/// Helper factories for tests (pure scripts)
function test_make_world(_portalCount) {
    var w = new WorldState();
    w.schemaVersion = 1;

    // Ensure "globalState" exists (Bundle A patched naming convention)
    if (!variable_struct_exists(w, "globalState")) w.globalState = {};
    w.globalState.seed = 123;

    // Hub baseline
    w.hub.sharedStorageId = "stash_test";
    w.hub.portalSlots = ["slot_a","slot_b","slot_c"];
    w.hub.entities = ["e_player"];

    // Active context
    w.activeContext.inHub = true;
    w.activeContext.activePortalId = undefined;
    w.activeContext.inhabitedCharacterId = "e_player";

    // Portals
    var n = is_undefined(_portalCount) ? 1 : _portalCount;
    for (var i = 0; i < n; i++) {
        var pid = "p_" + string(i);
        var inst = new PortalInstanceState(pid);
        inst.state = PortalState.Open;
        inst.arenaId = "arena_" + string(i);
        inst.entities = ["e_" + pid + "_a", "e_" + pid + "_b"];
        inst.droppedItems = ["drop_" + pid + "_0"];
        inst.stasis = false;
        w.portals.set(pid, inst);
    }

    return w;
}

function test_repo(_root) {
    var logger = new Logger();
    var repo = new PersistenceRepository(_root, logger);
    // Try to cleanup if supported
    if (is_callable(repo.deleteAllSaves)) repo.deleteAllSaves();
    return repo;
}
