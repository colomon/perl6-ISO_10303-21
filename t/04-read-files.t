use v6;
use Test;
use ISO_10303_21::Grammar;

my @files = qx[find t/CAx -iname "*.s*p" -print].lines;
@files .= grep(none /boot.stp/, /clamp.stp/, /"s1-ug-203.stp"/);

for @files -> $file {
    say "Reading $file";
    my $file-data = slurp($file);
    $file-data .= subst(/"/*" .*? "*/"/, " ", :global);
    my $match = ISO_10303_21::Grammar.parse($file-data, :rule<exchange_file>);
    isa_ok $match, Match, "<exchange_file> matches $file - 1";
    ok $match, "<exchange_file> matches $file - 2";
}

@files .= pick(3);
@files.push('t/CAx/boot.stp', 't/CAx/clamp.stp', 't/CAx/s1-ug-203.stp');

for @files -> $file {
    say "Reading $file";
    my $file-data = slurp($file);
    $file-data .= subst(/"/*" .*? "*/"/, " ", :global);
    my $match = ISO_10303_21::LooseGrammar.parse($file-data, :rule<exchange_file>);
    isa_ok $match, Match, "<exchange_file> matches $file - 1";
    ok $match, "<exchange_file> matches $file - 2";
}

done; 