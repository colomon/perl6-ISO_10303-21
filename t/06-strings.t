use v6;
use Test;
use ISO_10303_21::Grammar;
use ISO_10303_21::Actions;
use ISO_10303_21::Utils;

plan 13;

# {
#     my $match = ISO_10303_21::Grammar.parse('\X\42', :rule<arbitrary>, :actions(ISO_10303_21::Actions.new));
#     isa_ok $match, Match, "<arbitrary> matches \\X\\42 - 1";
#     ok $match, "<arbitrary> matches \\X\\42 - 2";
#     is $match.ast, "B", "ast is correct";
# }
# 
# {
#     my $match = ISO_10303_21::Grammar.parse('\X2\03BA1F7903C303BC03B5\X0\\', :rule<extended2>,
#                                             :actions(ISO_10303_21::Actions.new));
#     isa_ok $match, Match, "<extended2> matches \\X2\\ - 1";
#     ok $match, "<extended2> matches \\X2\\ - 2";
#     is $match.ast.ords.join(","), "954,8057,963,956,949", "ast is correct";
# }
# 
# {
#     my $match = ISO_10303_21::Grammar.parse('\X4\000003BA00001F79000003C3000003BC000003B5\X0\\', :rule<extended4>,
#                                             :actions(ISO_10303_21::Actions.new));
#     isa_ok $match, Match, "<extended4> matches \\X4\\ - 1";
#     ok $match, "<extended4> matches \\X4\\ - 2";
#     is $match.ast.ords.join(","), "954,8057,963,956,949", "ast is correct";
# }

my @strings = "Ἰοὺ ἰού· τὰ πάντʼ ἂν ἐξήκοι σαφῆ.";

for @strings -> $string {
    my $encoded = EncodeString($string);
    say $encoded;
    ok $encoded.ords.grep({ $_ < 32 || 127 < $_ }) == 0, "$string is encoded with all ASCII characters";
    
    my $match = ISO_10303_21::Grammar.parse($encoded, :rule<string>, :actions(ISO_10303_21::Actions.new));
    isa_ok $match, Match, "<string> matches string - 1";
    ok $match, "<string> matches string - 2";
    say $match.ast;
    is $match.ast, $string, "ast is correct";
}