use v6;
use Test;
use ISO_10303_21::Grammar;
use ISO_10303_21::Actions;

my $match = ISO_10303_21::Grammar.parse("#12",
                                        :rule<entity_instance_name>,
                                        :actions(ISO_10303_21::Actions.new));
isa_ok $match, Match, "<entity_instance_name> matches #12";
ok $match, "<entity_instance_name> matches #12";
isa_ok $match.ast, Array, "and the ast is Array";
is +$match.ast, 1, "and the ast has length 1";
isa_ok $match.ast[0], Str, "and ast[0] is Str";
is $match.ast[0], "#12", "and ast[0] is #12";

$match = ISO_10303_21::Grammar.parse("#12",
                                     :rule<untyped_parameter>,
                                     :actions(ISO_10303_21::Actions.new));
isa_ok $match, Match, "<untyped_parameter> matches #12";
ok $match, "<untyped_parameter> matches #12";
isa_ok $match.ast, Array, "and the ast is Array";
is +$match.ast, 1, "and the ast has length 1";
isa_ok $match.ast[0], Str, "and ast[0] is Str";
is $match.ast[0], "#12", "and ast[0] is #12";

$match = ISO_10303_21::Grammar.parse("(#12, #42)",
                                     :rule<list_of_parameters>,
                                     :actions(ISO_10303_21::Actions.new));
isa_ok $match, Match, "<list_of_parameters> matches (#12, #42)";
ok $match, "<list_of_parameters> matches (#12, #42)";
isa_ok $match.ast, Array, "and the ast is Array";
is +$match.ast, 2, "and the ast has length 2";
isa_ok $match.ast[0], Str, "and ast[0] is Str";
isa_ok $match.ast[1], Str, "and ast[1] is Str";
is $match.ast[0], "#12", "and ast[0] is #12";
is $match.ast[1], "#42", "and ast[1] is #42";

$match = ISO_10303_21::Grammar.parse("(#12, #42)",
                                     :rule<parameter>,
                                     :actions(ISO_10303_21::Actions.new));
isa_ok $match, Match, "<parameter> matches (#12, #42)";
ok $match, "<parameter> matches (#12, #42)";
isa_ok $match.ast, Array, "and the ast is Array";
is +$match.ast, 2, "and the ast has length 2";
isa_ok $match.ast[0], Str, "and ast[0] is Str";
isa_ok $match.ast[1], Str, "and ast[1] is Str";
is $match.ast[0], "#12", "and ast[0] is #12";
is $match.ast[1], "#42", "and ast[1] is #42";

$match = ISO_10303_21::Grammar.parse("#12, #42",
                                     :rule<parameter_list>,
                                     :actions(ISO_10303_21::Actions.new));
isa_ok $match, Match, "<parameter_list> matches #12, #42";
ok $match, "<parameter_list> matches #12, #42";
isa_ok $match.ast, Array, "and the ast is Array";
is +$match.ast, 2, "and the ast has length 2";
isa_ok $match.ast[0], Str, "and ast[0] is Str";
isa_ok $match.ast[1], Str, "and ast[1] is Str";
is $match.ast[0], "#12", "and ast[0] is #12";
is $match.ast[1], "#42", "and ast[1] is #42";

done;
