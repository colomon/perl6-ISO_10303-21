use v6;
use ISO_10303_21::Grammar;

sub merge-arrays(@arrays) {
    my @result = @arrays.map(*.list);
    @result;
}

class ISO_10303_21::Actions {
    method entity_instance_name($/) { make [~$/] }
    method parameter($/) { make $/.values[0].ast }
    method omitted_parameter($/) { make [] }
    method untyped_parameter($/) { make $/.values[0].ast // [] }
    method typed_parameter($/) { make $<parameter>.ast }
    method list_of_parameters($/) { make merge-arrays(@($<parameter>)».ast) }
    method parameter_list($/) { make merge-arrays(@($<parameter>)».ast) }
}