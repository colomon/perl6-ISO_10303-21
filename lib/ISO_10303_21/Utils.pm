use v6;

package ISO_10303_21::Utils {
    sub EncodeString(Str $string) is export {
        my @codes := $string.ords.map({
            when * < 32    { '\\X\\' ~ sprintf("%02X", $_) }
            when * < 128   { .chr }
            when * < 256   { '\\X\\' ~ sprintf("%02X", $_) }
            when * < 65535 { "X2" => sprintf("%04X", $_) }
            default        { "X4" => sprintf("%08X", $_) }
        });

        my $result = "'";
        my $state = "";
        sub close-state { $result ~= "\\X0\\" if $state; }

        for @codes {
            when Str {
                close-state;
                $state = "";
                $result ~= $_;
            }
            when Pair {
                if .key ne $state {
                    close-state;
                    $state = .key;
                    $result ~= "\\$state\\";
                }
                $result ~= .value;
            }
        }
        close-state;
        
        $result ~ "'";
    }
}

