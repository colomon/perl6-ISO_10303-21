use v6;
use ISO_10303_21::Grammar;

class ISO_10303_21::Record {
    has $.keyword;
    has @.entity_instances;
}

class ISO_10303_21::Actions {
    method entity_instance_name($/) { make [~$/] }
    method parameter($/) { make $/.values[0].ast }
    method omitted_parameter($/) { make [] }
    method untyped_parameter($/) { make $/.values[0].ast // [] }
    method typed_parameter($/) { make $<parameter>.ast }
    method list_of_parameters($/) { make @($<parameter>)».ast.map(*.list).Array }
    method parameter_list($/) { make @($<parameter>)».ast.map(*.list).Array }

    method simple_record($/) {
        # bit awkward, but this way works in both Rakudo and Niecza
        if $<parameter_list> {
            my $parameter_list = $<parameter_list>;
            $parameter_list = $parameter_list[0] if $parameter_list ~~ Parcel;
            make ISO_10303_21::Record.new(:keyword(~$<keyword>),
                                          :entity_instances($parameter_list.ast // []));
        } else {
            make ISO_10303_21::Record.new(:keyword(~$<keyword>),
                                          :entity_instances([]));
        }
    }
    # method subsuper_record($/) { '(' <simple_record>+ ')' }
    # method simple_entity_instance($/) { <entity_instance_name> '=' <simple_record> ';' }
    # method complex_entity_instance($/) { <entity_instance_name> '=' <subsuper_record> ';' }
    # method entity_instance($/) { <simple_entity_instance> | <complex_entity_instance> }
}