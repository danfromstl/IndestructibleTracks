/*
    xstl_v8.scad

    Standalone, native-OpenSCAD generator for straight and curved
    wooden-railway-compatible track pieces.

    V8 goals:
      - Preserve the working V5 straight/curve geometry.
      - Use plug/nest terminology consistently; avoid legacy connector
        terminology.
      - Expose preview and final-render curve resolution as named controls.
      - Document that track bodies are solid except for rail wells and
        nest-connector cutouts; no weight-saving core is generated.
      - Retain the torwan-derived 2.9 mm rail-well depth pending physical
        calibration against genuine BRIO track.
      - Keep user controls, derived values, profiles, connectors, track
        bodies, and placement logic in clearly labeled sections.
      - Add a native XSTL intersection generator based on the original
        train_tracks_generator.scad intersection creator.
      - Add an experimental straight flexy track generator with explicit
        oscillation, gap, section, and solid-end-block controls.

    Coordinate convention:
      X = across the track (left/right)
      Y = forward along a straight track
      Z = vertical/up

      A local connector starts at the track end face, Y = 0, and points
      toward local +Y. Placement modules rotate that local connector so it
      points either outward (plug) or inward (nest cutter).

    Important curve convention:
      curve_centerline_radius = radius of the TRACK-BODY CENTERLINE
      curve_arc_length        = arc length along that same centerline
*/

// ===========================================================================
// CUSTOMIZER: MESH RESOLUTION
// ===========================================================================

/* [Mesh Resolution] */

// Number of straight facets used to approximate a complete 360-degree
// circle during the fast F5 preview. Lower values preview more quickly.
preview_curve_fragments = 96;           // [24:8:240]

// Number of facets used during F6 render and STL/3MF export. Higher values
// make circular heads and curved track edges smoother, but increase render
// time and mesh complexity. This preserves V5's final value of 240.
render_curve_fragments = 240;           // [48:8:480]

$fn = $preview ? preview_curve_fragments : render_curve_fragments;


// ===========================================================================
// CUSTOMIZER: TRACK SELECTION
// ===========================================================================

/* [Track Selection] */

// Choose the track body to generate.
track_type = "flexy_straight";         // [straight,curve,intersection,flexy_straight]

// Add matching rail wells to the underside.
two_sided = false;

// Connector at the beginning of the track.
start_end = "plug";                    // [plug,nest,none]

// Connector at the far end of the track.
finish_end = "nest";                   // [plug,nest,none]


// ===========================================================================
// CUSTOMIZER: FLEXY STRAIGHT SELECTION
// ===========================================================================

/* [Flexy Straight Selection] */

// Connector at the beginning of the flexy track.
flexy_start_end = "nest";              // [plug,nest,none]

// Connector at the far end of the flexy track.
flexy_finish_end = "plug";             // [plug,nest,none]

// Solid body length at local start. With defaults, this is the nest-end block.
flexy_start_block_length = 27.10;      // [15:0.1:80]

// Solid body length at local finish. With defaults, this is the plug-end block.
flexy_finish_block_length = 27.10;     // [15:0.1:80]


// ===========================================================================
// CUSTOMIZER: FLEXY OSCILLATIONS
// ===========================================================================

/* [Flexy Oscillations] */

// Number of repeated flexible track sections. The generator does not solve
// toward a target total length.
flexy_oscillations = 20;               // [1:1:60]

// Solid track-section length inside each oscillation.
flexy_section_length = 5.40;           // [1:0.05:20]

// Track-axis width of each alternating relief gap.
flexy_gap_length = 1.80;               // [0.4:0.05:8]

// Uncut side bridge left across each relief gap.
flexy_bridge_width = 3.60;             // [1:0.05:18]

// Which side keeps the first relief-gap bridge.
flexy_gap_bridge_phase = "right_first"; // [right_first,left_first]


// ===========================================================================
// CUSTOMIZER: INTERSECTION SELECTION
// ===========================================================================

/* [Intersection Selection] */

// Centerline angle between intersection leg A and leg B.
intersection_angle = 45;                // [15:0.1:165]

// Body length of leg A, excluding any plug connector.
intersection_length_a = 152;            // [40:0.1:400]

// Body length of leg B, excluding any plug connector.
intersection_length_b = 152;            // [40:0.1:400]

// Connector at the first end of leg A.
intersection_end1_a = "plug";          // [plug,nest,none]

// Connector at the second end of leg A.
intersection_end2_a = "nest";          // [plug,nest,none]

// Connector at the first end of leg B.
intersection_end1_b = "nest";          // [plug,nest,none]

// Connector at the second end of leg B.
intersection_end2_b = "plug";          // [plug,nest,none]

// Add matching rail wells to the underside of intersection legs.
intersection_both_sides = true;


// ===========================================================================
// CUSTOMIZER: MAIN TRACK DIMENSIONS
// ===========================================================================

/* [Main Track Dimensions] */

track_width = 40;                       // [20:0.1:80]
track_height = 12;                      // [4:0.1:30]

