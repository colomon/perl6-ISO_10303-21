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
        @($object).map(*.entity_instances);
    }
}

for @*ARGS -> $file {
    $*ERR.say: "Reading $file";
    my $file-data = slurp($file);
    $file-data .= subst(/"/*" .*? "*/"/, " ", :global);
    my $step-data = ISO_10303_21::Actions.new;
    my $match = ISO_10303_21::LooseGrammar.parse($file-data, :rule<exchange_file>, :actions($step-data));
    unless $match ~~ Match && $match {
        $*ERR.say: "Something went wrong with the import.";
        next;
    }
    
    my %look-for;
    for $step-data.entities.kv -> $index, $object {
        if $object ~~ ISO_10303_21::Record {
            if $object.keyword ~~ /SHAPE_REPRESENTATION$/ || $object.keyword ~~ /NEXT_ASSEMBLY_USAGE_OCCURRENCE/ {
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
            for entity-references($object) -> $reference {
                if %look-for{$reference} {
                    %look-for{$index} = 1;
                }
            }
        }
        print-sorted-keys(%look-for);
    }

    say "digraph finite_state_machine \{";
    say "    rankdir=LR";
    
    my %tags;
    my %types;
    for %look-for.keys -> $index {
        my $object = $step-data.entities{$index};
        %tags{$index} = 1;
        %types{$object.keyword} = 1 if $object ~~ ISO_10303_21::Record;
        for entity-references($object) -> $entity {
            %tags{$entity} = 1;
        }
    }
    
    for %tags.keys -> $index {
        my $object = $step-data.entities{$index};
        if $object ~~ ISO_10303_21::Record {
            given $object.keyword {
                when "CONTEXT_DEPENDENT_SHAPE_REPRESENTATION" { say qq{    "$index" [shape=box,color=yellow,style=filled] } }
                when "ADVANCED_BREP_SHAPE_REPRESENTATION" { say qq{    "$index" [shape=box,color=blue,style=filled] } }
                when "SHAPE_REPRESENTATION" { say qq{    "$index" [shape=box] } }
                when "NEXT_ASSEMBLY_USAGE_OCCURRENCE" { say qq{    "$index" [shape=diamond] } }
                when "AXIS2_PLACEMENT_3D" { say qq{    "$index" [shape=invtriangle] } }
            }
        }
    }
    
    for %look-for.keys -> $index {
        my $object = $step-data.entities{$index};
        for entity-references($object) -> $reference {
            say qq[    "$index" -> "$reference";];
        }
    }
    say "\}";
    
    for %types.keys -> $type {
        $*ERR.say: "Found $type";
    }
}