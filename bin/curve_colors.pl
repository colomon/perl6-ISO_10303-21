use v6;
use ISO_10303_21::Grammar;
use ISO_10303_21::Actions;

sub follow-chain(%entities, %reverse, $id) {
    # say :$id.perl;
    my $desc = "$id ({ %entities{$id}.map(*.keyword) })";
    if %entities{$id}.?keyword ~~ /SHAPE_REPRESENTATION$/ {
        # say "    finished $desc";
        return $desc;
    }
    my $owner;
    for %reverse{$id}.list -> $possible-owner {
        # say "        considering $possible-owner { %entities{$possible-owner}.map(*.keyword) }";
        next if %entities{$possible-owner}.?keyword eq "STYLED_ITEM" | "PRESENTATION_LAYER_ASSIGNMENT";
        $owner = $possible-owner;
    }
    return $desc unless $owner;
    $desc, follow-chain(%entities, %reverse, $owner);
}

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
                        my @chain = follow-chain($step-data.entities, %reverse, $curve);
                        next if @chain ~~ /MANIFOLD_SOLID_BREP/;
                        say @chain.join("\n    ");
                        say "    has color $color";
                    }
                }
            }
        }
    }
}
