use v6;
use ISO_10303_21::Grammar;
use ISO_10303_21::Actions;

sub print-sorted-keys(%look-for) {
    $*ERR.say: "Looking for " ~ %look-for.keys.sort(-> $a, $b { substr($a, 1) <=> substr($b, 1) }).join(" ");
}

sub entity-references($object) {
    if $object ~~ ISO_10303_21::Record {
        $object.entity_instances;
    } else {
        @($object).map(*.entity_instances).flat;
    }
}

sub MAIN ($file) {
    $*ERR.say: "Reading $file";
    my $file-data = slurp($file);
    $file-data .= subst(/"/*" .*? "*/"/, " ", :global);
    my $step-data = ISO_10303_21::Actions.new;
    die "Something went wrong with the import"
        unless ISO_10303_21::LooseGrammar.parse($file-data, :rule<exchange_file>, :actions($step-data));

    say "graph finite_state_machine \{";
    # say "    rankdir=LR";
    say "    overlap=false";

    
    my %look-for;
    for $step-data.entities.kv -> $index, $object {
        given $object {
            when Array {
                my $rr = $object.list.first({ $_.keyword eq "REPRESENTATION_RELATIONSHIP" });
                if $rr {
                    say qq[    "{ $rr.parameters[2] }" -- "{ $rr.parameters[3] }";];
                }
            }
        }
    }
    
    say "\}";
    
}