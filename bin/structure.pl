use v6;
use ISO_10303_21::Grammar;
use ISO_10303_21::Actions;

sub print-sorted-keys(%look-for) {
    say "Looking for " ~ %look-for.keys.sort(-> $a, $b { substr($a, 1) <=> substr($b, 1) }).join(" ");
    
}

for @*ARGS -> $file {
    say "Reading $file";
    my $file-data = slurp($file);
    $file-data .= subst(/"/*" .*? "*/"/, " ", :global);
    my $step-data = ISO_10303_21::Actions.new;
    my $match = ISO_10303_21::LooseGrammar.parse($file-data, :rule<exchange_file>, :actions($step-data));
    unless $match ~~ Match && $match {
        say "Something went wrong with the import.";
        next;
    }
    
    my %look-for;
    for $step-data.entities.kv -> $index, $object {
        if $object ~~ ISO_10303_21::Record {
            if $object.keyword ~~ /SHAPE_REPRESENTATION$/ {
                %look-for{$index} = 1;
            }
        } else {
            if any($object.list.map({ $_.keyword ~~ /SHAPE_REPRESENTATION$/ })) {
                %look-for{$index} = 1;
            }
        }
    }

    print-sorted-keys(%look-for);

    my $previous-count = 0;
    
    while $previous-count != +%look-for {
        $previous-count = +%look-for;
        for $step-data.entities.kv -> $index, $object {
            if $object ~~ ISO_10303_21::Record {
                for $object.entity_instances -> $reference {
                    if %look-for{$reference} {
                        %look-for{$index} = 1;
                    }
                }
            } else {
                for @($object) -> $object {
                    for $object.entity_instances -> $reference {
                        if %look-for{$reference} {
                            %look-for{$index} = 1;
                        }
                    }
                }
            }
        }
        print-sorted-keys(%look-for);
    }
   
}