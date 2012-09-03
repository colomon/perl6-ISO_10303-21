use v6;

grammar ISO_10303_21::Grammar
{
    token space { " " }
    token digit { <[0..9]> }
    token lower { <[a..z]> }
    token upper { <[A..Z]> }
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
}