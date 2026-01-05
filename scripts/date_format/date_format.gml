/// @func date_format(dt, fmt)
/// @desc Minimal strftime-like formatter for GML datetimes.
/// Supports tokens: %Y %m %d %H %M %S %%
/// Also supports %Z (prints "UTC" if current timezone is timezone_utc, else "LOCAL")
/// Note: Your usage "%Y-%m-%dT%H:%M:%SZ" works (the trailing 'Z' is just a literal char).
function date_format(_dt, _fmt)
{
    var out = "";
    var n = string_length(_fmt);

    for (var i = 1; i <= n; i++)
    {
        var ch = string_char_at(_fmt, i);

        if (ch != "%")
        {
            out += ch;
            continue;
        }

        // Trailing '%' => treat as literal '%'
        if (i >= n)
        {
            out += "%";
            continue;
        }

        i += 1;
        var tok = string_char_at(_fmt, i);

        switch (tok)
        {
            case "%":
                out += "%";
            break;

            case "Y":
                out += string(date_get_year(_dt));
            break;

            case "m":
                out += string_format(date_get_month(_dt), 2, 0); // 01-12
            break;

            case "d":
                out += string_format(date_get_day(_dt), 2, 0);   // 01-31
            break;

            case "H":
                out += string_format(date_get_hour(_dt), 2, 0);  // 00-23
            break;

            case "M":
                out += string_format(date_get_minute(_dt), 2, 0); // 00-59
            break;

            case "S":
                out += string_format(date_get_second(_dt), 2, 0); // 00-59
            break;

            case "Z":
            {
                var tz = date_get_timezone();
                out += (tz == timezone_utc) ? "UTC" : "LOCAL";
            }
            break;

            default:
                // Unknown token: keep it verbatim (e.g. "%q" => "%q")
                out += "%" + tok;
            break;
        }
    }

    return out;
}
