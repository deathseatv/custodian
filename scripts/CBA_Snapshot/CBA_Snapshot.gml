/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Immutable snapshot artifact.
function Snapshot(_id, _timestampUtc, _schemaVersion, _checksum, _payload) constructor {
    id = _id;
    timestampUtc = _timestampUtc;
    schemaVersion = _schemaVersion;
    checksum = _checksum;
    payload = _payload; // string (usually JSON or base64)

    toStruct = function() {
        return {
            id: id,
            timestampUtc: timestampUtc,
            schemaVersion: schemaVersion,
            checksum: checksum,
            payload: payload
        };
    };
}

/// @desc Factory to build a snapshot from a payload string.

/// @desc Generate a reasonably-unique id for snapshot artifacts without relying on external GUID helpers.
/// Note: Avoids nested function closures; uses md5 over time + timer + randomness.
function Snapshot_GenerateId() {
    var seed = string(date_current_datetime()) + "|" + string(get_timer()) + "|" + string(irandom(2147483647));
    return md5_string_unicode(seed);
}

function Snapshot_CreateFromPayload(_payload, _schemaVersion) {
    var _id = string(Snapshot_GenerateId());
    // Build an ISO-8601-ish UTC timestamp. (YYC runtimes may not expose datetime_create_from_system.)
var _tz_prev = date_get_timezone();
date_set_timezone(timezone_utc);
var _ts = date_format(date_current_datetime(), "%Y-%m-%dT%H:%M:%SZ");
date_set_timezone(_tz_prev);
    var _ck = md5_string_unicode(string(_schemaVersion) + "|" + string(_payload));
    return new Snapshot(_id, _ts, _schemaVersion, _ck, _payload);
}

/// @desc Rehydrate a snapshot from a struct (e.g., parsed JSON).
function Snapshot_FromStruct(s) {
    return new Snapshot(s.id, s.timestampUtc, s.schemaVersion, s.checksum, s.payload);
}