// Four long outside corners of the track body.
// This uses the native rotated-square 45-degree cutter convention.
body_chamfer = 1.5;                     // [0:0.05:5]

// Standard BRIO straight body length, excluding the plug.
straight_length = 145;                  // [20:0.1:400]


// ===========================================================================
// CUSTOMIZER: TRACK-END CHAMFER
// ===========================================================================

/* [Track End Chamfer] */

// Chamfers the complete exposed X/Z profile at each track end:
// body perimeter, well walls/floors, and the neck mouth of nest ends.
// This value follows the same 45-degree cutter-size convention as
// body_chamfer. Set to 0 to disable.
track_end_chamfer = 1.5;                // [0:0.05:5]


// ===========================================================================
// CUSTOMIZER: CURVE GEOMETRY
// ===========================================================================

/* [Curve Geometry] */

// Arc length measured along the track-body centerline.
curve_arc_length = 158.6504;            // [20:0.0001:400]

// Radius measured to the track-body centerline.
curve_centerline_radius = 202;          // [30:0.1:500]

curve_direction = "right";             // [left,right]


// ===========================================================================
// CUSTOMIZER: RAIL WELLS
// ===========================================================================

/* [Rail Wells] */

// The torwan source uses 2.9 mm. BRIO-compatible references commonly
// describe the nominal groove depth as 3.0 mm. V6 intentionally retains
// 2.9 mm until a physical calibration coupon is tested against genuine
// BRIO rolling stock and track.
track_well_depth = 2.9;                 // [0.5:0.05:8]
track_well_width_top = 6.75;            // [1:0.05:14]
track_well_width_bottom = 4.75;         // [1:0.05:14]

// Center-to-center spacing between the two rail wells.
track_well_spacing = 25.7;              // [10:0.05:35]


// ===========================================================================
// CUSTOMIZER: CONNECTOR PRESETS
// ===========================================================================

/* [Connector Presets] */

// Preset used for every plug end.
plug_system = "BRIO";                  // [BRIO,IKEA,Custom]

// Preset used for every nest end.
nest_system = "BRIO";                  // [BRIO,IKEA,Custom]


/* [Custom Plug Values] */

// Used only when plug_system = "Custom".
custom_plug_radius = 6.25;              // [2:0.01:12]
custom_plug_neck_width = 6.1;           // [2:0.01:14]
custom_plug_neck_length = 12;           // [3:0.05:25]


/* [Custom Nest Values] */

// Used only when nest_system = "Custom".
custom_nest_radius = 6.4;               // [2:0.01:12]
custom_nest_neck_width = 6.3;           // [2:0.01:14]
custom_nest_neck_length = 12;           // [3:0.05:25]


// ===========================================================================
// CUSTOMIZER: PLUG CHAMFERS
// ===========================================================================

/* [Plug Chamfers] */

// Angle of the circular plug-head chamfer, measured from the horizontal
// top/bottom face. 45 degrees matches the source generator.
plug_head_chamfer_angle = 45;           // [5:1:85]

// Vertical height of the plug-head chamfer at top and bottom.
plug_head_chamfer_height = 0.75;        // [0:0.05:3]

// Chamfers the four long edges of the rectangular plug neck.
// This is a native 45-degree corner chamfer using the same cutter-size
// convention as body_chamfer. Set to 0 for a square neck profile.
plug_neck_chamfer = 1.5;                // [0:0.05:4]


// ===========================================================================
// CUSTOMIZER: NEST CHAMFER
// ===========================================================================

/* [Nest Chamfer] */

// Angle of the circular nest-head flare, measured from the horizontal
// top/bottom face.
nest_chamfer_angle = 45;                // [5:1:85]

// Vertical height of the circular nest flare at top and bottom.
nest_chamfer_height = 0.75;             // [0:0.05:3]


// Chamfers the four long edges of the rectangular nest neck.
// Uses the same sizing convention as plug_neck_chamfer.
nest_neck_chamfer = 1.5;                // [0:0.05:4]


// ===========================================================================
// CUSTOMIZER: ADVANCED
// ===========================================================================

/* [Advanced] */

// Hidden overlap between connector necks and the track body. The larger V5
// default prevents the whole-profile track-end chamfer from opening a gap
// between the body and the plug neck.
connector_body_overlap = 1.25;          // [0.05:0.05:4]

// Tiny overlap used to avoid coincident-face artifacts.
epsilon = 0.01;

// BODY CONSTRUCTION NOTE:
// Straight and curved track bodies are solid material. RTG/XSTL does not
// subtract torwan's optional weight-saving core. The only normal voids are
// the rail wells and any selected nest-connector cavity.

// Print useful dimensions in the OpenSCAD console.
show_diagnostics = true;


// ===========================================================================
// PRESET DATA AND DERIVED VALUES
// ===========================================================================

/* [Hidden] */

// Connector arrays use: [head radius, neck width, neck length].
BRIO_PLUG = [6.25, 6.1, 12];
BRIO_NEST = [6.4,  6.3, 12];
IKEA_PLUG = [6.25, 6.1, 11];
IKEA_NEST = [6.4,  6.3, 11];

