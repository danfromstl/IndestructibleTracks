/*
    XSTL V10 Refresh
    Wooden-railway-compatible straight, curve, intersection, and flexy track.

    Coordinates: X across the track, Y forward, Z up.
    Curve radius and arc length are measured on the track-body centerline.

    V10 targets current OpenSCAD nightly builds with the Manifold backend.
    It carries the V9R3 architecture while simplifying the Customizer,
    preview routing, diagnostics, and repeated rail-well helpers.

    Current flexy defaults are calibrated to the reverse-engineered SF200
    reference STL named "Adapted Original - SF200.stl".
*/

// ---------------------------------------------------------------------------
// CUSTOMIZER
// ---------------------------------------------------------------------------

/* [1 - Build This Piece] */

// Model to generate.
track_type = "flexy_straight"; // [straight:Straight,curve:Curve,intersection:Intersection,flexy_straight:Flexy Straight]

// Add a matching pair of rail wells to the underside.
two_sided = false;

// Used by straight and curve tracks.
start_end = "plug";  // [plug:Plug,nest:Nest,none:None]
finish_end = "nest"; // [plug:Plug,nest:Nest,none:None]


/* [2 - Flexy Straight] */

flexy_start_end = "plug";  // [plug:Plug,nest:Nest,none:None]
flexy_finish_end = "nest"; // [plug:Plug,nest:Nest,none:None]

// Solid body beside the start and finish connectors.
flexy_start_block_length = 11.5249;  // [5:0.01:80]
flexy_finish_block_length = 23.2742; // [5:0.01:80]

// Repeated solid sections; gap count is oscillations + 1.
flexy_oscillations = 41; // [1:1:80]

// Solid-section length and relief-gap width along the track axis.
flexy_section_length = 3.00; // [1:0.01:20]
flexy_gap_length = 1.00;     // [0.4:0.01:8]

// Uncut side bridge left across each alternating relief gap.
flexy_bridge_width = 13.50; // [1:0.01:18]
flexy_gap_bridge_phase = "left_first"; // [right_first:Right first,left_first:Left first]

// Closed end shape for each alternating side cutout.
flexy_relief_gap_end_style = "rounded"; // [rounded:Rounded,rectangular:Rectangular]

// Semicircle facets at each rounded relief-gap end.
flexy_relief_arc_segments = 18; // [6:1:48]


/* [3 - Straight] */

// Body length, excluding any plug extension.
straight_length = 145; // [20:0.1:400]


/* [4 - Curve] */

curve_direction = "right"; // [left:Left,right:Right]

// Radius measured to the track-body centerline.
curve_centerline_radius = 202; // [30:0.1:500]

// Arc length measured along the track-body centerline.
curve_arc_length = 158.6504; // [20:0.0001:400]


/* [5 - Intersection] */

// Centerline angle between legs A and B.
intersection_angle = 45; // [15:0.1:165]

// Leg body lengths, excluding plug extensions.
intersection_length_a = 152; // [40:0.1:400]
intersection_length_b = 152; // [40:0.1:400]

intersection_end1_a = "plug"; // [plug:Plug,nest:Nest,none:None]
intersection_end2_a = "nest"; // [plug:Plug,nest:Nest,none:None]
intersection_end1_b = "nest"; // [plug:Plug,nest:Nest,none:None]
intersection_end2_b = "plug"; // [plug:Plug,nest:Nest,none:None]

// Add matching underside wells to both intersection legs.
intersection_both_sides = true;


/* [6 - Track Profile] */

track_width = 40;  // [20:0.1:80]
track_height = 12; // [4:0.1:30]

// Four long body corners; 0 disables the chamfer.
body_chamfer = 1.41421356237; // [0:0.01:5]

// Complete exposed track-end profile; 0 disables the chamfer.
track_end_chamfer = 1.41421356237; // [0:0.01:5]


/* [7 - Rail Wells] */

track_well_depth = 3.00;       // [0.5:0.01:8]
track_well_width_top = 7.00;   // [1:0.01:14]
track_well_width_bottom = 5.00; // [1:0.01:14]

// Center-to-center spacing between the two wells.
track_well_spacing = 25.00; // [10:0.01:35]

// Flexy SF200 reference uses the sharp trapezoidal rail wells.
flexy_rail_well_style = "sharp"; // [sharp:Sharp,chamfered:Chamfered]


/* [8 - Connector Presets] */

