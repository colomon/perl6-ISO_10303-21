use v6;
use ISO_10303_21::Grammar;
use ISO_10303_21::Actions;
use File::Find;

sub MAIN($dir = ".") {
    for find(dir => $dir, name => /:i ".st" e? "p" $ /) -> $file
    {
        say "Reading $file";
        my $file-data = slurp($file);
        $file-data .= subst(/"/*" .*? "*/"/, " ", :global);
        my $step-data = ISO_10303_21::Actions.new;
        my $match = ISO_10303_21::LooseGrammar.parse($file-data, :rule<exchange_file>, :actions($step-data));
        unless $match ~~ Match && $match {
            $*ERR.say: "Something went wrong with the import.";
            next;
        }
        $*ERR.say: "$file read and parsed";

        my $count = BagHash.new;
        for $step-data.entities.kv -> $id, $entity {
            given $entity {
                when ISO_10303_21::Record {
                    next if $entity.keyword eq "CONTEXT_DEPENDENT_SHAPE_REPRESENTATION";
                    if $entity.keyword ~~ / "SHAPE_REPRESENTATION" $/ {
                        for $entity.parameters[1].flat -> $a {
                            $count{$a}++;
                        }
                    }
                }
            }
        }
    
        for $count.keys.grep({ $count{$_} > 1 }) -> $id {
            say: "    $id was found { $count{$id} } times";
        }
    }
}
