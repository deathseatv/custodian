/// uuid_generate.gml
/// Project utility: generate a reasonably-unique id string.
///
/// NOTE:
/// - GameMaker's native function list in this project does not include a UUID
///   generator, but several core systems rely on `uuid_generate()`.
/// - This implementation uses available built-ins to produce a 32-char hex
///   string (MD5) based on time + randomness.

function uuid_generate() {
    // Mix high-resolution timer + datetime + random.
    // MD5 yields a compact, filesystem-friendly hex string.
    var seed = string(date_current_datetime())
        + "|" + string(get_timer())
        + "|" + string(irandom_range(0, 2147483647));
    return md5_string_utf8(seed);
}