plug_system = "Custom"; // [BRIO,IKEA,Custom]
nest_system = "Custom"; // [BRIO,IKEA,Custom]


/* [9 - Connector Finish] */

// Circular plug-head chamfer: angle from the horizontal and vertical height.
plug_head_chamfer_angle = 45;    // [5:1:85]
plug_head_chamfer_height = 1.00; // [0:0.01:3]

// Four long edges of the plug neck; 0 disables the chamfer.
plug_neck_chamfer = 1.41421356237; // [0:0.01:4]

// Circular nest flare: angle from the horizontal and vertical height.
nest_chamfer_angle = 45;    // [5:1:85]
nest_chamfer_height = 1.00; // [0:0.01:3]

// Four long edges of the nest neck; 0 disables the chamfer.
nest_neck_chamfer = 1.41421356237; // [0:0.01:4]


/* [10 - Custom Connector Fit] */

// Used only when the matching connector preset is Custom.
custom_plug_radius = 6.125;     // [2:0.001:12]
custom_plug_neck_width = 6.75;  // [2:0.001:14]
custom_plug_neck_length = 12.10; // [3:0.001:25]
custom_nest_radius = 6.375;     // [2:0.001:12]
custom_nest_neck_width = 7.25;  // [2:0.001:14]
custom_nest_neck_length = 11.90; // [3:0.001:25]


/* [11 - Preview and Output] */

// Circular facets for F5 preview and F6/export.
preview_curve_fragments = 53; // [24:1:240]
render_curve_fragments = 53; // [24:1:480]

// Resolve F5 to a real low-resolution mesh. Recommended with Manifold.
// Disable only to inspect the raw OpenCSG preview tree.
resolved_preview = true;

// Console output. Summary prints two useful lines; Full prints calibration data.
console_report = "summary"; // [off:Off,summary:Summary,full:Full]


/* [12 - Advanced] */

// Hidden connector/body overlap that prevents seams after end chamfering.
connector_body_overlap = 1.25; // [0.05:0.05:4]


/* [Hidden] */

// Tiny overlap used only to avoid coincident faces.
epsilon = 0.01;

// Set to epsilon to restore the older V10 behavior where relief-gap cutters
// extend slightly past their nominal Y walls.
flexy_gap_y_overcut = 0;

// Set to epsilon to restore the older V10 rail-well cutter placement.
rail_well_surface_clearance = 0;

// Adds the measured SF200 lead-in/out chamfer to top rail wells.
rail_well_end_chamfers = true;

$fn = $preview ? preview_curve_fragments : render_curve_fragments;


// ---------------------------------------------------------------------------
// PRESETS AND DERIVED VALUES
// ---------------------------------------------------------------------------

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

flexy_gap_count = flexy_oscillations + 1;
flexy_flex_region_length =
    flexy_oscillations * flexy_section_length
    + flexy_gap_count * flexy_gap_length;
flexy_body_length =
    flexy_start_block_length
    + flexy_flex_region_length
    + flexy_finish_block_length;

// A square of side S rotated 45 degrees cuts equal legs of S / sqrt(2).
track_end_chamfer_run = track_end_chamfer / sqrt(2);
body_chamfer_run = body_chamfer / sqrt(2);
plug_neck_chamfer_run = plug_neck_chamfer / sqrt(2);
flexy_inner_corner_chamfer_run =
    min(body_chamfer_run, flexy_gap_length / 2);
flexy_well_chamfer_run = max(0, min(
    min(body_chamfer_run, track_well_depth / 2 - epsilon),
    track_well_width_bottom / 2 - epsilon
));
flexy_relief_edge_chamfer_run = max(0, min(
    min(body_chamfer_run, flexy_gap_length / 2),
    track_height / 2 - epsilon
));

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

// ---------------------------------------------------------------------------
// SANITY CHECKS
// ---------------------------------------------------------------------------

function valid_end(value) =
    value == "plug" || value == "nest" || value == "none";

function valid_system(value) =
    value == "BRIO" || value == "IKEA" || value == "Custom";

assert(preview_curve_fragments >= 3 && render_curve_fragments >= 3,
       "preview/render fragments must each be at least 3");
assert(console_report == "off"
       || console_report == "summary"
       || console_report == "full",
       "console_report must be off, summary, or full");
assert(track_type == "straight" || track_type == "curve"
       || track_type == "intersection" || track_type == "flexy_straight",
       "track_type must be straight, curve, intersection, or flexy_straight");
