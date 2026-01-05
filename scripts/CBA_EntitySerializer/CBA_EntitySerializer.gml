/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Serializer for Entity objects. Conforms to the ISerializer convention.
function EntitySerializer() constructor {
    typeId = function() { return "Entity"; };

    serialize = function(obj) {
        var s = obj.toStruct();
        return json_stringify(s);
    };

    deserialize = function(bytes) {
        var s = json_parse(bytes);
        return Entity_FromStruct(s);
    };
}
