/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Validates and optionally repairs world state / snapshots.
function IntegrityChecker(_logger) constructor {
    logger = is_undefined(_logger) ? new Logger() : _logger;

    validate = function(worldState) {
        var r = new IntegrityReport();

        if (is_undefined(worldState) || is_undefined(worldState.hub) || is_undefined(worldState.portals)) {
            r.addError("WorldState missing required sub-states.");
            return r;
        }

        // Check entity ids are unique where present
        var seen = ds_map_create();
var push_id = function(_r, _seen, id) {
    var k = string(id);
    if (k == "" || is_undefined(k)) {
        _r.addInvalidId(k);
        return;
    }
    if (ds_map_exists(_seen, k)) {
        _r.addError("Duplicate entity id: " + k);
    } else {
        _seen[? k] = true;
    }
};


        if (is_array(worldState.hub.entities)) {
            for (var i = 0; i < array_length(worldState.hub.entities); i++) push_id(r, seen, worldState.hub.entities[i]);
        }

        var portalKeys = worldState.portals.keys();
        for (var k = 0; k < array_length(portalKeys); k++) {
            var inst = worldState.portals.get(portalKeys[k]);
            if (!is_undefined(inst) && is_array(inst.entities)) {
                for (var j = 0; j < array_length(inst.entities); j++) push_id(r, seen, inst.entities[j]);
            }
            if (!is_undefined(inst) && is_array(inst.droppedItems)) {
                for (var j2 = 0; j2 < array_length(inst.droppedItems); j2++) push_id(r, seen, inst.droppedItems[j2]);
            }
        }

        ds_map_destroy(seen);
        return r;
    };

    validateSnapshot = function(snapshot) {
        var r = new IntegrityReport();
        if (is_undefined(snapshot)) {
            r.addError("Snapshot is undefined.");
            return r;
        }

        var expected = md5_string_unicode(string(snapshot.schemaVersion) + "|" + string(snapshot.payload));
        if (expected != snapshot.checksum) {
            r.addError("Snapshot checksum mismatch.");
        }
        if (snapshot.schemaVersion <= 0) {
            r.addError("Snapshot schemaVersion invalid.");
        }
        return r;
    };

    repair = function(worldState) {
        if (is_undefined(worldState.hub.entities)) worldState.hub.entities = [];
        return { repaired: true, worldState: worldState };
    };
}