assert(valid_end(start_end) && valid_end(finish_end),
       "start_end and finish_end must be plug, nest, or none");
assert(track_width > 0, "track_width must be greater than zero");
assert(track_height > 0, "track_height must be greater than zero");
assert(body_chamfer >= 0, "body_chamfer cannot be negative");
assert(track_end_chamfer >= 0, "track_end_chamfer cannot be negative");
assert(plug_neck_chamfer >= 0, "plug_neck_chamfer cannot be negative");
assert(straight_length > 0, "straight_length must be greater than zero");
assert(valid_end(flexy_start_end) && valid_end(flexy_finish_end),
       "flexy ends must be plug, nest, or none");
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
assert(flexy_gap_y_overcut >= 0,
       "flexy_gap_y_overcut cannot be negative");
assert(flexy_bridge_width > 0 && flexy_bridge_width < track_width,
       "flexy_bridge_width must be greater than zero and less than track_width");
assert(body_chamfer <= 0
       || flexy_section_length > 2 * body_chamfer_run,
       "flexy_section_length is too short for relief-gap chamfers");
assert(body_chamfer <= 0
       || flexy_bridge_width > 2 * body_chamfer_run,
       "flexy_bridge_width is too narrow for relief-gap chamfers");
assert(body_chamfer <= 0
       || track_width - flexy_bridge_width > 2 * body_chamfer_run,
       "flexy relief cut width is too narrow for relief-gap chamfers");
assert(flexy_gap_bridge_phase == "right_first"
       || flexy_gap_bridge_phase == "left_first",
       "flexy_gap_bridge_phase must be right_first or left_first");
assert(flexy_relief_gap_end_style == "rounded"
       || flexy_relief_gap_end_style == "rectangular",
       "flexy_relief_gap_end_style must be rounded or rectangular");
assert(flexy_relief_arc_segments >= 3
       && flexy_relief_arc_segments == floor(flexy_relief_arc_segments),
       "flexy_relief_arc_segments must be an integer of at least 3");
assert(intersection_angle > 0 && intersection_angle < 180,
       "intersection_angle must be between 0 and 180 degrees");
assert(intersection_length_a > track_width,
       "intersection_length_a must be greater than track_width");
assert(intersection_length_b > track_width,
       "intersection_length_b must be greater than track_width");
assert(valid_end(intersection_end1_a) && valid_end(intersection_end2_a)
       && valid_end(intersection_end1_b) && valid_end(intersection_end2_b),
       "all intersection ends must be plug, nest, or none");
assert(curve_direction == "left" || curve_direction == "right",
       "curve_direction must be left or right");
assert(curve_centerline_radius > track_width / 2,
       "curve_centerline_radius must exceed half the track width");
assert(curve_arc_length > 0, "curve_arc_length must be greater than zero");
assert(track_well_depth > 0 && track_well_depth < track_height,
       "track_well_depth must be between zero and track_height");
assert(track_well_width_top > 0 && track_well_width_bottom > 0,
       "track well widths must be greater than zero");
assert(track_well_spacing > track_well_width_top,
       "track_well_spacing should exceed track_well_width_top");
assert(flexy_rail_well_style == "sharp"
       || flexy_rail_well_style == "chamfered",
       "flexy_rail_well_style must be sharp or chamfered");
assert(rail_well_surface_clearance >= 0,
       "rail_well_surface_clearance cannot be negative");
assert(rail_well_end_chamfers == true || rail_well_end_chamfers == false,
       "rail_well_end_chamfers must be true or false");
assert(plug_radius > 0 && nest_radius > 0,
       "connector radii must be greater than zero");
assert(plug_neck_width > 0 && nest_neck_width > 0,
       "connector neck widths must be greater than zero");
assert(plug_neck_length > 0 && nest_neck_length > 0,
       "connector neck lengths must be greater than zero");
assert(valid_system(plug_system) && valid_system(nest_system),
       "connector presets must be BRIO, IKEA, or Custom");
assert(connector_body_overlap > 0,
       "connector_body_overlap must be greater than zero");
assert(plug_neck_chamfer_run < min(plug_neck_width, track_height) / 2,
       "plug_neck_chamfer is too large for the plug neck cross-section");


// ---------------------------------------------------------------------------
// GENERIC 2D PROFILE AND CHAMFER HELPERS
// ---------------------------------------------------------------------------

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


// Extrude a child Y/Z profile between two X coordinates.
// The 2D child's first coordinate becomes Y and second coordinate becomes Z.
module extrude_yz_profile_between_x(x_min, x_max, convexity = 10) {
    assert(x_max > x_min, "x_max must be greater than x_min");

