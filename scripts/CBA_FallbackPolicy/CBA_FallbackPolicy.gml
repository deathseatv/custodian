/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Data-driven recovery actions for load failures.
function FallbackPolicy(_corrupt, _missingRef, _unknownType) constructor {
    onCorruptSnapshot = is_undefined(_corrupt) ? CorruptAction.LoadLastGood : _corrupt;
    onMissingRef = is_undefined(_missingRef) ? MissingRefAction.SpawnPlaceholder : _missingRef;
    onUnknownType = is_undefined(_unknownType) ? UnknownTypeAction.StubObject : _unknownType;

    toStruct = function() {
        return {
            onCorruptSnapshot: onCorruptSnapshot,
            onMissingRef: onMissingRef,
            onUnknownType: onUnknownType
        };
    };
}
