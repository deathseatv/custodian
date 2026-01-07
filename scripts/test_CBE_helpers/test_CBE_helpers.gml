/// test_CBE_helpers.gml
/// GMTL helpers for Bundle E tests
/// Generated: 20260107143348 UTC

/// @desc Create an isolated PersistenceRepository rooted at _root and wipe it.
function test_cbe_repo(_root) {
    var logger = new Logger();
    var repo = new PersistenceRepository(_root, logger);
    if (is_callable(repo.deleteAllSaves)) repo.deleteAllSaves();
    return repo;
}

/// @desc Create a baseline WorldState with ensured hub portal slots.
/// @param slotCount number of portal slots to ensure
function test_cbe_world(_slotCount) {
    var w = new WorldState();
    w.schemaVersion = 1;

    if (is_undefined(w.globalState)) w.globalState = {};
    if (is_undefined(w.activeContext)) w.activeContext = new ActiveContext();
    if (!variable_struct_exists(w.activeContext, "inHub")) w.activeContext.inHub = true;
    if (!variable_struct_exists(w.activeContext, "activePortalId")) w.activeContext.activePortalId = "";

    if (is_undefined(w.hub)) w.hub = new HubState();
    if (!is_array(w.hub.portalSlots)) w.hub.portalSlots = [];

    var n = is_undefined(_slotCount) ? 1 : _slotCount;
    if (n < 1) n = 1;
    PortalSlots_EnsureCount(w.hub, n);

    return w;
}

/// @desc Assert that a portal instance exists in registry for id.
function test_cbe_has_portal(_w, _pid) {
    if (is_undefined(_w) || is_undefined(_w.portals)) return false;
    return _w.portals.has(string(_pid));
}

/// @desc Read hub file JSON struct directly for low-level assertions.
function test_cbe_read_hub_raw(_repo) {
    if (is_undefined(_repo)) return undefined;
    if (!is_callable(_repo.readHub)) return undefined;
    return _repo.readHub();
}
