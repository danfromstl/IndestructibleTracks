/*
    XSTL V11 — SF200 reconstruction with rounded relief cutouts

    Reverse-engineered from "Adapted Original - SF200.stl".
    The STL was rotated 45 degrees; this source restores the normal X-across,
    Y-forward, Z-up coordinate system used by XSTL.

    This is intentionally a focused, self-contained flexy generator.  The
    defaults reproduce the measured STL; change the CUSTOMIZER values afterward
    to create derivatives while keeping the same construction method.
*/

/* [SF200 measured geometry] */
body_length = 200;              // [20:0.1:400]
start_block_length = 11.5;      // [5:0.1:80]
finish_block_length = 23.5;     // [5:0.1:80]
oscillations = 41;              // [1:1:80]
section_length = 3.0;           // [0.5:0.05:20]
gap_length = 1.0;               // [0.25:0.05:8]
bridge_width = 13.0;            // [1:0.05:19]
bridge_phase = "left_first";    // [left_first:Left first,right_first:Right first]

// True semicircular inner termination. "flat" preserves the V10-style option.
cutout_end_style = "round";     // [round:Round,flat:Flat]

// The source STL's curved rim changes by 0.5 mm between Z=0/12 and the
// vertical cutout wall. Auto clamps the bevel to the cutout's end radius.
cutout_chamfer_run = 0.5;        // [0:0.05:2]
cutout_fragments = 32;           // [12:4:96]

/* [Track profile] */
track_width = 40;
track_height = 12;
body_chamfer_run = 1.0;
end_chamfer_run = 1.0;
well_depth = 3.0;
well_top_width = 7.0;
well_bottom_width = 5.0;
well_spacing = 25.0;
two_sided = false;

/* [Connectors] */
start_end = "plug";             // [plug:Plug,nest:Nest,none:None]
finish_end = "nest";            // [plug:Plug,nest:Nest,none:None]
plug_radius = 6.25;
plug_neck_width = 6.1;
plug_neck_length = 12.0;
nest_radius = 6.4;
nest_neck_width = 6.3;
nest_neck_length = 12.0;
connector_overlap = 1.25;
connector_surface_chamfer = 1.0;
connector_neck_chamfer_run = 1.0;

/* [Output] */
fragments = 96;                 // [24:8:240]
show_measurement_markers = false;

/* [Hidden] */
epsilon = 0.01;
$fn = fragments;

gap_count = oscillations + 1;
repeat_length = oscillations * section_length + gap_count * gap_length;
calculated_body_length = start_block_length + repeat_length + finish_block_length;

assert(abs(calculated_body_length - body_length) < 0.001,
    str("Blocks + repeat must equal body_length; got ", calculated_body_length));
assert(bridge_width > 0 && bridge_width < track_width);
assert(cutout_end_style == "round" || cutout_end_style == "flat");
assert(cutout_chamfer_run >= 0 && cutout_chamfer_run <= gap_length/2,
    "cutout_chamfer_run must fit within half the relief-gap width");
assert(start_end == "plug" || start_end == "nest" || start_end == "none");
assert(finish_end == "plug" || finish_end == "nest" || finish_end == "none");

module chamfered_rectangle_2d(width, height, run) {
    polygon([
        [run, 0], [width-run, 0], [width, run],
        [width, height-run], [width-run, height], [run, height],
        [0, height-run], [0, run]
    ]);
}

module rail_well_2d() {
    polygon([
        [-well_bottom_width/2, 0], [well_bottom_width/2, 0],
        [well_top_width/2, well_depth], [-well_top_width/2, well_depth]
    ]);
}

module material_profile_2d(erode=0) {
    offset(delta=-erode)
        translate([-track_width/2, 0])
            difference() {
                chamfered_rectangle_2d(track_width, track_height, body_chamfer_run);
                for (x=[-well_spacing/2, well_spacing/2])
                    translate([track_width/2+x, track_height-well_depth+epsilon])
                        rail_well_2d();
                if (two_sided)
                    for (x=[-well_spacing/2, well_spacing/2])
                        translate([track_width/2+x, well_depth-epsilon])
                            rotate(180) rail_well_2d();
            }
}

