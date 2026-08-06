/*
    xstl_v7_requested_intersection.scad

    Compatibility/example wrapper for the requested intersection call.
    Load xstl_v7.scad with use<> so the core file can keep using
    OpenSCAD's built-in CSG intersection() internally.
*/

use <xstl_v7.scad>

module intersection(
    angle = 90,
    lengthA = 80,
    lengthB = 80,
    end1A = "nest",
    end2A = "plug",
    end1B = "nest",
    end2B = "plug",
    both_sides = true
) {
    track_intersection(
        angle = angle,
        lengthA = lengthA,
        lengthB = lengthB,
        end1A = end1A,
        end2A = end2A,
        end1B = end1B,
        end2B = end2B,
        both_sides = both_sides
    );
}

intersection(angle = 45,
             lengthA = 152,
             lengthB = 152,
             end1A = "nest",
             end2A = "nest",
             end1B = "plug",
             end2B = "plug",
             both_sides = true);
