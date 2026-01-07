/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Registry of portal instances (portalId -> PortalInstanceState).
function PortalRegistryState() constructor {
    _map = ds_map_create();

    get = function(portalId) {
        var k = string(portalId);
        if (ds_map_exists(_map, k)) return _map[? k];
        return undefined;
    };

    set = function(portalId, portalInstanceState) {
        var k = string(portalId);
        _map[? k] = portalInstanceState;
    };

    /// @desc True if a portalId exists in the registry.
    has = function(portalId) {
        var k = string(portalId);
        return ds_map_exists(_map, k);
    };

    /// @desc Remove a portalId from the registry if present.
    remove = function(portalId) {
        var k = string(portalId);
        if (ds_map_exists(_map, k)) ds_map_delete(_map, k);
    };

    keys = function() {
        return ds_map_keys_to_array(_map);
    };

    toStruct = function() {
        var keys = ds_map_keys_to_array(_map);
        var out = [];
        for (var i = 0; i < array_length(keys); i++) {
            out[i] = _map[? keys[i]].toStruct();
        }
        return {
            instances: out
        };
    };

    destroy = function() {
        if (ds_exists(_map, ds_type_map)) ds_map_destroy(_map);
        _map = -1;
    };
}

function PortalRegistryState_FromStruct(s) {
    var r = new PortalRegistryState();
    if (is_array(s.instances)) {
        for (var i = 0; i < array_length(s.instances); i++) {
            var inst = PortalInstanceState_FromStruct(s.instances[i]);
            r.set(inst.portalId, inst);
        }
    }
    return r;
}
