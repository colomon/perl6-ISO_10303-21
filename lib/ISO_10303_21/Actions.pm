use v6;
use ISO_10303_21::Grammar;

sub merge-arrays(@arrays) {
    my @result = @arrays.map(*.list);
    @result;
}

class ISO_10303_21::Actions {
    method entity_instance_name($/) { make [~$/] }
    method parameter($/) {
        for <typed_parameter untyped_parameter omitted_parameter> -> $s {
            return make $/{$s}.ast if $/{$s}.defined;
        }
    }
    method omitted_parameter($/) { make [] }
    method untyped_parameter($/) {
        for <entity_instance_name list_of_parameters> -> $s {
            return make $/{$s}.ast if $/{$s}.defined;
        }
        make [];
    }
    method typed_parameter($/) { make $<parameter>.ast }
    method list_of_parameters($/) { make merge-arrays(@($<parameter>)».ast); }
    method parameter_list($/) { make merge-arrays(@($<parameter>)».ast); }
}