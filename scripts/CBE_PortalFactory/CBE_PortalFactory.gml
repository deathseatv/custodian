/// CBE_PortalFactory.gml
/// Bundle E - Portal Factory

/// @desc Creates new portal instances with unique ids.
function PortalFactory() constructor {

    /// @param arenaId Optional arena identifier (string)
    create = function(arenaId) {
        // Generate an id without relying on a global uuid_generate() lookup.
// (Inside constructor structs, unqualified identifiers may resolve to self fields.)
var _seed = string(date_current_datetime())
    + "|" + string(get_timer())
    + "|" + string(irandom_range(0, 2147483647));
var _id = md5_string_utf8(_seed);
        var p = new PortalInstanceState(_id);
        p.state = PortalState.Open;
        p.stasis = false;
        p.arenaId = is_undefined(arenaId) ? "" : string(arenaId);
        return p;
    };
}