function choose_connector_dimensions(system, brio_values, ikea_values,
                                     custom_values) =
    system == "BRIO" ? brio_values :
    system == "IKEA" ? ikea_values :
    custom_values;

plug_dimensions = choose_connector_dimensions(
    plug_system,
    BRIO_PLUG,
    IKEA_PLUG,
    [custom_plug_radius, custom_plug_neck_width, custom_plug_neck_length]
);

nest_dimensions = choose_connector_dimensions(
    nest_system,
    BRIO_NEST,
    IKEA_NEST,
    [custom_nest_radius, custom_nest_neck_width, custom_nest_neck_length]
);

plug_radius = plug_dimensions[0];
plug_neck_width = plug_dimensions[1];
plug_neck_length = plug_dimensions[2];

nest_radius = nest_dimensions[0];
nest_neck_width = nest_dimensions[1];
nest_neck_length = nest_dimensions[2];

// Curve math: arc length = radius * angle_in_radians.
curve_angle = curve_arc_length / curve_centerline_radius * 180 / PI;
curve_inner_radius = curve_centerline_radius - track_width / 2;
curve_outer_radius = curve_centerline_radius + track_width / 2;

intersection_half_width = track_width / 2;

flexy_gap_count = flexy_oscillations + 1;
flexy_flex_region_length =
    flexy_oscillations * flexy_section_length
    + flexy_gap_count * flexy_gap_length;
flexy_body_length =
    flexy_start_block_length
    + flexy_flex_region_length
    + flexy_finish_block_length;

function connector_external_length(end_type) =
    end_type == "plug" ? plug_neck_length + plug_radius : 0;

function connector_required_body_length(end_type) =
    end_type == "nest"
        ? nest_neck_length + nest_radius + track_end_chamfer_run :
    end_type == "plug"
        ? connector_body_overlap + track_end_chamfer_run :
    track_end_chamfer_run;

flexy_connector_envelope_length =
    flexy_body_length
    + connector_external_length(flexy_start_end)
    + connector_external_length(flexy_finish_end);

flexy_outer_shoulder_width =
    (track_width - track_well_spacing - track_well_width_top) / 2;

well_side_extension =
    (track_well_width_top - track_well_width_bottom) / 2;

// A square of side S rotated 45 degrees cuts equal legs of S / sqrt(2).
track_end_chamfer_run = track_end_chamfer / sqrt(2);
body_chamfer_run = body_chamfer / sqrt(2);
plug_neck_chamfer_run = plug_neck_chamfer / sqrt(2);


// ===========================================================================
// SANITY CHECKS
// ===========================================================================

assert(preview_curve_fragments >= 3,
       "preview_curve_fragments must be at least 3");
assert(render_curve_fragments >= 3,
       "render_curve_fragments must be at least 3");
assert(track_type == "straight"
       || track_type == "curve"
       || track_type == "intersection"
       || track_type == "flexy_straight",
       "track_type must be straight, curve, intersection, or flexy_straight");
assert(track_width > 0, "track_width must be greater than zero");
assert(track_height > 0, "track_height must be greater than zero");
assert(body_chamfer >= 0, "body_chamfer cannot be negative");
assert(track_end_chamfer >= 0, "track_end_chamfer cannot be negative");
assert(plug_neck_chamfer >= 0, "plug_neck_chamfer cannot be negative");
assert(straight_length > 0, "straight_length must be greater than zero");
assert(flexy_start_end == "plug"
       || flexy_start_end == "nest"
       || flexy_start_end == "none",
       "flexy_start_end must be plug, nest, or none");
assert(flexy_finish_end == "plug"
       || flexy_finish_end == "nest"
       || flexy_finish_end == "none",
       "flexy_finish_end must be plug, nest, or none");
assert(flexy_start_block_length
       > connector_required_body_length(flexy_start_end),
       "flexy_start_block_length is too short for the selected start end");
assert(flexy_finish_block_length
       > connector_required_body_length(flexy_finish_end),
       "flexy_finish_block_length is too short for the selected finish end");
assert(flexy_oscillations >= 1
       && flexy_oscillations == floor(flexy_oscillations),
       "flexy_oscillations must be an integer of at least 1");
assert(flexy_section_length > 0,
       "flexy_section_length must be greater than zero");
assert(flexy_gap_length > 0,
       "flexy_gap_length must be greater than zero");
assert(flexy_bridge_width > 0 && flexy_bridge_width < track_width,
       "flexy_bridge_width must be greater than zero and less than track_width");
assert(flexy_gap_bridge_phase == "right_first"
       || flexy_gap_bridge_phase == "left_first",
       "flexy_gap_bridge_phase must be right_first or left_first");
assert(intersection_angle > 0 && intersection_angle < 180,
       "intersection_angle must be between 0 and 180 degrees");
assert(intersection_length_a > track_width,
       "intersection_length_a must be greater than track_width");
