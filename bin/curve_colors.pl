use v6;
use ISO_10303_21::Grammar;
use ISO_10303_21::Actions;

sub MAIN(*@filenames) {
    for @filenames -> $file {
        $*ERR.say: "Reading $file";
        my $file-data = slurp($file);
        $file-data .= subst(/"/*" .*? "*/"/, " ", :global);
        my $step-data = ISO_10303_21::Actions.new;
        my $match = ISO_10303_21::LooseGrammar.parse($file-data, :rule<exchange_file>, :actions($step-data));
        unless $match ~~ Match && $match {
            $*ERR.say: "Something went wrong with the import.";
            next;
        }
        
        my %reverse = $step-data.entities.keys.categorize({ $step-data.entities{$_}.map(*.entity_instances) });
        # for %reverse.pairs.sort(*.key) -> $p {
        #     say $p.key ~ ": " ~ $p.value;
        # }
        
        for $step-data.entities.kv -> $id, $object {
            if $object ~~ ISO_10303_21::Record && $object.keyword eq "CURVE_STYLE" {
                my $color = $object.parameters[*-1];
                for %reverse{$id} -> $psa {
                    for %reverse{$psa} -> $si {
                        my $curve = $step-data.entities{$si}.parameters[*-1];
                        my $curve-type = $step-data.entities{$curve}.map(*.keyword);
                        my $owned-by = "";
                        for %reverse{$curve}.list -> $curve-owner {
                            next if $curve-owner eq $si;
                            say :$curve-owner.perl;
                            say $step-data.entities{$curve-owner};
                            $owned-by ~= $step-data.entities{$curve-owner}.map(*.keyword);
                        }
                        say "$curve ($curve-type owned by $owned-by) has color $color";
                    }
                }
            }
        }
    }
}
