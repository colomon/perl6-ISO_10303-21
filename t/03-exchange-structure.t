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

{
    my $record = q[DIMENSIONAL_EXPONENTS(0.0,0.0,0.0,0.0,0.0,0.0,0.0)];
    my $match = ISO_10303_21::Grammar.parse($record, :rule<simple_record>);
    isa_ok $match, Match, "<simple_record> matches $record - 1";
    ok $match, "<simple_record> matches $record - 2";
}

{
    my $record = q[#2=DIMENSIONAL_EXPONENTS(0.0,0.0,0.0,0.0,0.0,0.0,0.0);];
    my $match = ISO_10303_21::Grammar.parse($record, :rule<simple_entity_instance>);
    isa_ok $match, Match, "<simple_entity_instance> matches $record - 1";
    ok $match, "<simple_entity_instance> matches $record - 2";
}

my @entities = (
    q[#2=DIMENSIONAL_EXPONENTS(0.0,0.0,0.0,0.0,0.0,0.0,0.0);],
    q[#17=PRODUCT_DEFINITION('CAx-AS1','Design Definition',#16,#13);],
    q[#49=PRODUCT('nut','nut','Generic Nut for AS1 Assembly',(#12));],
    q[#69=CARTESIAN_POINT('#69',(0.0,40.,55.));],
    q[#140=(BOUNDED_CURVE()B_SPLINE_CURVE(3,(#136,#137,#138,#139),
    .UNSPECIFIED.,.F.,.F.)B_SPLINE_CURVE_WITH_KNOTS((4,4),(0.0,0.5),
    .UNSPECIFIED.)CURVE()GEOMETRIC_REPRESENTATION_ITEM()
    RATIONAL_B_SPLINE_CURVE((1.0,0.33333333333,0.33333333333,1.0))
    REPRESENTATION_ITEM('#140'));],
    );

for @entities -> $entity {
    my $match = ISO_10303_21::Grammar.parse($entity, :rule<entity_instance>);
    isa_ok $match, Match, "<entity_instance> matches $entity - 1";
    ok $match, "<entity_instance> matches $entity - 2";
}


done;