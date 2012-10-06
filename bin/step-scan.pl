use v6;
use ISO_10303_21::Grammar;

for @*ARGS -> $file {
    say "Reading $file";
    my $file-data = slurp($file);
    $file-data .= subst(/"/*" .*? "*/"/, " ", :global);
    my $match = ISO_10303_21::LooseGrammar.parse($file-data, :rule<exchange_file>);
    if $match ~~ Match && $match {
        say "    read correctly!";
    } else {
        say "    failed!!!!";
    }
}
