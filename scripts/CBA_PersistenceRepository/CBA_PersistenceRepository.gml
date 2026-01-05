/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Updated: 20260104225901 UTC
/// Notes:
/// - Implements slot index + hub/portal scoped persistence to support Bundle A slices.
/// - Uses local save directory files; indexing is JSON-based.

/// @desc Storage abstraction. Default implementation stores JSON in local save directory.
function PersistenceRepository(_rootDir, _logger) constructor {
    logger = is_undefined(_logger) ? new Logger() : _logger;
    rootDir = is_undefined(_rootDir) ? "saves" : string(_rootDir);

    _ensureDir = function() {
        if (!directory_exists(rootDir)) directory_create(rootDir);
    };

    _slotPath = function(slotId) {
        // file contents: { "snapshotId": "...", "updatedUtc": "...", "schemaVersion": n }
        return rootDir + "/slot_" + string(slotId) + ".json";
    };

    _snapshotPath = function(snapshotId) {
        return rootDir + "/snapshot_" + string(snapshotId) + ".json";
    };

    _hubPath = function() {
        // file contents: { schemaVersion: n, hub: <HubState>, activeContext: <ActiveContext>, globalState: <struct> }
        return rootDir + "/hub.json";
    };

    _portalPath = function(portalId) {
        // file contents: { schemaVersion: n, portal: <PortalInstanceState> }
        return rootDir + "/portal_" + string(portalId) + ".json";
    };

    _writeJsonFile = function(path, obj) {
        _ensureDir();
        var f = file_text_open_write(path);
        if (f < 0) {
            logger.error("Failed to open for write: " + path);
            return false;
        }
        file_text_write_string(f, json_stringify(obj));
        file_text_close(f);
        return true;
    };

    _readJsonFile = function(path) {
        _ensureDir();
        if (!file_exists(path)) return undefined;
        var f = file_text_open_read(path);
        var txt = "";
        while (!file_text_eof(f)) {
            txt += file_text_read_string(f);
            file_text_readln(f);
        }
        file_text_close(f);
        return json_parse(txt);
    };

    /// -------------------- Snapshots --------------------
    writeSnapshot = function(snapshot) {
        return _writeJsonFile(_snapshotPath(snapshot.id), snapshot.toStruct());
    };

    readSnapshot = function(snapshotId) {
        var s = _readJsonFile(_snapshotPath(snapshotId));
        if (is_undefined(s)) return undefined;
        return Snapshot_FromStruct(s);
    };

    /// -------------------- Slot index --------------------
    writeSlotPointer = function(slotId, snapshot) {
        var obj = {
            snapshotId: snapshot.id,
            updatedUtc: snapshot.timestampUtc,
            schemaVersion: snapshot.schemaVersion
        };
        return _writeJsonFile(_slotPath(slotId), obj);
    };

    readSlotPointer = function(slotId) {
        return _readJsonFile(_slotPath(slotId));
    };

    listSaveSlots = function() {
    _ensureDir();
    var out = [];
    var pattern = rootDir + "/slot_*.json";
    var fn = file_find_first(pattern, fa_none);
    if (fn == "") return out;

    while (fn != "") {
        var slot = string_delete(fn, 1, 5); // remove "slot_"
        slot = string_replace_all(slot, ".json", "");
        array_push(out, slot);
        fn = file_find_next();
    }
    file_find_close();
    return out;
};

    deleteSlot = function(slotId) {
        _ensureDir();
        var path = _slotPath(slotId);
        if (file_exists(path)) return file_delete(path);
        return false;
    };

    /// -------------------- Hub / Portal scoped persistence --------------------
    writeHub = function(schemaVersion, hubState, activeContext, globalState) {
        var obj = {
            schemaVersion: schemaVersion,
            hub: hubState.toStruct(),
            activeContext: activeContext.toStruct(),
            globalState: globalState
        };
        return _writeJsonFile(_hubPath(), obj);
    };

    readHub = function() {
        return _readJsonFile(_hubPath());
    };

    writePortalInstance = function(schemaVersion, portalInstanceState) {
        var obj = {
            schemaVersion: schemaVersion,
            portal: portalInstanceState.toStruct()
        };
        return _writeJsonFile(_portalPath(portalInstanceState.portalId), obj);
    };

    readPortalInstance = function(portalId) {
        return _readJsonFile(_portalPath(portalId));
    };

    listPortals = function() {
    _ensureDir();
    var out = [];
    var pattern = rootDir + "/portal_*.json";
    var fn = file_find_first(pattern, fa_none);
    if (fn == "") return out;

    while (fn != "") {
        var portalId = string_delete(fn, 1, 7); // remove "portal_"
        portalId = string_replace_all(portalId, ".json", "");
        array_push(out, portalId);
        fn = file_find_next();
    }
    file_find_close();
    return out;
};

    deletePortal = function(portalId) {
        _ensureDir();
        var path = _portalPath(portalId);
        if (file_exists(path)) return file_delete(path);
        return false;
    };

    /// -------------------- Full reset helpers --------------------
    deleteAllSaves = function() {
	    _ensureDir();

	    var fn;

	    // slots
	    fn = file_find_first(rootDir + "/slot_*.json", fa_none);
	    while (fn != "") {
	        file_delete(rootDir + "/" + fn);
	        fn = file_find_next();
	    }
	    file_find_close(); // ALWAYS close, even if fn == ""

	    // snapshots
	    fn = file_find_first(rootDir + "/snapshot_*.json", fa_none);
	    while (fn != "") {
	        file_delete(rootDir + "/" + fn);
	        fn = file_find_next();
	    }
	    file_find_close();

	    // hub
	    if (file_exists(_hubPath())) file_delete(_hubPath());

	    // portals
	    fn = file_find_first(rootDir + "/portal_*.json", fa_none);
	    while (fn != "") {
	        file_delete(rootDir + "/" + fn);
	        fn = file_find_next();
	    }
	    file_find_close();

	    return true;
	};

}