module extrude_xz(y0, y1) {
    translate([0,y1,0]) rotate([90,0,0])
        linear_extrude(y1-y0, convexity=10) children();
}

module extrude_yz(x0, x1) {
    multmatrix([[0,0,1,x0],[1,0,0,0],[0,1,0,0],[0,0,0,1]])
        linear_extrude(x1-x0, convexity=10) children();
}

module body_raw() {
    extrude_xz(0, body_length) material_profile_2d();
}

module profile_slice(y, erode=0) {
    translate([0,y+epsilon,0]) rotate([90,0,0])
        linear_extrude(2*epsilon) material_profile_2d(erode);
}

module end_keep_mask(at_finish=false) {
    big=body_length+100;
    if (!at_finish) {
        union() {
            hull() { profile_slice(0,end_chamfer_run); profile_slice(end_chamfer_run,0); }
            translate([-big/2,end_chamfer_run,-big/2]) cube([big,big,big]);
        }
    } else {
        translate([0,body_length,0]) rotate([0,0,180])
            union() {
                hull() { profile_slice(0,end_chamfer_run); profile_slice(end_chamfer_run,0); }
                translate([-big/2,end_chamfer_run,-big/2]) cube([big,big,big]);
            }
    }
}

module chamfered_neck_2d(width, outward=false) {
    r=connector_neck_chamfer_run;
    if (!outward)
        polygon([[-width/2+r,0],[width/2-r,0],[width/2,r],
                 [width/2,track_height-r],[width/2-r,track_height],
                 [-width/2+r,track_height],[-width/2,track_height-r],[-width/2,r]]);
    else
        polygon([[-width/2-r,-epsilon],[width/2+r,-epsilon],[width/2,r],
                 [width/2,track_height-r],[width/2+r,track_height+epsilon],
                 [-width/2-r,track_height+epsilon],[-width/2,track_height-r],[-width/2,r]]);
}

module plug_head() {
    h=connector_surface_chamfer;
    rotate_extrude(convexity=10)
        polygon([[0,0],[plug_radius-h,0],[plug_radius,h],
                 [plug_radius,track_height-h],[plug_radius-h,track_height],[0,track_height]]);
}

module plug_local() {
    union() {
        extrude_xz(-connector_overlap,plug_neck_length)
            chamfered_neck_2d(plug_neck_width);
        translate([0,plug_neck_length,0]) plug_head();
    }
}

module nest_head_cutter() {
    h=connector_surface_chamfer;
    rotate_extrude(convexity=10)
        polygon([[0,-epsilon],[nest_radius+h,-epsilon],[nest_radius,h],
                 [nest_radius,track_height-h],[nest_radius+h,track_height+epsilon],
                 [0,track_height+epsilon]]);
}

module nest_local() {
    union() {
        extrude_xz(-connector_overlap,nest_neck_length)
            chamfered_neck_2d(nest_neck_width,true);
        translate([0,nest_neck_length,0]) nest_head_cutter();
        hull() {
            translate([-nest_neck_width/2-end_chamfer_run,-epsilon,-end_chamfer_run])
                cube([nest_neck_width+2*end_chamfer_run,2*epsilon,
                      track_height+2*end_chamfer_run]);
            translate([-nest_neck_width/2,end_chamfer_run-epsilon,0])
                cube([nest_neck_width,2*epsilon,track_height]);
        }
    }
}

function gap_start(i)=start_block_length+i*(section_length+gap_length);
function bridge_left(i)=bridge_phase == "left_first" ? i%2==0 : i%2==1;

function edge_bevel_triangle(edge, material_direction, surface_z, inner_z, run) =
    material_direction < 0
        ? [[edge-run,surface_z],[edge+epsilon,surface_z],[edge+epsilon,inner_z]]
        : [[edge-epsilon,surface_z],[edge+run,surface_z],[edge-epsilon,inner_z]];

module edge_bevel_profiles_2d(edge, material_direction) {
    polygon(edge_bevel_triangle(edge,material_direction,
        track_height+epsilon,track_height-body_chamfer_run-epsilon,body_chamfer_run));
    polygon(edge_bevel_triangle(edge,material_direction,
        -epsilon,body_chamfer_run+epsilon,body_chamfer_run));
}

