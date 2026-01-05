/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc One forward migration step: fromVersion -> toVersion
function MigrationStep(_from, _to, _applyFn) constructor {
    fromVersion = _from;
    toVersion = _to;
    apply = is_callable(_applyFn) ? _applyFn : function(bundleStruct) { return bundleStruct; };
}