assert(intersection_length_b > track_width,
       "intersection_length_b must be greater than track_width");
assert(intersection_end1_a == "plug"
       || intersection_end1_a == "nest"
       || intersection_end1_a == "none",
       "intersection_end1_a must be plug, nest, or none");
assert(intersection_end2_a == "plug"
       || intersection_end2_a == "nest"
       || intersection_end2_a == "none",
       "intersection_end2_a must be plug, nest, or none");
assert(intersection_end1_b == "plug"
       || intersection_end1_b == "nest"
       || intersection_end1_b == "none",
       "intersection_end1_b must be plug, nest, or none");
assert(intersection_end2_b == "plug"
       || intersection_end2_b == "nest"
       || intersection_end2_b == "none",
       "intersection_end2_b must be plug, nest, or none");
assert(curve_centerline_radius > track_width / 2,
       "curve_centerline_radius must exceed half the track width");
assert(curve_arc_length > 0, "curve_arc_length must be greater than zero");
assert(track_well_depth > 0 && track_well_depth < track_height,
       "track_well_depth must be between zero and track_height");
assert(track_well_width_top > 0 && track_well_width_bottom > 0,
       "track well widths must be greater than zero");
assert(track_well_spacing > track_well_width_top,
       "track_well_spacing should exceed track_well_width_top");
assert(plug_radius > 0 && nest_radius > 0,
       "connector radii must be greater than zero");
assert(plug_neck_width > 0 && nest_neck_width > 0,
       "connector neck widths must be greater than zero");
assert(plug_neck_length > 0 && nest_neck_length > 0,
       "connector neck lengths must be greater than zero");
assert(connector_body_overlap > 0,
       "connector_body_overlap must be greater than zero");
assert(plug_neck_chamfer_run < min(plug_neck_width, track_height) / 2,
       "plug_neck_chamfer is too large for the plug neck cross-section");


// ===========================================================================
// GENERIC 2D PROFILE AND CHAMFER HELPERS
// ===========================================================================

// One native 45-degree corner cutter. The value is the side length of the
// square before rotation; its effective cut leg is size / sqrt(2).
module corner_chamfer_cutter_2d(size) {
    if (size > 0)
        rotate(45)
            square(size, center = true);
}


// Rectangle with the same chamfer treatment available at all four corners.
// This is used for both the track-body outline and the plug-neck profile.
module chamfered_rectangle_2d(width, height, chamfer_size = 0) {
    difference() {
        square([width, height]);

        if (chamfer_size > 0) {
            for (x = [0, width]) {
                for (z = [0, height]) {
                    translate([x, z])
                        corner_chamfer_cutter_2d(chamfer_size);
                }
            }
        }
    }
}


// Extrude a child X/Z profile between two Y coordinates.
// The 2D child's first coordinate becomes X and second coordinate becomes Z.
module extrude_xz_profile_between_y(y_min, y_max, convexity = 10) {
    assert(y_max > y_min, "y_max must be greater than y_min");

    translate([0, y_max, 0])
        rotate([90, 0, 0])
            linear_extrude(height = y_max - y_min, convexity = convexity)
                children();
}


// ===========================================================================
// TRACK CROSS-SECTION
// ===========================================================================

// Trapezoidal rail-well cutter. Local origin is centered on the well floor.
module rail_well_cutter_2d() {
    translate([-track_well_width_bottom / 2, 0])
        polygon([
            [0, 0],
            [track_well_width_bottom, 0],
            [track_well_width_bottom + well_side_extension,
             track_well_depth],
            [-well_side_extension, track_well_depth]
        ]);
}


module track_body_outline_2d() {
    chamfered_rectangle_2d(
        track_width,
        track_height,
        body_chamfer
    );
}


module top_track_well_cutters_2d() {
    for (x_offset = [-track_well_spacing / 2,
                      track_well_spacing / 2]) {
        translate([
            track_width / 2 + x_offset,
            track_height - track_well_depth + epsilon
        ])
            rail_well_cutter_2d();
    }
}


module bottom_track_well_cutters_2d() {
    for (x_offset = [-track_well_spacing / 2,
                      track_well_spacing / 2]) {
        translate([
            track_width / 2 + x_offset,
            track_well_depth - epsilon
        ])
            rotate(180)
                rail_well_cutter_2d();
    }
}


module track_well_cutters_2d(include_bottom_wells = two_sided) {
    top_track_well_cutters_2d();

    if (include_bottom_wells)
        bottom_track_well_cutters_2d();
}


// Complete track-material profile in X/Z. The profile is centered on X =
// center_x, sits on Z = 0, and includes body chamfers and optional wells.
module track_profile_2d(
    center_x = 0,
    include_rail_wells = true,
    include_bottom_wells = two_sided
) {
    translate([center_x - track_width / 2, 0])
        difference() {
            track_body_outline_2d();

            if (include_rail_wells)
                track_well_cutters_2d(include_bottom_wells);
        }
}


// ===========================================================================
// CONNECTOR MATH AND COMMON PROFILES
// ===========================================================================

