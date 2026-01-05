/// @function guid_generate()
/// @desc Fallback GUID generator for runtimes without a built-in guid/uuid function.
///       Returns a string like: "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
function guid_generate() {
    // Ensure RNG is initialized (harmless if already called elsewhere)
    if (!variable_global_exists("__rng_inited")) {
        randomize();
        global.__rng_inited = true;
    }

    var hex = "0123456789abcdef";

    function _hex_nibble() {
        return string_char_at(hex, irandom_range(1, 16));
    }

    function _hex_n(n) {
        var s = "";
        for (var i = 0; i < n; i++) s += _hex_nibble();
        return s;
    }

    // RFC4122-ish v4 formatting: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
    var part1 = _hex_n(8);
    var part2 = _hex_n(4);
    var part3 = "4" + _hex_n(3);

    // y is 8..b
    var ychoices = "89ab";
    var _y = string_char_at(ychoices, irandom_range(1, 4));
    var part4 = _y + _hex_n(3);

    var part5 = _hex_n(12);

    return part1 + "-" + part2 + "-" + part3 + "-" + part4 + "-" + part5;
}
