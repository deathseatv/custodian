 /// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Runtime lookup table for entities by id.
function EntityRegistry() constructor {
    _map = ds_map_create();

    get = function(entityId) {
        var k = string(entityId);
        if (ds_map_exists(_map, k)) return _map[? k];
        return undefined;
    };

    add = function(entity) {
        var k = string(entity.id);
        _map[? k] = entity;
        return k;
    };

    remove = function(entityId) {
        var k = string(entityId);
        if (ds_map_exists(_map, k)) ds_map_delete(_map, k);
    };

    getAll = function() {
        var keys = ds_map_keys(_map);
        var out = [];
        for (var i = 0; i < array_length(keys); i++) {
            out[i] = _map[? keys[i]];
        }
        return out;
    };

    destroy = function() {
        if (ds_exists(_map, ds_type_map)) ds_map_destroy(_map);
        _map = -1;
    };
}
