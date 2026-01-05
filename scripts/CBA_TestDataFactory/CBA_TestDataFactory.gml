/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Produces deterministic baseline world states for testing.
function TestDataFactory() constructor {
    makeHubBaseline = function() {
        var hub = new HubState();
        hub.sharedStorageId = "stash_001";
        hub.portalSlots = ["slot_a", "slot_b", "slot_c"];
        hub.entities = [];
        return hub;
    };

    makePortalInstance = function(portalId, state) {
        var p = new PortalInstanceState(portalId);
        p.state = is_undefined(state) ? PortalState.Open : state;
        p.arenaId = "arena_test_01";
        p.entities = [];
        p.droppedItems = [];
        p.stasis = false;
        return p;
    };

    makeEntities = function(setName) {
        var out = [];
        if (setName == "default") {
            var e1 = new Entity(undefined, "Player");
            e1.addComponent(new Component("Stats", { hp: 100, mp: 25 }));
            out[0] = e1;

            var e2 = new Entity(undefined, "Chest");
            e2.addComponent(new Component("Loot", { seed: 12345 }));
            out[1] = e2;
        } else {
            var e = new Entity(undefined, "Dummy");
            out[0] = e;
        }
        return out;
    };
}