    multmatrix([
        [0, 0, 1, x_min],
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = x_max - x_min, convexity = convexity)
            children();
}


// ---------------------------------------------------------------------------
// TRACK CROSS-SECTION
// ---------------------------------------------------------------------------

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
    chamfered_rectangle_2d(track_width, track_height, body_chamfer);
}


module measured_track_end_face_profile_2d(center_x = 0) {
    run = track_end_chamfer_run;

    polygon([
        [center_x - track_width / 2 + run, run],
        [center_x + track_width / 2 - run, run],
        [center_x + track_width / 2 - run, track_height - run],
        [center_x - track_width / 2 + run, track_height - run]
    ]);
}


// Flexy-only rail well cutter. It keeps the wells continuous like V9, but
// softens the mouth and floor with simple 45-degree chamfer steps.
module flexy_rail_well_cutter_2d() {
    run = flexy_well_chamfer_run;
    has_chamfer = body_chamfer > 0 && run > 0;

    floor_half_width = has_chamfer
        ? max(epsilon, track_well_width_bottom / 2 - run)
        : track_well_width_bottom / 2;
    lower_wall_half_width = track_well_width_bottom / 2;
    upper_wall_half_width = track_well_width_top / 2;
    mouth_half_width = has_chamfer
        ? track_well_width_top / 2 + run
        : track_well_width_top / 2;

    lower_chamfer_z = has_chamfer ? run : 0;
    upper_chamfer_z = has_chamfer
        ? max(run, track_well_depth - run)
        : track_well_depth;

    polygon([
        [-floor_half_width, 0],
        [ floor_half_width, 0],
        [ lower_wall_half_width, lower_chamfer_z],
        [ upper_wall_half_width, upper_chamfer_z],
        [ mouth_half_width, track_well_depth],
        [-mouth_half_width, track_well_depth],
        [-upper_wall_half_width, upper_chamfer_z],
        [-lower_wall_half_width, lower_chamfer_z]
    ]);
}


module selected_rail_well_cutter_2d(flexy_profile = false) {
    if (flexy_profile && flexy_rail_well_style == "chamfered")
        flexy_rail_well_cutter_2d();
    else
        rail_well_cutter_2d();
}


