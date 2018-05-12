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

sub face-to-edges(%entities, $face) {
    my @edges;
    for %entities{$face}.parameters[1].list -> $loop {
        if my $loop-entity = %entities{$loop} {
            if my $edge-loop-entity = %entities{$loop-entity.parameters[1]} {
                @edges.push(|$edge-loop-entity.parameters[1].list);
            }
        } else {
            $*ERR.say: "Unable to find loop $loop";
        }
    }

    for @edges -> $edge is rw {
        if %entities{$edge} ~~ ISO_10303_21::Record
           && %entities{$edge}.keyword eq "ORIENTED_EDGE" {
            $edge = %entities{$edge}.parameters[3];
        }
    }

    set(|@edges);
}

sub MAIN($file, $face-raw) {
    my $face = $face-raw ~~ /^ "#"/ ?? $face-raw !! "#" ~ $face-raw;
    note "Reading $file looking for face $face";
    
    my $file-data = slurp($file, encoding => "latin1");
    $file-data .= subst(/"/*" .*? "*/"/, " ", :global);
    my $step-data = ISO_10303_21::Actions.new;
    my $match = ISO_10303_21::LooseGrammar.parse($file-data, :rule<exchange_file>, :actions($step-data));
    unless $match ~~ Match && $match {
        $*ERR.say: "Something went wrong with the import.";
        next;
    }
    $*ERR.say: "$file read and parsed";

    my %edges-of-face;
    for $step-data.entities.kv -> $id, $object {
        if $object ~~ ISO_10303_21::Record && $object.keyword eq "ADVANCED_FACE" {
            %edges-of-face{$id} = face-to-edges($step-data.entities, $id);
        }
    }

    my $known-edges = %edges-of-face{$face};
    
    my %faces-of-edge;
    for %edges-of-face.keys -> $id {
        # dd $id;
        # dd %edges-of-face{$id};
        # dd %edges-of-face{$id}.keys;
        for %edges-of-face{$id}.keys -> $edge {
            %faces-of-edge{$edge}.push: $id;
        }
    }
    
    # dd $known-edges;
    my $faces = SetHash.new;
    for $known-edges.keys -> $edge {
        $faces (|)= %faces-of-edge{$edge};
        # dd %faces-of-edge{$edge};
    }
    
    dd $faces;

    # say %edges-of-face.keys.grep({ %edges-of-face{$_} (&) $known-edges });
}