function clamped_angle(angle) = min(89.9, max(0.1, angle));

function connector_chamfer_run(height, angle) =
    height <= 0 ? 0 : height / tan(clamped_angle(angle));


// Chamfered rectangular X/Z profile used by the plug neck.
module plug_neck_profile_2d() {
    translate([-plug_neck_width / 2, 0])
        chamfered_rectangle_2d(
            plug_neck_width,
            track_height,
            plug_neck_chamfer
        );
}


// ===========================================================================
// PLUG CONNECTOR
// ===========================================================================

// Circular plug head. Its top and bottom chamfers are generated by revolving
// a 2D radial profile around the Z axis.
module plug_head_3d(radius = plug_radius) {
    chamfer_h = min(
        max(0, plug_head_chamfer_height),
        track_height / 2 - epsilon
    );

    requested_run = connector_chamfer_run(
        chamfer_h,
        plug_head_chamfer_angle
    );

    chamfer_run = min(requested_run, radius - epsilon);

    if (chamfer_h <= 0 || chamfer_run <= 0) {
        cylinder(r = radius, h = track_height);
    } else {
        rotate_extrude(angle = 360, convexity = 10)
            polygon([
                [0, 0],
                [radius - chamfer_run, 0],
                [radius, chamfer_h],
                [radius, track_height - chamfer_h],
                [radius - chamfer_run, track_height],
                [0, track_height]
            ]);
    }
}


// Rectangular plug neck. V6 extrudes a chamfered X/Z profile rather than a
// plain cube, giving the neck four chamfered long edges. The hidden negative-Y
// portion overlaps the track body and prevents a seam after end chamfering.
module plug_neck_3d() {
    extrude_xz_profile_between_y(
        -connector_body_overlap,
        plug_neck_length
    )
        plug_neck_profile_2d();
}


module plug_connector_local_3d() {
    union() {
        plug_neck_3d();

        translate([0, plug_neck_length, 0])
            plug_head_3d(plug_radius);
    }
}


// ===========================================================================
// NEST CONNECTOR CUTTER
// ===========================================================================

// Circular nest-head cutter. Its top and bottom edges flare outward.
module nest_head_cutter_3d(radius = nest_radius) {
    chamfer_h = min(
        max(0, nest_chamfer_height),
        track_height / 2 - epsilon
    );

    chamfer_run = connector_chamfer_run(
        chamfer_h,
        nest_chamfer_angle
    );

    if (chamfer_h <= 0 || chamfer_run <= 0) {
        translate([0, 0, -epsilon])
            cylinder(r = radius, h = track_height + 2 * epsilon);
    } else {
        rotate_extrude(angle = 360, convexity = 10)
            polygon([
                [0, -epsilon],
                [radius + chamfer_run, -epsilon],
                [radius, chamfer_h],
                [radius, track_height - chamfer_h],
                [radius + chamfer_run, track_height + epsilon],
                [0, track_height + epsilon]
            ]);
    }
}


// X/Z cross-section of the rectangular nest-neck cutter.
//
// Because a nest is made by SUBTRACTING this shape, its profile must widen
// near the top and bottom surfaces. That removes extra material and creates
// the four long chamfered edges around the neck.
module nest_neck_cutter_profile_2d() {
    run = min(
        nest_neck_chamfer / sqrt(2),
        track_height / 2 - epsilon
    );

    if (nest_neck_chamfer <= 0 || run <= 0) {
        // Plain rectangular neck when chamfering is disabled.
        translate([
            -nest_neck_width / 2,
            -epsilon
        ])
            square([
                nest_neck_width,
                track_height + 2 * epsilon
            ]);
    } else {
        polygon([
            // Bottom edge, widened outward.
            [-nest_neck_width / 2 - run, -epsilon],
            [ nest_neck_width / 2 + run, -epsilon],

            // Nominal-width sidewalls.
            [ nest_neck_width / 2, run],
            [ nest_neck_width / 2, track_height - run],

            // Top edge, widened outward.
            [ nest_neck_width / 2 + run, track_height + epsilon],
            [-nest_neck_width / 2 - run, track_height + epsilon],

            // Back down the left wall.
            [-nest_neck_width / 2, track_height - run],
            [-nest_neck_width / 2, run]
        ]);
    }
}


module nest_neck_cutter_3d() {
    extrude_xz_profile_between_y(
        -connector_body_overlap,
        nest_neck_length
    )
        nest_neck_cutter_profile_2d();
}


// Four-sided flare at the exposed nest mouth. It widens the rectangular
// neck opening at Y = 0, then returns to nominal size one chamfer run inward.
module nest_mouth_end_chamfer_cutter_local() {
    run = track_end_chamfer_run;

    if (track_end_chamfer > 0 && run > 0) {
        hull() {
            translate([
                -nest_neck_width / 2 - run,
                -epsilon,
                -run
            ])
                cube([
                    nest_neck_width + 2 * run,
                    2 * epsilon,
                    track_height + 2 * run
                ]);

            translate([
                -nest_neck_width / 2,
                run - epsilon,
                0
            ])
                cube([
                    nest_neck_width,
                    2 * epsilon,
                    track_height
                ]);
        }
    }
}