// Places both top wells and, optionally, their mirrored underside pair.
module track_well_cutters_2d(
    include_bottom_wells = two_sided,
    flexy_profile = false
) {
    for (x_offset = [-track_well_spacing / 2,
                      track_well_spacing / 2]) {
        x = track_width / 2 + x_offset;

        translate([
            x,
            track_height - track_well_depth + rail_well_surface_clearance
        ])
            selected_rail_well_cutter_2d(flexy_profile);

        if (include_bottom_wells)
            translate([x, track_well_depth - rail_well_surface_clearance])
                rotate(180)
                    selected_rail_well_cutter_2d(flexy_profile);
    }
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


// ---------------------------------------------------------------------------
// CONNECTOR MATH AND COMMON PROFILES
// ---------------------------------------------------------------------------

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
                if (erode > 0 && !include_rail_wells
                    && !include_bottom_wells)
                    measured_track_end_face_profile_2d();
                else if (erode > 0)
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


module rail_well_cutters_3d(
    length = flexy_body_length,
    include_bottom_wells = two_sided,
    flexy_profile = false
) {
    extrude_xz_profile_between_y(-epsilon, length + epsilon)
        translate([-track_width / 2, 0])
            track_well_cutters_2d(
                include_bottom_wells,
                flexy_profile
            );
}


function rounded_relief_gap_arc_points(
    cap_x,
    y_center,
    radius,
    start_angle,
    end_angle
) = [
    for (i = [0 : flexy_relief_arc_segments])
        [
            cap_x
                + radius
                * cos(start_angle
                      + (end_angle - start_angle)
                      * i / flexy_relief_arc_segments),
            y_center
                + radius
                * sin(start_angle
                      + (end_angle - start_angle)
                      * i / flexy_relief_arc_segments)
        ]
];


function profile_points_at_y(points_xz, y) =
    [for (point = points_xz) [point[0], y, point[1]]];


module loft_between_xz_profiles_along_y(
    profile_start,
    profile_finish,
    y_start,
    y_finish
) {
    point_count = len(profile_start);

    assert(point_count == len(profile_finish),
           "loft profiles must have the same point count");

    polyhedron(
        points = concat(
            profile_points_at_y(profile_start, y_start),
            profile_points_at_y(profile_finish, y_finish)
        ),
        faces = relief_gap_loft_faces(point_count),
        convexity = 10
    );
}


function rail_well_profile_xz(
    center_x,
    floor_z,
    mouth_z,
    floor_half_width,
    mouth_half_width
) = [
    [center_x - floor_half_width, floor_z],
    [center_x + floor_half_width, floor_z],
    [center_x + mouth_half_width, mouth_z],
    [center_x - mouth_half_width, mouth_z]
];


function rail_well_end_side_offset(run) =
    run * sqrt(1 + pow(well_side_extension / track_well_depth, 2));


function rail_well_end_floor_half_width(run) =
    max(
        epsilon,
        track_well_width_bottom / 2
            - run * well_side_extension / track_well_depth
            + rail_well_end_side_offset(run)
    );


function rail_well_end_mouth_half_width(run) =
    max(
        epsilon,
        track_well_width_top / 2
            - run * well_side_extension / track_well_depth
            + rail_well_end_side_offset(run)
    );


module rail_well_end_chamfer_cutter(
    center_x,
    at_finish = false,
    length = flexy_body_length
) {
    run = track_end_chamfer_run;

    if (rail_well_end_chamfers && run > 0) {
        nominal_profile = rail_well_profile_xz(
            center_x,
            track_height - track_well_depth,
            track_height,
            track_well_width_bottom / 2,
            track_well_width_top / 2
        );
        face_profile = rail_well_profile_xz(
            center_x,
            track_height - track_well_depth - run,
            track_height - run,
            rail_well_end_floor_half_width(run),
            rail_well_end_mouth_half_width(run)
        );

        if (at_finish)
            loft_between_xz_profiles_along_y(
                nominal_profile,
                face_profile,
                length - run,
                length + epsilon
            );
        else
            loft_between_xz_profiles_along_y(
                face_profile,
                nominal_profile,
                -epsilon,
                run
            );
    }
}


module flexy_rail_well_cutters_with_end_chamfers(
    length = flexy_body_length,
    include_bottom_wells = two_sided,
    flexy_profile = true
) {
    run = track_end_chamfer_run;
    middle_start = rail_well_end_chamfers ? run - epsilon : -epsilon;
    middle_finish = rail_well_end_chamfers ? length - run + epsilon
                                           : length + epsilon;

    if (middle_finish > middle_start)
        extrude_xz_profile_between_y(middle_start, middle_finish)
            translate([-track_width / 2, 0])
                track_well_cutters_2d(
                    include_bottom_wells,
                    flexy_profile
                );

    if (rail_well_end_chamfers && !include_bottom_wells)
        for (x_offset = [-track_well_spacing / 2,
                         track_well_spacing / 2]) {
            center_x = x_offset;

            rail_well_end_chamfer_cutter(center_x, false);
            rail_well_end_chamfer_cutter(center_x, true, length);
        }
}


function rounded_relief_gap_profile_points(
    gap_start_y,
    bridge_on_right,
    expand = 0
) =
    let(
        radius = flexy_gap_length / 2 + flexy_gap_y_overcut + expand,
        y_center = gap_start_y + flexy_gap_length / 2,
        y_min = y_center - radius,
        y_max = y_center + radius
    )
    bridge_on_right
        ? let(
            x_open = -track_width / 2 - epsilon,
            cap_x = track_width / 2 - flexy_bridge_width
          )
          concat(
              [[x_open, y_min]],
              rounded_relief_gap_arc_points(
                  cap_x,
                  y_center,
                  radius,
                  -90,
                  90
              ),
              [[x_open, y_max]]
          )
        : let(
            x_open = track_width / 2 + epsilon,
            cap_x = -track_width / 2 + flexy_bridge_width
          )
          concat(
              [[cap_x, y_min], [x_open, y_min], [x_open, y_max]],
              rounded_relief_gap_arc_points(
                  cap_x,
                  y_center,
                  radius,
                  90,
                  270
              )
          );


function profile_points_at_z(points_2d, z) =
    [for (point = points_2d) [point[0], point[1], z]];


function relief_gap_loft_faces(point_count) =
    concat(
        [[for (i = [point_count - 1 : -1 : 0]) i]],
        [[for (i = [0 : point_count - 1]) point_count + i]],
        [
            for (i = [0 : point_count - 1])
                [
                    i,
                    (i + 1) % point_count,
                    point_count + (i + 1) % point_count,
                    point_count + i
                ]
        ]
    );


module loft_between_xy_profiles(
    profile_bottom,
    profile_top,
    z_bottom,
    z_top
) {
    point_count = len(profile_bottom);

    assert(point_count == len(profile_top),
           "loft profiles must have the same point count");

    polyhedron(
        points = concat(
            profile_points_at_z(profile_bottom, z_bottom),
            profile_points_at_z(profile_top, z_top)
        ),
        faces = relief_gap_loft_faces(point_count),
        convexity = 10
    );
}


module flexy_rectangular_relief_gap_cutter(
    gap_start_y = flexy_start_block_length,
    bridge_on_right = true
) {
    x_min = bridge_on_right
        ? -track_width / 2 - epsilon
        : -track_width / 2 + flexy_bridge_width;

    translate([x_min, gap_start_y - flexy_gap_y_overcut, -epsilon])
        cube([
            track_width - flexy_bridge_width + 2 * epsilon,
            flexy_gap_length + 2 * flexy_gap_y_overcut,
            track_height + 2 * epsilon
        ]);
}


module flexy_rounded_relief_gap_cutter(
    gap_start_y = flexy_start_block_length,
    bridge_on_right = true
) {
    run = flexy_relief_edge_chamfer_run;
    inner_profile = rounded_relief_gap_profile_points(
        gap_start_y,
        bridge_on_right,
        0
    );
    surface_profile = rounded_relief_gap_profile_points(
        gap_start_y,
        bridge_on_right,
        run
    );

    if (run > 0) {
        translate([0, 0, -epsilon])
            linear_extrude(
                height = track_height + 2 * epsilon,
                convexity = 10
            )
                polygon(inner_profile);

        loft_between_xy_profiles(
            surface_profile,
            inner_profile,
            -epsilon,
            run + epsilon
        );
        loft_between_xy_profiles(
            inner_profile,
            surface_profile,
            track_height - run - epsilon,
            track_height + epsilon
        );
    } else {
        translate([0, 0, -epsilon])
            linear_extrude(height = track_height + 2 * epsilon,
                           convexity = 10)
                polygon(inner_profile);
    }
}


module flexy_relief_gap_cutter(
    gap_start_y = flexy_start_block_length,
    bridge_on_right = true
) {
    if (flexy_relief_gap_end_style == "rounded")
        flexy_rounded_relief_gap_cutter(gap_start_y, bridge_on_right);
    else
        flexy_rectangular_relief_gap_cutter(gap_start_y, bridge_on_right);
}


module flexy_inner_corner_chamfer_cutter(
    corner_x,
    corner_y,
    material_x_direction,
    material_y_direction
) {
    run = flexy_inner_corner_chamfer_run;

    if (body_chamfer > 0 && run > 0) {
        translate([0, 0, -epsilon])
            linear_extrude(height = track_height + 2 * epsilon,
                           convexity = 10)
                polygon([
                    [
                        corner_x - material_x_direction * epsilon,
                        corner_y - material_y_direction * epsilon
                    ],
                    [
                        corner_x
                            + material_x_direction * (run + epsilon),
                        corner_y - material_y_direction * epsilon
                    ],
                    [
                        corner_x - material_x_direction * epsilon,
                        corner_y
                            + material_y_direction * (run + epsilon)
                    ]
                ]);
    }
}


// Exact V9R3 chamfer triangle, expressed once for both X- and Y-facing edges.
function directed_edge_chamfer_triangle(
    edge,
    material_direction,
    surface_z,
    inner_z,
    run
) = material_direction < 0
    ? [
        [edge - run, surface_z],
        [edge + epsilon, surface_z],
        [edge + epsilon, inner_z]
      ]
    : [
        [edge - epsilon, surface_z],
        [edge + run, surface_z],
        [edge - epsilon, inner_z]
      ];


module flexy_edge_chamfer_profiles_2d(edge, material_direction) {
    run = body_chamfer_run;

    polygon(directed_edge_chamfer_triangle(
        edge,
        material_direction,
        track_height + epsilon,
        track_height - run - epsilon,
        run
    ));

    polygon(directed_edge_chamfer_triangle(
        edge,
        material_direction,
        -epsilon,
        run + epsilon,
        run
    ));
}


module flexy_y_edge_chamfer_cutter(
    gap_edge_y,
    x_min,
    x_max,
    material_y_direction
) {
    if (body_chamfer > 0 && body_chamfer_run > 0)
        extrude_yz_profile_between_x(x_min, x_max)
            flexy_edge_chamfer_profiles_2d(
                gap_edge_y,
                material_y_direction
            );
}


module flexy_x_edge_chamfer_cutter(
    bridge_edge_x,
    y_min,
    y_max,
    material_x_direction
) {
    if (body_chamfer > 0 && body_chamfer_run > 0)
        extrude_xz_profile_between_y(y_min, y_max)
            flexy_edge_chamfer_profiles_2d(
                bridge_edge_x,
                material_x_direction
            );
}


module flexy_relief_gap_chamfer_cutters(
    gap_start_y = flexy_start_block_length,
    bridge_on_right = true
) {
    y_min = gap_start_y;
    y_max = gap_start_y + flexy_gap_length;

    cut_x_min = bridge_on_right
        ? -track_width / 2 - epsilon
        : -track_width / 2 + flexy_bridge_width;

    cut_x_max = bridge_on_right
        ? track_width / 2 - flexy_bridge_width
        : track_width / 2 + epsilon;

    bridge_edge_x = bridge_on_right
        ? cut_x_max
        : cut_x_min;

    bridge_material_direction = bridge_on_right ? 1 : -1;

    flexy_y_edge_chamfer_cutter(
        y_min,
        cut_x_min,
        cut_x_max,
        -1
    );
    flexy_y_edge_chamfer_cutter(
        y_max,
        cut_x_min,
        cut_x_max,
        1
    );
    flexy_x_edge_chamfer_cutter(
        bridge_edge_x,
        y_min - epsilon,
        y_max + epsilon,
        bridge_material_direction
    );
    flexy_inner_corner_chamfer_cutter(
        bridge_edge_x,
        y_min,
        bridge_material_direction,
        -1
    );
    flexy_inner_corner_chamfer_cutter(
        bridge_edge_x,
        y_max,
        bridge_material_direction,
        1
    );
}


module flexy_relief_gap_cutters() {
    for (gap_index = [0 : flexy_gap_count - 1]) {
        flexy_relief_gap_cutter(
            flexy_gap_start_y(gap_index),
            flexy_gap_bridge_on_right(gap_index)
        );
        if (flexy_relief_gap_end_style == "rectangular")
            flexy_relief_gap_chamfer_cutters(
                flexy_gap_start_y(gap_index),
                flexy_gap_bridge_on_right(gap_index)
            );
    }
}


// SF200-style flexy geometry. Rail wells are cut after the body, but their
// starts and finishes get a separate measured lead-in/out chamfer.
module flexy_straight_track_raw() {
    difference() {
        straight_track_length(
            flexy_body_length,
            flexy_start_end,
            flexy_finish_end,
            false,
            false
        );

        flexy_rail_well_cutters_with_end_chamfers(
            flexy_body_length,
            two_sided,
            true
        );
        flexy_relief_gap_cutters();
    }
}


module flexy_straight_track() {
    flexy_straight_track_raw();
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
// with use <xstl_v10_refresh.scad>.

function path_direction_from_heading(heading) =
    [-sin(heading), cos(heading), 0];

function centered_leg_start_position(length, heading) =
    -path_direction_from_heading(heading) * length / 2;


module place_centered_straight_leg(length, heading) {
    translate(centered_leg_start_position(length, heading))
        rotate([0, 0, heading])
            children();
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
        rail_well_cutters_3d(length, both_sides, false);
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


// ---------------------------------------------------------------------------
// GENERATE SELECTED MODEL
// ---------------------------------------------------------------------------

module selected_track() {
    if (track_type == "straight")
        straight_track();
    else if (track_type == "curve")
        curved_track(curve_direction);
    else if (track_type == "intersection")
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
    else
        flexy_straight_track();
}


// A resolved F5 mesh avoids camera-dependent OpenCSG omissions. With the
// nightly Manifold backend this is fast enough to use as the default for all
// four models. F6/export remains on the ordinary final-render path.
if ($preview && resolved_preview)
    render(convexity = 10)
        selected_track();
else
    selected_track();


// ---------------------------------------------------------------------------
// CONSOLE REPORT
// ---------------------------------------------------------------------------

function report_stage() = $preview ? "F5 preview" : "F6/export";

function body_envelope_length(body_length, end1, end2) =
    body_length
    + connector_external_length(end1)
    + connector_external_length(end2);


module console_summary() {
    echo(str(
        "XSTL V10 Refresh | ", track_type,
        " | ", report_stage(), " | $fn=", $fn,
        $preview ? str(" | resolved=", resolved_preview) : ""
    ));

    if (track_type == "straight")
        echo(str(
            "Straight | body=", straight_length,
            " mm | envelope=",
            body_envelope_length(straight_length, start_end, finish_end),
            " mm | ends=", start_end, "/", finish_end,
            " | two-sided=", two_sided
        ));
    else if (track_type == "curve")
        echo(str(
            "Curve | radius=", curve_centerline_radius,
            " mm | arc=", curve_arc_length,
            " mm | angle=", curve_angle,
            " deg | ", curve_direction,
            " | ends=", start_end, "/", finish_end
        ));
    else if (track_type == "intersection")
        echo(str(
            "Intersection | angle=", intersection_angle,
            " deg | legs=", intersection_length_a, "/",
            intersection_length_b,
            " mm | A=", intersection_end1_a, "/", intersection_end2_a,
            " | B=", intersection_end1_b, "/", intersection_end2_b
        ));
    else
        echo(str(
            "Flexy | body=", flexy_body_length,
            " mm | envelope=", flexy_connector_envelope_length,
            " mm | oscillations=", flexy_oscillations,
            " | gaps=", flexy_gap_count,
            " | ends=", flexy_start_end, "/", flexy_finish_end
        ));
}


module console_full_report() {
    console_summary();

    echo(str(
        "Track profile | width/height=", track_width, "/", track_height,
        " mm | body/end chamfer=", body_chamfer, "/", track_end_chamfer,
        " mm | effective runs=", body_chamfer_run, "/",
        track_end_chamfer_run, " mm"
    ));
    echo(str(
        "Rail wells | depth=", track_well_depth,
        " mm | top/bottom width=", track_well_width_top, "/",
        track_well_width_bottom,
        " mm | spacing=", track_well_spacing, " mm"
    ));
    echo(str(
        "Plug ", plug_system,
        " | radius/neck width/length=", plug_radius, "/",
        plug_neck_width, "/", plug_neck_length,
        " mm | head angle/height=", plug_head_chamfer_angle, "/",
        plug_head_chamfer_height,
        " | neck chamfer=", plug_neck_chamfer, " mm"
    ));
    echo(str(
        "Nest ", nest_system,
        " | radius/neck width/length=", nest_radius, "/",
        nest_neck_width, "/", nest_neck_length,
        " mm | flare angle/height=", nest_chamfer_angle, "/",
        nest_chamfer_height,
        " | neck chamfer=", nest_neck_chamfer, " mm"
    ));

    if (track_type == "curve")
        echo(str(
            "Curve radii | inner/center/outer=", curve_inner_radius, "/",
            curve_centerline_radius, "/", curve_outer_radius, " mm"
        ));

    if (track_type == "intersection")
        echo(str(
            "Intersection underside wells=", intersection_both_sides
        ));

    if (track_type == "flexy_straight") {
        echo(str(
            "Flexy blocks | start/finish=", flexy_start_block_length, "/",
            flexy_finish_block_length,
            " mm | flexible region=", flexy_flex_region_length, " mm"
        ));
        echo(str(
            "Flexy repeat | section/gap/bridge=", flexy_section_length, "/",
            flexy_gap_length, "/", flexy_bridge_width,
            " mm | phase=", flexy_gap_bridge_phase,
            " | end style=", flexy_relief_gap_end_style,
            " | arc segments=", flexy_relief_arc_segments,
            " | gap Y overcut=", flexy_gap_y_overcut, " mm",
            " | relief chamfer run=", flexy_relief_edge_chamfer_run, " mm"
        ));
        echo(str(
            "Flexy chamfers | inner corner/well=",
            flexy_inner_corner_chamfer_run, "/",
            flexy_well_chamfer_run,
            " mm | outer shoulder=", flexy_outer_shoulder_width,
            " mm | rail well style=", flexy_rail_well_style,
            " | rail well clearance=", rail_well_surface_clearance, " mm",
            " | rail well end chamfers=", rail_well_end_chamfers
        ));
    }

    echo(str(
        "Advanced | connector overlap=", connector_body_overlap,
        " mm | preview/render fragments=", preview_curve_fragments, "/",
        render_curve_fragments
    ));
}


if (console_report == "summary")
    console_summary();
else if (console_report == "full")
    console_full_report();
