use v6;
use Test;
use ISO_10303_21::Grammar;

my @files = <t/CAx/conrod.stp>;

for @files -> $file {
    my $file-data = slurp($file);
    my $match = ISO_10303_21::Grammar.parse($file-data, :rule<exchange_file>);
    isa_ok $match, Match, "<exchange_file> matches $file - 1";
    ok $match, "<exchange_file> matches $file - 2";
}

done; 