module nest_connector_cutter_local_3d() {
    union() {
        nest_neck_cutter_3d();

        translate([0, nest_neck_length, 0])
            nest_head_cutter_3d(nest_radius);

        nest_mouth_end_chamfer_cutter_local();
    }
}


// ===========================================================================
// CONNECTOR PLACEMENT
// ===========================================================================

module add_end_connector(end_type, position = [0, 0, 0], rotation = 0) {
    if (end_type == "plug") {
        translate(position)
            rotate([0, 0, rotation])
                plug_connector_local_3d();
    }
}


module cut_end_connector(end_type, position = [0, 0, 0], rotation = 0) {
    if (end_type == "nest") {
        translate(position)
            rotate([0, 0, rotation])
                nest_connector_cutter_local_3d();
    }
}


// ===========================================================================
// WHOLE-PROFILE TRACK-END CHAMFER
// ===========================================================================

// A very thin copy of the X/Z material profile at local Y. Local +Y points
// inward from the exposed end face.
module track_profile_slice_local(
    y_position = 0,
    erode = 0,
    include_rail_wells = true,
    include_bottom_wells = two_sided
) {
    translate([0, y_position + epsilon, 0])
        rotate([90, 0, 0])
            linear_extrude(height = 2 * epsilon, convexity = 10)
                if (erode > 0)
                    offset(delta = -erode)
                        track_profile_2d(
                            0,
                            include_rail_wells,
                            include_bottom_wells
                        );
                else
                    track_profile_2d(
                        0,
                        include_rail_wells,
                        include_bottom_wells
                    );
}


// At the exposed face, the entire material profile is inset by one chamfer
// run. A hull transitions to the full profile one run inside the body.
module whole_end_chamfer_keep_mask_local(
    include_rail_wells = true,
    include_bottom_wells = two_sided
) {
    run = track_end_chamfer_run;
    big = 4 * (
        curve_centerline_radius +
        curve_arc_length +
        straight_length +
        flexy_body_length +
        track_width +
        100
    );

    if (track_end_chamfer <= 0 || run <= 0) {
        translate([-big / 2, -epsilon, -big / 2])
            cube([big, big, big]);
    } else {
        union() {
            hull() {
                track_profile_slice_local(
                    0,
                    run,
                    include_rail_wells,
                    include_bottom_wells
                );
                track_profile_slice_local(
                    run,
                    0,
                    include_rail_wells,
                    include_bottom_wells
                );
            }

            translate([-big / 2, run, -big / 2])
                cube([big, big, big]);
        }
    }
}


module place_whole_end_chamfer_keep_mask(
    position = [0, 0, 0],
    inward_heading = 0,
    include_rail_wells = true,
    include_bottom_wells = two_sided
) {
    translate(position)
        rotate([0, 0, inward_heading])
            whole_end_chamfer_keep_mask_local(
                include_rail_wells,
                include_bottom_wells
            );
}


// ===========================================================================
// STRAIGHT TRACK
// ===========================================================================

module straight_body_raw(
    length = straight_length,
    include_rail_wells = true,
    include_bottom_wells = two_sided
) {
    extrude_xz_profile_between_y(0, length)
        track_profile_2d(
            0,
            include_rail_wells,
            include_bottom_wells
        );
}


module straight_body(
    length = straight_length,
    include_rail_wells = true,
    include_bottom_wells = two_sided
) {
    intersection() {
        straight_body_raw(
            length,
            include_rail_wells,
            include_bottom_wells
        );

        // Start end: inward is +Y.
        place_whole_end_chamfer_keep_mask(
            [0, 0, 0],
            0,
            include_rail_wells,
            include_bottom_wells
        );

        // Finish end: inward is -Y.
        place_whole_end_chamfer_keep_mask(
            [0, length, 0],
            180,
            include_rail_wells,
            include_bottom_wells
        );
    }
}


module straight_track_length(
    length = straight_length,
    start_connector = start_end,
    finish_connector = finish_end,
    include_rail_wells = true,
    include_bottom_wells = two_sided
) {
    difference() {
        union() {
            straight_body(
                length,
                include_rail_wells,
                include_bottom_wells
            );

            // Start plug points outward toward -Y.
            add_end_connector(start_connector, [0, 0, 0], 180);

            // Finish plug points outward toward +Y.
            add_end_connector(
                finish_connector,
                [0, length, 0],
                0
            );
        }

        // Start nest cutter points inward toward +Y.
        cut_end_connector(start_connector, [0, 0, 0], 0);

        // Finish nest cutter points inward toward -Y.
        cut_end_connector(
            finish_connector,
            [0, length, 0],
            180
        );
    }
}


module straight_track() {
    straight_track_length(
        straight_length,
        start_end,
        finish_end,
        true,
        two_sided
    );
}


