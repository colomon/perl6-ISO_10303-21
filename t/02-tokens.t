use v6;
use Test;
use ISO_10303_21::Grammar;

for <A A2 AB2 AB2A> -> $keyword {
    my $match = ISO_10303_21::Grammar.parse($keyword, :rule<standard_keyword>);
    isa_ok $match, Match, "<standard_keyword> matches $keyword - 1";
    ok $match, "<standard_keyword> matches $keyword - 2";
}

for <a a2 ab2 ab2a 2AD> -> $keyword {
    my $match = ISO_10303_21::Grammar.parse($keyword, :rule<standard_keyword>);
    isa_ok $match, Match, "<standard_keyword> does not match $keyword - 1";
    nok $match, "<standard_keyword> does not match $keyword - 2";
}

for <A A2 AB2 AB2A> -> $keyword {
    my $match = ISO_10303_21::Grammar.parse("!" ~ $keyword, :rule<user_defined_keyword>);
    isa_ok $match, Match, "<user_defined_keyword> matches !$keyword - 1";
    ok $match, "<user_defined_keyword> matches !$keyword - 2";
}

for <a a2 ab2 ab2a 2AD !ad> -> $keyword {
    my $match = ISO_10303_21::Grammar.parse($keyword, :rule<user_defined_keyword>);
    isa_ok $match, Match, "<user_defined_keyword> does not match $keyword - 1";
    nok $match, "<user_defined_keyword> does not match $keyword - 2";
}

for <A A2 AB2 AB2A !Z !D23 !AB2A> -> $keyword {
    my $match = ISO_10303_21::Grammar.parse($keyword, :rule<keyword>);
    isa_ok $match, Match, "<keyword> matches $keyword - 1";
    ok $match, "<keyword> matches $keyword - 2";
}

for ("+", "-") -> $keyword {
    my $match = ISO_10303_21::Grammar.parse($keyword, :rule<sign>);
    isa_ok $match, Match, "<sign> matches $keyword - 1";
    ok $match, "<sign> matches $keyword - 2";
}



done;