use v6;
use ISO_10303_21::Grammar;
use ISO_10303_21::Actions;

sub follow-chain(%entities, %reverse, $id) {
    # say :$id.perl;
    my $desc = "$id ({ %entities{$id}.map(*.keyword) })";
    if %entities{$id}.?keyword ~~ /SHAPE_REPRESENTATION$/ {
        # say "    finished $desc";
        return $desc;
    }
    my $owner;
    for %reverse{$id}.list -> $possible-owner {
        # say "        considering $possible-owner { %entities{$possible-owner}.map(*.keyword) }";
        next if %entities{$possible-owner}.?keyword eq "STYLED_ITEM" | "PRESENTATION_LAYER_ASSIGNMENT";
        $owner = $possible-owner;
    }
    return $desc unless $owner;
    $desc, follow-chain(%entities, %reverse, $owner);
}

sub MAIN($file, $face is rw) {
    $face = "#" ~ $face unless $face ~~ /^ "#"/;
    $*ERR.say: "Reading $file looking for face $face";
    my $file-data = slurp($file);
    $file-data .= subst(/"/*" .*? "*/"/, " ", :global);
    my $step-data = ISO_10303_21::Actions.new;
    my $match = ISO_10303_21::LooseGrammar.parse($file-data, :rule<exchange_file>, :actions($step-data));
    unless $match ~~ Match && $match {
        $*ERR.say: "Something went wrong with the import.";
        next;
    }
    $*ERR.say: "$file read and parsed";
    
    my %reverse = $step-data.entities.keys.categorize({ $step-data.entities{$_}.map(*.entity_instances) });
    $*ERR.say: "Reverse lookup index created";

    if $step-data.entities{$face} {
        my @edges;
        for $step-data.entities{$face}.parameters[1].list -> $loop {
            if my $loop-entity = $step-data.entities{$loop} {
                if my $edge-loop-entity = $step-data.entities{$loop-entity.parameters[1]} {
                    @edges.push($edge-loop-entity.parameters[1].list);
                }
            } else {
                $*ERR.say: "Unable to find loop $loop";
            }
        }

        say @edges;
        for @edges -> $edge is rw {
            if $step-data.entities{$edge} ~~ ISO_10303_21::Record
               && $step-data.entities{$edge}.keyword eq "ORIENTED_EDGE" {
                $edge = $step-data.entities{$edge}.parameters[3];
            }
        }
        say @edges;
        
        my @edge-owners = @edges.map({ %reverse{$_}.list });
        @edge-owners = @edge-owners.map({ $step-data.entities{$_}.?keyword eq "ORIENTED_EDGE" ?? %reverse{$_}.list !! $_ });
        say :@edge-owners.perl;
        my @owning-bounds = @edge-owners.map({ %reverse{$_}.list });
        say :@owning-bounds.perl;
        my @owning-faces = @owning-bounds.map({ %reverse{$_}.list }).Set.list;
        say :@owning-faces.perl;
    } else {
        $*ERR.say: "Unable to find face $face";
    }
    
}
