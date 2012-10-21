use v6;
use ISO_10303_21::Grammar;
use ISO_10303_21::Actions;

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
    
    my @look-for;
    for $step-data.entities.kv -> $index, $object {
        if $object ~~ ISO_10303_21::Record {
            if $object.keyword ~~ /SHAPE_REPRESENTATION$/ {
                @look-for.push($index);
            }
        } else {
            if any($object.list.map({ $_.keyword ~~ /SHAPE_REPRESENTATION$/ })) {
                @look-for.push($index);
            }
        }
    }
    
}