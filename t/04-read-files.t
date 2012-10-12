use v6;
use Test;
use ISO_10303_21::Grammar;

my @files = ('t/CAx/as1-id-203.stp', 't/CAx/conrod.stp', 't/CAx/s1-id-214.stp');

for @files -> $file {
    say "Reading $file";
    my $file-data = slurp($file);
    $file-data .= subst(/"/*" .*? "*/"/, " ", :global);
    my $match = ISO_10303_21::Grammar.parse($file-data, :rule<exchange_file>);
    isa_ok $match, Match, "<exchange_file> matches $file - 1";
    ok $match, "<exchange_file> matches $file - 2";
    
    $match = ISO_10303_21::LooseGrammar.parse($file-data, :rule<exchange_file>);
    isa_ok $match, Match, "LooseGrammar.<exchange_file> matches $file - 1";
    ok $match, "LooseGrammar.<exchange_file> matches $file - 2";
}

@files = ('t/CAx/boot.stp', 't/CAx/clamp.stp', 't/CAx/s1-ug-203.stp');

for @files -> $file {
    say "Reading $file";
    my $file-data = slurp($file);
    $file-data .= subst(/"/*" .*? "*/"/, " ", :global);
    
    my $match = ISO_10303_21::Grammar.parse($file-data, :rule<exchange_file>);
    isa_ok $match, Match, "Grammar.<exchange_file> returns a Match for $file...";
    nok $match, "... but it does not match";
    
    $match = ISO_10303_21::LooseGrammar.parse($file-data, :rule<exchange_file>);
    isa_ok $match, Match, "LooseGrammar.<exchange_file> matches $file - 1";
    ok $match, "LooseGrammar.<exchange_file> matches $file - 2";
}

done;
