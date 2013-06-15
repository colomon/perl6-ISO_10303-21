#!/usr/bin/env perl6

use v6;
use ISO_10303_21::Grammar;

class ScanActions {
    has %.entities-to-check;
    has %.circles;
    
    method simple_entity_instance($/)  { 
        given $<simple_record><keyword> {
            when "CIRCLE" { %.circles{~$<entity_instance_name>} = 1; }
            when "TRIMMED_CURVE" {
                my @parameters = $<simple_record><parameter_list>[0]<parameter>;
                @parameters.shift if ~@parameters[0].substr(0, 1) eq "'";
                my $link = ~@parameters[0];
                my $trim1 = ~@parameters[1];
                my $trim2 = ~@parameters[2];
                my $bool = ~@parameters[3];
                say "TRIMMED_CURVE: $link, $trim1, $trim2, $bool";
                if $bool eq ".F." {
                    %.entities-to-check{$link} = 1;
                }
            }
        }
    }
}

for @*ARGS -> $file {
    say "Reading $file";
    my $actions = ScanActions.new;
    my $file-data = slurp($file);
    $file-data .= subst(/"/*" .*? "*/"/, " ", :global);
    my $match = ISO_10303_21::LooseGrammar.parse($file-data, :rule<exchange_file>, :$actions);
    if $match ~~ Match && $match {
        say "    read correctly!";
    } else {
        say "    failed!!!!";
    }
    
    # say set $actions.entities-to-check;
    # say set $actions.circles;
    say $actions.entities-to-check (&) $actions.circles;
}
