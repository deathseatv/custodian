/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Handles schema versioning and migrations.
function VersionManager(_currentVersion) constructor {
    _current = is_undefined(_currentVersion) ? 1 : _currentVersion;
    _steps = []; // array of MigrationStep

    currentSchemaVersion = function() {
        return _current;
    };

    addStep = function(step) {
        array_push(_steps, step);
    };

    needsMigration = function(version) {
        return version < _current;
    };

    /// @desc Apply forward migrations to bundle JSON (string) or struct.
    migrate = function(bundleInput) {
        var bundle = bundleInput;
        if (is_string(bundleInput)) bundle = json_parse(bundleInput);

        var v = bundle.schemaVersion;
        while (v < _current) {
            var applied = false;
            for (var i = 0; i < array_length(_steps); i++) {
                var s = _steps[i];
                if (s.fromVersion == v) {
                    bundle = s.apply(bundle);
                    bundle.schemaVersion = s.toVersion;
                    v = s.toVersion;
                    applied = true;
                    break;
                }
            }
            if (!applied) {
                // No path found; stop and let caller decide.
                break;
            }
        }
        return bundle;
    };
}
