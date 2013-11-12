use v6;
use Test;
use ISO_10303_21::Grammar;
use ISO_10303_21::Actions;

plan 9;

{
    my $match = ISO_10303_21::Grammar.parse('\X\42', :rule<arbitrary>, :actions(ISO_10303_21::Actions.new));
    isa_ok $match, Match, "<arbitrary> matches \\X\\42 - 1";
    ok $match, "<arbitrary> matches \\X\\42 - 2";
    is $match.ast, "B", "ast is correct";
}

{
    my $match = ISO_10303_21::Grammar.parse('\X2\03BA1F7903C303BC03B5\X0\\', :rule<extended2>,
                                            :actions(ISO_10303_21::Actions.new));
    isa_ok $match, Match, "<extended2> matches \\X2\\ - 1";
    ok $match, "<extended2> matches \\X2\\ - 2";
    is $match.ast.ords.join(","), "954,8057,963,956,949", "ast is correct";
}

{
    my $match = ISO_10303_21::Grammar.parse('\X4\000003BA00001F79000003C3000003BC000003B5\X0\\', :rule<extended4>,
                                            :actions(ISO_10303_21::Actions.new));
    isa_ok $match, Match, "<extended4> matches \\X4\\ - 1";
    ok $match, "<extended4> matches \\X4\\ - 2";
    is $match.ast.ords.join(","), "954,8057,963,956,949", "ast is correct";
}