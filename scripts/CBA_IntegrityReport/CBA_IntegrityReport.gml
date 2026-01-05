/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Validation report produced by IntegrityChecker.
function IntegrityReport() constructor {
    ok = true;
    errors = [];
    warnings = [];
    missingRefs = [];
    invalidIds = [];

    addError = function(msg) {
        ok = false;
        array_push(errors, string(msg));
    };

    addWarning = function(msg) {
        array_push(warnings, string(msg));
    };

    addMissingRef = function(ref) {
        ok = false;
        array_push(missingRefs, string(ref));
    };

    addInvalidId = function(id) {
        ok = false;
        array_push(invalidIds, string(id));
    };

    toStruct = function() {
        return {
            ok: ok,
            errors: errors,
            warnings: warnings,
            missingRefs: missingRefs,
            invalidIds: invalidIds
        };
    };
}
