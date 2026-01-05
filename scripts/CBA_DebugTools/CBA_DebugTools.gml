/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Debug utilities for snapshot operations.
function DebugTools(_repo, _snapshotManager, _logger) constructor {
    logger = is_undefined(_logger) ? new Logger() : _logger;
    repo = _repo;
    snapshots = _snapshotManager;

    exportSnapshot = function(snapshotId, outPath) {
        var snap = repo.readSnapshot(snapshotId);
        if (is_undefined(snap)) return false;

        var path = is_undefined(outPath) ? ("export_" + snapshotId + ".json") : string(outPath);
        var f = file_text_open_write(path);
        if (f < 0) return false;
        file_text_write_string(f, json_stringify(snap.toStruct()));
        file_text_close(f);
        return true;
    };

    importSnapshot = function(path) {
        if (!file_exists(path)) return undefined;
        var f = file_text_open_read(path);
        var txt = "";
        while (!file_text_eof(f)) {
            txt += file_text_read_string(f);
            file_text_readln(f);
        }
        file_text_close(f);
        var s = json_parse(txt);
        var snap = Snapshot_FromStruct(s);
        repo.writeSnapshot(snap);
        return snap.id;
    };

    diffSnapshots = function(aId, bId) {
        var a = repo.readSnapshot(aId);
        var b = repo.readSnapshot(bId);
        if (is_undefined(a) || is_undefined(b)) return "Missing snapshot(s).";
        if (a.payload == b.payload) return "No diff (payload identical).";
        return "Payload differs (string compare). Consider structured diff tooling.";
    };

    toggleIntegrityChecks = function(on) {
        logger.info("toggleIntegrityChecks: " + string(on));
    };
}


/// @desc Convenience: delete all saves if repo supports it.
deleteAllSaves = function() {
    if (!is_undefined(repo) && is_callable(repo.deleteAllSaves)) return repo.deleteAllSaves();
    return false;
};