// ===========================================================================
// FLEXY STRAIGHT TRACK
// ===========================================================================

function flexy_gap_bridge_on_right(gap_index) =
    flexy_gap_bridge_phase == "right_first"
        ? gap_index % 2 == 0
        : gap_index % 2 == 1;

function flexy_gap_start_y(gap_index) =
    flexy_start_block_length
    + gap_index * (flexy_section_length + flexy_gap_length);


module flexy_relief_gap_cutter(
    gap_start_y = flexy_start_block_length,
    bridge_on_right = true
) {
    x_min = bridge_on_right
        ? -track_width / 2 - epsilon
        : -track_width / 2 + flexy_bridge_width;

    translate([x_min, gap_start_y - epsilon, -epsilon])
        cube([
            track_width - flexy_bridge_width + 2 * epsilon,
            flexy_gap_length + 2 * epsilon,
            track_height + 2 * epsilon
        ]);
}


module flexy_relief_gap_cutters() {
    for (gap_index = [0 : flexy_gap_count - 1]) {
        flexy_relief_gap_cutter(
            flexy_gap_start_y(gap_index),
            flexy_gap_bridge_on_right(gap_index)
        );
    }
}


module flexy_straight_track() {
    difference() {
        straight_track_length(
            flexy_body_length,
            flexy_start_end,
            flexy_finish_end,
            true,
            two_sided
        );

        flexy_relief_gap_cutters();
    }
}


// ===========================================================================
// CURVED TRACK
// ===========================================================================

module left_curve_body_raw() {
    // At angle zero, the centerline begins at the origin and heads along +Y.
    translate([-curve_centerline_radius, 0, 0])
        rotate_extrude(angle = curve_angle, convexity = 10)
            track_profile_2d(curve_centerline_radius);
}


module curved_body_raw(direction = "right") {
    if (direction == "left") {
        left_curve_body_raw();
    } else {
        mirror([1, 0, 0])
            left_curve_body_raw();
    }
}


function curve_end_x(direction) =
    direction == "left"
        ? -curve_centerline_radius * (1 - cos(curve_angle))
        :  curve_centerline_radius * (1 - cos(curve_angle));

function curve_end_y() =
    curve_centerline_radius * sin(curve_angle);

// Forward path tangent at the far end, measured from +Y.
function curve_end_heading(direction) =
    direction == "left" ? curve_angle : -curve_angle;

function curve_end_position(direction) =
    [curve_end_x(direction), curve_end_y(), 0];


module curved_body(direction = "right") {
    end_position = curve_end_position(direction);
    end_heading = curve_end_heading(direction);

    intersection() {
        curved_body_raw(direction);

        // Start end: inward follows the initial +Y tangent.
        place_whole_end_chamfer_keep_mask([0, 0, 0], 0);

        // Finish end: inward points opposite the forward tangent.
        place_whole_end_chamfer_keep_mask(
            end_position,
            end_heading + 180
        );
    }
}


module curved_track(direction = "right") {
    end_position = curve_end_position(direction);
    end_heading = curve_end_heading(direction);

    difference() {
        union() {
            curved_body(direction);

            // Start plug points opposite the initial +Y tangent.
            add_end_connector(start_end, [0, 0, 0], 180);

            // Finish plug follows the final forward tangent.
            add_end_connector(finish_end, end_position, end_heading);
        }

        // Start nest cutter follows the initial inward tangent.
        cut_end_connector(start_end, [0, 0, 0], 0);

        // Finish nest cutter points opposite the final forward tangent.
        cut_end_connector(
            finish_end,
            end_position,
            end_heading + 180
        );
    }
}


// ===========================================================================
// INTERSECTION TRACK
// ===========================================================================

// XSTL keeps the core module name distinct from OpenSCAD's built-in CSG
// intersection() operation. A small compatibility wrapper can expose the
// original train_tracks_generator.scad call style when this file is loaded
// with use <xstl_v8.scad>.

function path_direction_from_heading(heading) =
    [-sin(heading), cos(heading), 0];

function centered_leg_start_position(length, heading) =
    -path_direction_from_heading(heading) * length / 2;


module place_centered_straight_leg(length, heading) {
    translate(centered_leg_start_position(length, heading))
        rotate([0, 0, heading])
            children();
}


module centered_track_well_cutters_2d(include_bottom_wells = two_sided) {
    translate([-track_width / 2, 0])
        track_well_cutters_2d(include_bottom_wells);
}


module straight_rail_well_cutters_3d(
    length = straight_length,
    include_bottom_wells = two_sided
) {
    extrude_xz_profile_between_y(-epsilon, length + epsilon)
        centered_track_well_cutters_2d(include_bottom_wells);
}


module centered_intersection_leg_body(
    length = straight_length,
    heading = 0,
    end1 = "plug",
    end2 = "nest"
) {
    place_centered_straight_leg(length, heading)
        straight_track_length(
            length,
            end1,
            end2,
            false,
            false
        );
}


