/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc ECS-style Entity holding components.
function Entity(_id, _typeId) constructor {
    id = is_undefined(_id) ? string(uuid_generate()) : string(_id);
    typeId = string(_typeId);
    components = [];

    addComponent = function(c) {
        array_push(components, c);
        return c;
    };

    getComponent = function(componentTypeId) {
        for (var i = 0; i < array_length(components); i++) {
            if (components[i].componentTypeId == componentTypeId) return components[i];
        }
        return undefined;
    };

    toStruct = function() {
        var arr = [];
        for (var i = 0; i < array_length(components); i++) {
            arr[i] = components[i].toStruct();
        }
        return {
            id: id,
            typeId: typeId,
            components: arr
        };
    };
}

function Entity_FromStruct(s) {
    var e = new Entity(s.id, s.typeId);
    if (is_array(s.components)) {
        for (var i = 0; i < array_length(s.components); i++) {
            e.addComponent(Component_FromStruct(s.components[i]));
        }
    }
    return e;
}
