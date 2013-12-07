use v6;

package ISO_10303_21::Utils {
    sub EncodeString(Str $string) is export {
        "'" ~ $string.ords.map({
            when * < 32    { '\\X\\' ~ sprintf("%02X", $_) }
            when * < 128   { .chr }
            when * < 256   { '\\X\\' ~ sprintf("%02X", $_) }
            when * < 65535 { '\\X2\\' ~ sprintf("%04X", $_) ~ '\\X0\\' }
            default        { '\\X4\\' ~ sprintf("%08X", $_) ~ '\\X0\\' }
        }).join ~ "'";
    }
}

