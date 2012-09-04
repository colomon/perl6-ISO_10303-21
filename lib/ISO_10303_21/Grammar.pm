use v6;

grammar ISO_10303_21::Grammar
{
    token space { " " }
    token digit { <[0..9]> }
    token lower { <[a..z]> }
    token upper { <[A..Z]> | '_' }
    token special { '!' | '"' | '*' | '$' | '%' | '&' | '.' | '#'
                  | '+' | ',' | '-' | '(' | ')' | '?' | '/' | ':'
                  | ';' | '<' | '=' | '>' | '@' | '[' | ']' | '{'
                  | '|' | '}' | '^' | '`' | '~' }
    token reverse_solidus { '\\' }
    token apostrophe { "'" }
    token character { <space> | <digit> | <lower> | <upper> | <special> | <reverse_solidus> | <apostrophe> }
    
    token standard_keyword { <upper> [ <upper> | <digit> ]* }
    token user_defined_keyword { '!' <upper> [ <upper> | <digit> ]* }
    token keyword { <user_defined_keyword> | <standard_keyword> }
    
    token sign { '+' | '-' }
    token integer { <sign>? <digit> <digit>* }
    token real { <sign>? <digit>+ '.' <digit>* [ 'E' <sign>? <digit>+ ]? }
    
    token non_q_char { <special> | <digit> | <space> | <lower> | <upper> }
    # next one needs control directive too.
    token string { "'" [ <non_q_char> | [<apostrophe> ** 2] | [<reverse_solidus> ** 2] ]* "'" }
    
    token entity_instance_name { '#' <digit>+ }
    token enumeration { '.' <upper> [ <upper> | <digit> ]* '.' }
    
    token hex { <[0..9]> | <[A..F]> }
    token binary { '"' <[0..3]> <hex>* '"' }

    token parameter { <typed_parameter> | <untyped_parameter> | <omitted_parameter> }
    token omitted_parameter { '*' }
    token untyped_parameter { '$' | <real> | <integer> | <string> 
                            | <entity_instance_name> | <enumeration> | <binary> | <list_of_parameters> }
    rule typed_parameter { <keyword> '(' <parameter> ')' }
    rule list_of_parameters { '(' [ <parameter> ]* % [ ',' ] ')' }
    rule parameter_list { [ <parameter> ]+ % [ ',' ] }
    
    rule header_entity { <keyword> '(' <parameter_list> ')' ';' }
    rule header_entity_list { <header_entity>+ }
    rule header_section { 
        "HEADER;" 
        <header_entity> <header_entity> <header_entity>
        <header_entity_list>?
        "ENDSEC;"
    }

    rule simple_record { <keyword> '(' <parameter_list>? ')' }
    rule subsuper_record { '(' <simple_record>+ ')' }
    rule simple_entity_instance { <entity_instance_name> '=' <simple_record> ';' }
    rule complex_entity_instance { <entity_instance_name> '=' <subsuper_record> ';' }
    rule entity_instance { <simple_entity_instance> | <complex_entity_instance> }

    rule data_section { 
        "DATA" [ '(' <parameter_list> ')']? ';'
        <entity_instance>*
        "ENDSEC" ';' 
    }

    rule exchange_file {
        "ISO-10303-21;"
        <header_section> <data_section>+
        "END-ISO-10303-21;"
    }
}