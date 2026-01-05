/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Base component. Extend by adding fields to `data`.
function Component(_componentTypeId, _data) constructor {
    componentTypeId = string(_componentTypeId);
    data = is_undefined(_data) ? {} : _data;

    toStruct = function() {
        return {
            componentTypeId: componentTypeId,
            data: data
        };
    };
}

function Component_FromStruct(s) {
    return new Component(s.componentTypeId, s.data);
}
