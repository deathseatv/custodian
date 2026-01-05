/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Registry of serializers keyed by typeId.
function SerializerRegistry() constructor {
    _map = ds_map_create();

    register = function(_typeId, _serializer) {
        var k = string(_typeId);
        if (!ISerializer_IsValid(_serializer)) {
            show_debug_message("[SerializerRegistry] Invalid serializer for " + k);
            return false;
        }
        _map[? k] = _serializer;
        return true;
    };

    get = function(_typeId) {
        var k = string(_typeId);
        if (ds_map_exists(_map, k)) return _map[? k];
        return undefined;
    };

    /// @desc Serialize a WorldState into a bundle JSON string.
    serialize = function(worldState) {
        var bundle = {
            schemaVersion: worldState.schemaVersion,
            world: worldState.toStruct()
        };
        return json_stringify(bundle);
    };

    /// @desc Deserialize a bundle JSON string into WorldState.
    deserialize = function(bundleJson) {
        var bundle = json_parse(bundleJson);
        return WorldState_FromStruct(bundle.world, bundle.schemaVersion);
    };

    destroy = function() {
        if (ds_exists(_map, ds_type_map)) ds_map_destroy(_map);
        _map = -1;
    };
}
