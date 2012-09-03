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
}