use v6;
use Test;
use ISO_10303_21::Grammar;
use ISO_10303_21::Actions;

my $match = ISO_10303_21::Grammar.parse("#12",
                                        :rule<parameter>,
                                        :actions(ISO_10303_21::Actions.new));
isa_ok $match, Match, "<parameter> matches #12";
ok $match, "<parameter> matches #12";
isa_ok $match.ast, Str, "and ast is Str";
is $match.ast, "#12", "and ast is #12";

$match = ISO_10303_21::Grammar.parse("#12",
                                     :rule<untyped_parameter>,
                                     :actions(ISO_10303_21::Actions.new));
isa_ok $match, Match, "<untyped_parameter> matches #12";
ok $match, "<untyped_parameter> matches #12";
isa_ok $match.ast, Str, "and ast is Str";
is $match.ast, "#12", "and ast is #12";

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

$match = ISO_10303_21::Grammar.parse("'Blah', #42",
                                     :rule<parameter_list>,
                                     :actions(ISO_10303_21::Actions.new));
isa_ok $match, Match, "<parameter_list> matches #12, #42";
ok $match, "<parameter_list> matches #12, #42";
isa_ok $match.ast, Array, "and the ast is Array";
is +$match.ast, 2, "and the ast has length 1";
isa_ok $match.ast[0], Str, "and ast[0] is Str";
is $match.ast[0], "'Blah'", "and ast[0] is 'Blah'";
isa_ok $match.ast[1], Str, "and ast[1] is Str";
is $match.ast[1], "#42", "and ast[1] is #42";

$match = ISO_10303_21::Grammar.parse("LEAF('Blah', #42)",
                                     :rule<simple_record>,
                                     :actions(ISO_10303_21::Actions.new));
isa_ok $match, Match, "<simple_record> matches LEAF('Blah', #42)";
ok $match, "<simple_record> matches LEAF('Blah', #42)";
isa_ok $match.ast, ISO_10303_21::Record, "and the ast is ISO_10303_21::Record";
isa_ok $match.ast.keyword, Str, "with a Str keyword";
is $match.ast.keyword, "LEAF", "'LEAF'";
is +$match.ast.parameters, 2, "and the parameters has length 2";
isa_ok $match.ast.parameters[0], Str, "and parameters[0] is Str";
is $match.ast.parameters[0], "'Blah'", "and parameters[0] is 'Blah'";
isa_ok $match.ast.parameters[1], Str, "and parameters[1] is Str";
is $match.ast.parameters[1], "#42", "and parameters[1] is #42";
is +$match.ast.entity_instances, 1, "It's got one entity_instance";
is $match.ast.entity_instances[0], "#42", "... which is #42";

$match = ISO_10303_21::Grammar.parse("LEAF()",
                                     :rule<simple_record>,
                                     :actions(ISO_10303_21::Actions.new));
isa_ok $match, Match, "<simple_record> matches LEAF()";
ok $match, "<simple_record> matches LEAF()";
isa_ok $match.ast, ISO_10303_21::Record, "and the ast is ISO_10303_21::Record";
isa_ok $match.ast.keyword, Str, "with a Str keyword";
is $match.ast.keyword, "LEAF", "'LEAF'";
is +$match.ast.parameters, 0, "and the parameters has length 0";

$match = ISO_10303_21::Grammar.parse("(LEAF('Blah', #42) BRANCH(#1949))",
                                     :rule<subsuper_record>,
                                     :actions(ISO_10303_21::Actions.new));
isa_ok $match, Match, "<subsuper_record> matches LEAF('Blah', #42) BRANCH(#1949)";
ok $match, "<subsuper_record> matches LEAF('Blah', #42) BRANCH(#1949)";
is +$match.ast, 2, "Got two records";
isa_ok $match.ast[0], ISO_10303_21::Record, "and the ast[0] is ISO_10303_21::Record";
isa_ok $match.ast[1], ISO_10303_21::Record, "and the ast[1] is ISO_10303_21::Record";
is $match.ast[0].keyword, "LEAF", "'LEAF'";
is $match.ast[1].keyword, "BRANCH", "'BRANCH'";

$match = ISO_10303_21::Grammar.parse("PRODUCT_RELATED_PRODUCT_CATEGORY('detail',\$,(#8));",
                                     :rule<simple_record>,
                                     :actions(ISO_10303_21::Actions.new));
isa_ok $match, Match, "<simple_record> matches PRODUCT_RELATED_PRODUCT_CATEGORY('detail',\$,(#8));";
ok $match, "<simple_record> matches PRODUCT_RELATED_PRODUCT_CATEGORY('detail',\$,(#8));";
isa_ok $match.ast, ISO_10303_21::Record, "and the ast is ISO_10303_21::Record";
isa_ok $match.ast.keyword, Str, "with a Str keyword";
is $match.ast.keyword, "PRODUCT_RELATED_PRODUCT_CATEGORY", "'PRODUCT_RELATED_PRODUCT_CATEGORY'";
is +$match.ast.parameters, 3, "and the parameters has length 3";

{
    my $file = ISO_10303_21::Actions.new;
    my $step = "DATA; #24=ORGANIZATION('','None','None'); #25=PERSON_AND_ORGANIZATION(#23,#24); ENDSEC;";
    $match = ISO_10303_21::Grammar.parse($step,
                                         :rule<data_section>,
                                         :actions($file));
    isa_ok $match, Match, "<data_section> matches STEP file snippet";
    ok $match, "<data_section> matches ";
    is +$file.entities, 2, "Got two entities";
    is $file.entities{'#24'}.keyword, "ORGANIZATION", '#24 is an ORGANIZATION';
    is $file.entities{'#25'}.keyword, "PERSON_AND_ORGANIZATION", '#25 is an PERSON_AND_ORGANIZATION';
}

{
    my $file = ISO_10303_21::Actions.new;
    my $file-data = slurp("t/CAx/as1-id-203.stp");
    $file-data .= subst(/"/*" .*? "*/"/, " ", :global);
    
    my $match = ISO_10303_21::Grammar.parse($file-data, 
                                            :rule<exchange_file>,
                                            :actions($file));
    isa_ok $match, Match, "Grammar.<exchange_file> returns a Match for file...";
    ok $match, "... and it matches";
    
    is $file.entities{'#24'}.keyword, "ORGANIZATION", '#24 is an ORGANIZATION';
    is $file.entities{'#25'}.keyword, "PERSON_AND_ORGANIZATION", '#25 is an PERSON_AND_ORGANIZATION';
    # (LENGTH_UNIT()NAMED_UNIT(*)SI_UNIT(.MILLI.,.METRE.));
    is +$file.entities{'#116'}, 3, '#116 has 3 bits';
    is $file.entities{'#116'}>>.keyword.sort.join(" "), 
       "LENGTH_UNIT NAMED_UNIT SI_UNIT", 
       "and they have correct keywords";
}

done;
