/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc "Interface" convention for serializers.
/// In GML there is no true interface; this file defines a helper validator.
/// A serializer is expected to provide:
/// - typeId() -> string
/// - serialize(obj) -> string/bytes
/// - deserialize(bytes) -> object
function ISerializer_IsValid(serializer) {
    if (is_undefined(serializer)) return false;
    if (!is_callable(serializer.typeId)) return false;
    if (!is_callable(serializer.serialize)) return false;
    if (!is_callable(serializer.deserialize)) return false;
    return true;
}