module centered_intersection_leg_wells(
    length = straight_length,
    heading = 0,
    both_sides = true
) {
    place_centered_straight_leg(length, heading)
        straight_rail_well_cutters_3d(length, both_sides);
}


module track_intersection(
    angle = 90,
    lengthA = 80,
    lengthB = 80,
    end1A = "nest",
    end2A = "plug",
    end1B = "nest",
    end2B = "plug",
    both_sides = true
) {
    leg_a_heading = -90;
    leg_b_heading = angle - 90;

    difference() {
        union() {
            centered_intersection_leg_body(
                lengthA,
                leg_a_heading,
                end1A,
                end2A
            );
            centered_intersection_leg_body(
                lengthB,
                leg_b_heading,
                end1B,
                end2B
            );
        }

        centered_intersection_leg_wells(
            lengthA,
            leg_a_heading,
            both_sides
        );
        centered_intersection_leg_wells(
            lengthB,
            leg_b_heading,
            both_sides
        );
    }
}


// ===========================================================================
// GENERATE SELECTED MODEL
// ===========================================================================

if (track_type == "straight") {
    straight_track();
} else if (track_type == "curve") {
    curved_track(curve_direction);
} else if (track_type == "intersection") {
    track_intersection(
        angle = intersection_angle,
        lengthA = intersection_length_a,
        lengthB = intersection_length_b,
        end1A = intersection_end1_a,
        end2A = intersection_end2_a,
        end1B = intersection_end1_b,
        end2B = intersection_end2_b,
        both_sides = intersection_both_sides
    );
} else if (track_type == "flexy_straight") {
    flexy_straight_track();
}


// ===========================================================================
// CONSOLE DIAGNOSTICS
// ===========================================================================

if (show_diagnostics) {
    echo("XSTL version:", "V8");
    echo("Track type:", track_type);
    echo("Preview / render curve fragments:",
         preview_curve_fragments, render_curve_fragments);
    echo("Body construction:",
         "solid; no weight-saving core cutout");
    echo("Curve centerline radius (mm):", curve_centerline_radius);
    echo("Curve centerline arc length (mm):", curve_arc_length);
    echo("Calculated curve angle (degrees):", curve_angle);
    echo("Curve inner body radius (mm):", curve_inner_radius);
    echo("Curve outer body radius (mm):", curve_outer_radius);
    echo("Rail-well center spacing (mm):", track_well_spacing);
    echo("Rail-well top / bottom width (mm):",
         track_well_width_top, track_well_width_bottom);
    echo("Body chamfer setting / effective run (mm):",
         body_chamfer, body_chamfer_run);
    echo("Track-end chamfer setting / effective run (mm):",
         track_end_chamfer, track_end_chamfer_run);
    echo("Connector body overlap (mm):", connector_body_overlap);
    if (track_type == "flexy_straight") {
        echo("Flexy start / finish ends:",
             flexy_start_end, flexy_finish_end);
        echo("Flexy start / finish solid block lengths (mm):",
             flexy_start_block_length, flexy_finish_block_length);
        echo("Flexy oscillations:", flexy_oscillations);
        echo("Flexy section length / gap length / gap count (mm):",
             flexy_section_length, flexy_gap_length, flexy_gap_count);
        echo("Flexy bridge width / first bridge side:",
             flexy_bridge_width, flexy_gap_bridge_phase);
        echo("Flexy outer shoulder width before rail well (mm):",
             flexy_outer_shoulder_width);
        echo("Flexy flexible region length (mm):",
             flexy_flex_region_length);
        echo("Flexy resulting body length, excluding plug extension (mm):",
             flexy_body_length);
        echo("Flexy connector envelope length, including plug extension (mm):",
             flexy_connector_envelope_length);
    }
    if (track_type == "intersection") {
        echo("Intersection angle (degrees):", intersection_angle);
        echo("Intersection leg A / B body lengths (mm):",
             intersection_length_a, intersection_length_b);
        echo("Intersection leg A ends:",
             intersection_end1_a, intersection_end2_a);
        echo("Intersection leg B ends:",
             intersection_end1_b, intersection_end2_b);
        echo("Intersection rail wells on both sides:",
             intersection_both_sides);
    }
    echo("Plug preset:", plug_system);
    echo("Plug radius / neck width / neck length (mm):",
         plug_radius, plug_neck_width, plug_neck_length);
    echo("Plug-head chamfer angle / height / run:",
         plug_head_chamfer_angle,
         plug_head_chamfer_height,
         connector_chamfer_run(
             plug_head_chamfer_height,
             plug_head_chamfer_angle
         ));
    echo("Plug-neck chamfer setting / effective run (mm):",
         plug_neck_chamfer, plug_neck_chamfer_run);
    echo("Nest preset:", nest_system);
    echo("Nest radius / neck width / neck length (mm):",
         nest_radius, nest_neck_width, nest_neck_length);
    echo("Nest chamfer angle / height / run:",
         nest_chamfer_angle,
         nest_chamfer_height,
         connector_chamfer_run(
             nest_chamfer_height,
             nest_chamfer_angle
         ));
}
