use v6;
use Test;
use ISO_10303_21::Grammar;

for (0..9)».Str -> $digit {
    my $match = ISO_10303_21::Grammar.parse($digit, :rule<digit>);
    isa_ok $match, Match, "<digit> matches $digit - 1";
    ok $match, "<digit> matches $digit - 2";
}

for 'a'..'z' -> $lower {
    my $match = ISO_10303_21::Grammar.parse($lower, :rule<lower>);
    isa_ok $match, Match, "<lower> matches $lower - 1";
    ok $match, "<lower> matches $lower - 2";
}

for 'A'..'Z' -> $upper {
    my $match = ISO_10303_21::Grammar.parse($upper, :rule<upper>);
    isa_ok $match, Match, "<upper> matches $upper - 1";
    ok $match, "<upper> matches $upper - 2";
}

for '!"*$%&.#+,-()?/:;<=>@[]{|}^`~'.comb -> $symbol {
    my $match = ISO_10303_21::Grammar.parse($symbol, :rule<special>);
    isa_ok $match, Match, "<special> matches $symbol - 1";
    ok $match, "<special> matches $symbol - 2";
}

done;