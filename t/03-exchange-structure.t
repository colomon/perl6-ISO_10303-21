use v6;
use Test;
use ISO_10303_21::Grammar;

my @parameters = (
        "*",
        '$',
        "#2",
        ".ENUMERATION.",
        "(#24)",
        '(#24, $)',
        '($, (#1), *)',
    );
    
for @parameters -> $trial-parameter {
    my $match = ISO_10303_21::Grammar.parse($trial-parameter, :rule<parameter>);
    isa_ok $match, Match, "<parameter> matches $trial-parameter - 1";
    ok $match, "<parameter> matches $trial-parameter - 2";
}

{
    my $header = q[('CAx 3rd Joint Test Round - Test Model AS1', 'Validation Properties Test Model   '),'1';];
    my $match = ISO_10303_21::Grammar.parse($header, :rule<parameter_list>);
    isa_ok $match, Match, "<parameter_list> matches a parameter_list - 1";
    ok $match, "<parameter_list> matches a parameter_list - 2";
}

{
    my $header = q[FILE_DESCRIPTION(('CAx 3rd Joint Test Round - Test Model AS1', 'Validation Properties Test Model   '),'1');];
    my $match = ISO_10303_21::Grammar.parse($header, :rule<header_entity>);
    isa_ok $match, Match, "<header_entity> matches a header - 1";
    ok $match, "<header_entity> matches a header - 2";
}

{
    my $header =
q[HEADER;
FILE_DESCRIPTION(('CAx 3rd Joint Test Round - Test Model AS1',
'Validation Properties Test Model   '),'1');
FILE_NAME('as1-tc-214.stp',
'2000-02-04 T10:13:49',
('SD Yates '),
('Theorem Solutions Ltd'),
'THEOREM SOLUTIONS CADDS -> AP214 DIS PREPROCESSOR 4.0.002',
'CADDS4X/5  - CAMU',
'AP Ranger   ');
FILE_SCHEMA(('AUTOMOTIVE_DESIGN { 1 2 10303 214 0 1 1 1 } '));
ENDSEC;];
    
    my $match = ISO_10303_21::Grammar.parse($header, :rule<header_section>);
    isa_ok $match, Match, "<header_section> matches a header - 1";
    ok $match, "<header_section> matches a header - 2";
}

done;