module gap_side_bevels(y0, left, inner_center_x) {
    y1=y0+gap_length;
    cut_x0=left ? inner_center_x : -track_width/2-epsilon;
    cut_x1=left ? track_width/2+epsilon : inner_center_x;

    // Use the source cutout's 0.5 mm rim rather than the 1 mm body bevel.
    r=cutout_chamfer_run;
    if (r > 0) {
        extrude_yz(cut_x0,cut_x1) {
            polygon(edge_bevel_triangle(y0,-1,
                track_height+epsilon,track_height-r-epsilon,r));
            polygon(edge_bevel_triangle(y0,-1,-epsilon,r+epsilon,r));
        }
        extrude_yz(cut_x0,cut_x1) {
            polygon(edge_bevel_triangle(y1,1,
                track_height+epsilon,track_height-r-epsilon,r));
            polygon(edge_bevel_triangle(y1,1,-epsilon,r+epsilon,r));
        }
    }
}

// A full frustum is safe here: its outer-facing half lies inside the straight
// slot cutter, while its inner-facing half creates the continuously curved rim.
module rounded_end_bevels(center_x, center_y) {
    r=gap_length/2;
    c=cutout_chamfer_run;
    if (c > 0) {
        translate([center_x,center_y,-epsilon])
            cylinder(h=c+epsilon,r1=r+c,r2=r,$fn=cutout_fragments);
        translate([center_x,center_y,track_height-c])
            cylinder(h=c+epsilon,r1=r,r2=r+c,$fn=cutout_fragments);
    }
}

module relief_gap(i) {
    left=bridge_left(i);
    y0=gap_start(i);
    r=gap_length/2;
    tip_x=left ? -track_width/2+bridge_width : track_width/2-bridge_width;
    center_x=tip_x+(left ? r : -r);
    center_y=y0+r;
    x0=left ? center_x : -track_width/2-epsilon;
    x1=left ? track_width/2+epsilon : center_x;

    // Straight portion remains open to the selected outside edge.
    translate([x0,y0-epsilon,-epsilon])
        cube([x1-x0,gap_length+2*epsilon,track_height+2*epsilon]);

    if (cutout_end_style == "round") {
        translate([center_x,center_y,-epsilon])
            cylinder(h=track_height+2*epsilon,r=r,$fn=cutout_fragments);
        gap_side_bevels(y0,left,center_x);
        rounded_end_bevels(center_x,center_y);
    } else {
        // Compatibility mode: extend the flat slot to the same 13 mm tip.
        translate([min(center_x,tip_x),y0-epsilon,-epsilon])
            cube([abs(center_x-tip_x)+epsilon,gap_length+2*epsilon,
                  track_height+2*epsilon]);
        gap_side_bevels(y0,left,tip_x);
    }
}

module connector_additions() {
    if (start_end=="plug") rotate([0,0,180]) plug_local();
    if (finish_end=="plug") translate([0,body_length,0]) plug_local();
}

module connector_cutters() {
    if (start_end=="nest") nest_local();
    if (finish_end=="nest") translate([0,body_length,0]) rotate([0,0,180]) nest_local();
}

module sf200_track() {
    difference() {
        union() {
            intersection() { body_raw(); end_keep_mask(false); end_keep_mask(true); }
            connector_additions();
        }
        connector_cutters();
        for (i=[0:gap_count-1]) relief_gap(i);
    }
}

sf200_track();

if (show_measurement_markers) {
    color("red") translate([-track_width/2-3,0,track_height+1])
        cube([2,body_length,0.5]);
}

echo(str("XSTL V11 SF200 | body=",body_length,
         " | blocks=",start_block_length,"/",finish_block_length,
         " | oscillations/gaps=",oscillations,"/",gap_count,
         " | section/gap/bridge=",section_length,"/",gap_length,"/",bridge_width,
         " | relief-end=",cutout_end_style,
         " | relief-radius=",gap_length/2,
         " | relief-chamfer=",cutout_chamfer_run,
         " | ends=",start_end,"/",finish_end));
