use v6;

package ISO_10303_21::Utils {
    sub EncodeString(Str $string) is export {
        "'" ~ $string.ords.map({
            when * < 32    { '\\X\\' ~ sprintf("%02x", $_) }
            when * < 128   { .chr }
            when * < 256   { '\\X\\' ~ sprintf("%02x", $_) }
            when * < 65535 { '\\X2\\' ~ sprintf("%04x", $_) ~ '\\X0\\' }
            default        { '\\X4\\' ~ sprintf("%08x", $_) ~ '\\X0\\' }
        }).join ~ "'";
    }
}

