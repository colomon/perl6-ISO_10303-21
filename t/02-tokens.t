use v6;
use Test;
use ISO_10303_21::Grammar;

plan 104;

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

for <1 -1 +1 342 -3 0 -0> -> $keyword {
    my $match = ISO_10303_21::Grammar.parse($keyword, :rule<integer>);
    isa_ok $match, Match, "<integer> matches $keyword - 1";
    ok $match, "<integer> matches $keyword - 2";
}

for <1. -1.0 +1. 342.E2 -3.0E-2 0. -0.> -> $keyword {
    my $match = ISO_10303_21::Grammar.parse($keyword, :rule<real>);
    isa_ok $match, Match, "<real> matches $keyword - 1";
    ok $match, "<real> matches $keyword - 2";
}

for ("''", "'This is a test'", "''''", "'\\\\a different test'") -> $keyword {
    my $match = ISO_10303_21::Grammar.parse($keyword, :rule<string>);
    isa_ok $match, Match, "<string> matches $keyword - 1";
    ok $match, "<string> matches $keyword - 2";
}

for ("#1", "#23", "#141123") -> $keyword {
    my $match = ISO_10303_21::Grammar.parse($keyword, :rule<entity_instance_name>);
    isa_ok $match, Match, "<entity_instance_name> matches $keyword - 1";
    ok $match, "<entity_instance_name> matches $keyword - 2";
}

for (".A.", ".AD2.", ".GD.") -> $keyword {
    my $match = ISO_10303_21::Grammar.parse($keyword, :rule<enumeration>);
    isa_ok $match, Match, "<enumeration> matches $keyword - 1";
    ok $match, "<enumeration> matches $keyword - 2";
}
