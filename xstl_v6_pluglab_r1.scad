/*
    xstl_v6_pluglab_r1.scad

    Standalone, native-OpenSCAD generator for straight and curved
    wooden-railway-compatible track pieces.

    Plug Lab R1 goals:
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
      - Add experimental plug-head retention variants without changing the
        standard plug, nest, track-body, rail-well, curve, or placement
        behavior.

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
// CUSTOMIZER: OUTPUT MODE
// ===========================================================================

/* [Output Mode] */

// Choose the normal track generator or a small plug-fit test harness.
output_mode = "track";                 // [track,plug_test_coupon,plug_test_array]


// ===========================================================================
// CUSTOMIZER: TRACK SELECTION
// ===========================================================================

/* [Track Selection] */

// Choose the track body to generate.
track_type = "curve";                  // [straight,curve]

// Add matching rail wells to the underside.
two_sided = false;

// Connector at the beginning of the track.
start_end = "plug";                    // [plug,nest,none]

// Connector at the far end of the track.
finish_end = "nest";                   // [plug,nest,none]


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
// CUSTOMIZER: PLUG FIT LAB
// ===========================================================================

/* [Plug Fit Lab] */

// Select the experimental plug-head profile. The standard variant is the
// unchanged V6 plug head.
plug_profile_variant = "standard";      // [standard,mid_band,rounded_bulge]

// Total diameter addition for plug-head fit features.
plug_feature_diameter_add = 0.20;       // [0:0.01:1]

// Vertical height of the plug-head fit feature.
plug_feature_height = 1.20;             // [0.05:0.05:6]

// Z center of the plug-head fit feature.
plug_feature_center_z = 6.0;            // [0:0.05:12]

// Number of profile samples across the rounded bulge feature.
plug_bulge_samples = 16;                // [4:1:80]


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

well_side_extension =
    (track_well_width_top - track_well_width_bottom) / 2;

// A square of side S rotated 45 degrees cuts equal legs of S / sqrt(2).
track_end_chamfer_run = track_end_chamfer / sqrt(2);
body_chamfer_run = body_chamfer / sqrt(2);
plug_neck_chamfer_run = plug_neck_chamfer / sqrt(2);

plug_feature_radial_add = plug_feature_diameter_add / 2;
plug_feature_start_z = plug_feature_center_z - plug_feature_height / 2;
plug_feature_end_z = plug_feature_center_z + plug_feature_height / 2;

plug_test_coupon_body_length = 34;
plug_test_coupon_spacing = track_width + 20;
plug_test_array_diameter_adds = [0.00, 0.10, 0.20, 0.30];


// ===========================================================================
// SANITY CHECKS
// ===========================================================================

assert(preview_curve_fragments >= 3,
       "preview_curve_fragments must be at least 3");
assert(render_curve_fragments >= 3,
       "render_curve_fragments must be at least 3");
assert(output_mode == "track"
       || output_mode == "plug_test_coupon"
       || output_mode == "plug_test_array",
       "output_mode must be track, plug_test_coupon, or plug_test_array");
assert(track_width > 0, "track_width must be greater than zero");
assert(track_height > 0, "track_height must be greater than zero");
assert(body_chamfer >= 0, "body_chamfer cannot be negative");
assert(track_end_chamfer >= 0, "track_end_chamfer cannot be negative");
assert(plug_neck_chamfer >= 0, "plug_neck_chamfer cannot be negative");
assert(straight_length > 0, "straight_length must be greater than zero");
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
assert(plug_profile_variant == "standard"
       || plug_profile_variant == "mid_band"
       || plug_profile_variant == "rounded_bulge",
       "plug_profile_variant must be standard, mid_band, or rounded_bulge");
assert(plug_feature_diameter_add >= 0,
       "plug_feature_diameter_add cannot be negative");
assert(plug_feature_height >= 0,
       "plug_feature_height cannot be negative");
assert(plug_profile_variant == "standard" || plug_feature_height > 0,
       "plug_feature_height must be greater than zero for plug features");
assert(plug_profile_variant == "standard"
       || (plug_feature_start_z >= 0 && plug_feature_end_z <= track_height),
       "plug feature Z range must stay inside the plug head height");
assert(plug_bulge_samples >= 4
       && plug_bulge_samples == floor(plug_bulge_samples),
       "plug_bulge_samples must be an integer of at least 4");
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


module track_well_cutters_2d() {
    // Top wells.
    for (x_offset = [-track_well_spacing / 2,
                      track_well_spacing / 2]) {
        translate([
            track_width / 2 + x_offset,
            track_height - track_well_depth + epsilon
        ])
            rail_well_cutter_2d();
    }

    // Optional underside wells.
    if (two_sided) {
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
}


// Complete track-material profile in X/Z. The profile is centered on X =
// center_x, sits on Z = 0, and includes body chamfers and optional wells.
module track_profile_2d(center_x = 0) {
    translate([center_x - track_width / 2, 0])
        difference() {
            track_body_outline_2d();
            track_well_cutters_2d();
        }
}


// ===========================================================================
// CONNECTOR MATH AND COMMON PROFILES
// ===========================================================================

function clamped_angle(angle) = min(89.9, max(0.1, angle));

function connector_chamfer_run(height, angle) =
    height <= 0 ? 0 : height / tan(clamped_angle(angle));

function plug_head_effective_chamfer_h() =
    min(max(0, plug_head_chamfer_height), track_height / 2 - epsilon);

function plug_head_effective_chamfer_run(radius = plug_radius) =
    let(
        chamfer_h = plug_head_effective_chamfer_h(),
        requested_run = connector_chamfer_run(
            chamfer_h,
            plug_head_chamfer_angle
        )
    )
    min(requested_run, radius - epsilon);

function plug_head_base_radius_at_z(
    z,
    radius = plug_radius
) =
    let(
        chamfer_h = plug_head_effective_chamfer_h(),
        chamfer_run = plug_head_effective_chamfer_run(radius)
    )
    chamfer_h <= 0 || chamfer_run <= 0 ? radius :
    z <= chamfer_h
        ? radius - chamfer_run + chamfer_run * z / chamfer_h :
    z >= track_height - chamfer_h
        ? radius - chamfer_run
            + chamfer_run * (track_height - z) / chamfer_h :
    radius;

function plug_feature_bump_at_z(
    z,
    radial_add,
    center_z = plug_feature_center_z,
    height = plug_feature_height
) =
    let(
        half_height = height / 2,
        u = half_height <= 0 ? 2 : (z - center_z) / half_height
    )
    abs(u) <= 1 ? radial_add * 0.5 * (1 + cos(180 * u)) : 0;

function plug_effective_radial_add(
    variant = plug_profile_variant,
    diameter_add = plug_feature_diameter_add
) =
    variant == "standard" ? 0 : diameter_add / 2;

function plug_max_effective_head_diameter(
    variant = plug_profile_variant,
    radius = plug_radius,
    diameter_add = plug_feature_diameter_add
) =
    2 * (radius + plug_effective_radial_add(variant, diameter_add));

function plug_mid_band_profile_points(
    radius = plug_radius,
    diameter_add = plug_feature_diameter_add
) =
    let(
        chamfer_h = plug_head_effective_chamfer_h(),
        chamfer_run = plug_head_effective_chamfer_run(radius),
        radial_add = diameter_add / 2,
        start_z = plug_feature_start_z,
        end_z = plug_feature_end_z
    )
    concat(
        [
            [0, 0],
            [plug_head_base_radius_at_z(0, radius), 0]
        ],
        chamfer_h > 0 && chamfer_run > 0
            ? [[radius, chamfer_h]]
            : [],
        [
            [radius, start_z],
            [radius + radial_add, start_z],
            [radius + radial_add, end_z],
            [radius, end_z]
        ],
        chamfer_h > 0 && chamfer_run > 0
            ? [[radius, track_height - chamfer_h]]
            : [],
        [
            [plug_head_base_radius_at_z(track_height, radius), track_height],
            [0, track_height]
        ]
    );

function plug_rounded_bulge_profile_points(
    radius = plug_radius,
    diameter_add = plug_feature_diameter_add,
    samples = plug_bulge_samples
) =
    let(
        chamfer_h = plug_head_effective_chamfer_h(),
        chamfer_run = plug_head_effective_chamfer_run(radius),
        radial_add = diameter_add / 2,
        start_z = plug_feature_start_z,
        end_z = plug_feature_end_z
    )
    concat(
        [
            [0, 0],
            [plug_head_base_radius_at_z(0, radius), 0]
        ],
        chamfer_h > 0 && chamfer_run > 0
            ? [[radius, chamfer_h]]
            : [],
        [[radius, start_z]],
        [
            for (i = [1 : samples - 1])
                let(z = start_z + (end_z - start_z) * i / samples)
                    [radius + plug_feature_bump_at_z(z, radial_add), z]
        ],
        [[radius, end_z]],
        chamfer_h > 0 && chamfer_run > 0
            ? [[radius, track_height - chamfer_h]]
            : [],
        [
            [plug_head_base_radius_at_z(track_height, radius), track_height],
            [0, track_height]
        ]
    );

assert(plug_profile_variant == "standard"
       || plug_feature_start_z >= plug_head_effective_chamfer_h(),
       "plug feature must start within the plug-head vertical sidewall");
assert(plug_profile_variant == "standard"
       || plug_feature_end_z <= track_height - plug_head_effective_chamfer_h(),
       "plug feature must end within the plug-head vertical sidewall");
assert(plug_profile_variant == "standard"
       || plug_feature_height < track_height
            - 2 * plug_head_effective_chamfer_h(),
       "plug feature must leave ordinary plug-head sidewall outside the feature");
assert(plug_profile_variant == "standard"
       || plug_feature_radial_add < plug_radius,
       "plug_feature_diameter_add is too large for the plug head radius");


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

// Standard circular plug head. Its top and bottom chamfers are generated by
// revolving the unchanged V6 2D radial profile around the Z axis.
module standard_plug_head_3d(radius = plug_radius) {
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


// Axisymmetric plug-head variants use one revolved radial/Z profile body.
module plug_head_axisymmetric_3d(
    variant = plug_profile_variant,
    radius = plug_radius,
    feature_diameter_add = plug_feature_diameter_add
) {
    if (variant == "mid_band") {
        rotate_extrude(angle = 360, convexity = 10)
            polygon(
                plug_mid_band_profile_points(
                    radius,
                    feature_diameter_add
                )
            );
    } else if (variant == "rounded_bulge") {
        rotate_extrude(angle = 360, convexity = 10)
            polygon(
                plug_rounded_bulge_profile_points(
                    radius,
                    feature_diameter_add,
                    plug_bulge_samples
                )
            );
    } else {
        standard_plug_head_3d(radius);
    }
}


// Extension point for future local -Y/+Y plug-head features.
module plug_head_directional_feature_3d(
    variant = plug_profile_variant,
    radius = plug_radius,
    feature_diameter_add = plug_feature_diameter_add
) {
}


module plug_head_variant_3d(
    variant = plug_profile_variant,
    radius = plug_radius,
    feature_diameter_add = plug_feature_diameter_add
) {
    if (variant == "standard") {
        standard_plug_head_3d(radius);
    } else {
        union() {
            plug_head_axisymmetric_3d(
                variant,
                radius,
                feature_diameter_add
            );

            plug_head_directional_feature_3d(
                variant,
                radius,
                feature_diameter_add
            );
        }
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


// Extension point for future plug-neck fit experiments.
module plug_neck_variant_3d(variant = plug_profile_variant) {
    plug_neck_3d();
}


module plug_connector_local_3d(
    variant = plug_profile_variant,
    feature_diameter_add = plug_feature_diameter_add
) {
    union() {
        plug_neck_variant_3d(variant);

        translate([0, plug_neck_length, 0])
            plug_head_variant_3d(
                variant,
                plug_radius,
                feature_diameter_add
            );
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

module add_end_connector(
    end_type,
    position = [0, 0, 0],
    rotation = 0,
    variant = plug_profile_variant,
    feature_diameter_add = plug_feature_diameter_add
) {
    if (end_type == "plug") {
        translate(position)
            rotate([0, 0, rotation])
                plug_connector_local_3d(variant, feature_diameter_add);
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
module track_profile_slice_local(y_position = 0, erode = 0) {
    translate([0, y_position + epsilon, 0])
        rotate([90, 0, 0])
            linear_extrude(height = 2 * epsilon, convexity = 10)
                if (erode > 0)
                    offset(delta = -erode)
                        track_profile_2d(0);
                else
                    track_profile_2d(0);
}


// At the exposed face, the entire material profile is inset by one chamfer
// run. A hull transitions to the full profile one run inside the body.
module whole_end_chamfer_keep_mask_local() {
    run = track_end_chamfer_run;
    big = 4 * (
        curve_centerline_radius +
        curve_arc_length +
        straight_length +
        track_width +
        100
    );

    if (track_end_chamfer <= 0 || run <= 0) {
        translate([-big / 2, -epsilon, -big / 2])
            cube([big, big, big]);
    } else {
        union() {
            hull() {
                track_profile_slice_local(0, run);
                track_profile_slice_local(run, 0);
            }

            translate([-big / 2, run, -big / 2])
                cube([big, big, big]);
        }
    }
}


module place_whole_end_chamfer_keep_mask(
    position = [0, 0, 0],
    inward_heading = 0
) {
    translate(position)
        rotate([0, 0, inward_heading])
            whole_end_chamfer_keep_mask_local();
}


// ===========================================================================
// STRAIGHT TRACK
// ===========================================================================

module straight_body_raw() {
    extrude_xz_profile_between_y(0, straight_length)
        track_profile_2d(0);
}


module straight_body() {
    intersection() {
        straight_body_raw();

        // Start end: inward is +Y.
        place_whole_end_chamfer_keep_mask([0, 0, 0], 0);

        // Finish end: inward is -Y.
        place_whole_end_chamfer_keep_mask(
            [0, straight_length, 0],
            180
        );
    }
}


module straight_track() {
    difference() {
        union() {
            straight_body();

            // Start plug points outward toward -Y.
            add_end_connector(start_end, [0, 0, 0], 180);

            // Finish plug points outward toward +Y.
            add_end_connector(
                finish_end,
                [0, straight_length, 0],
                0
            );
        }

        // Start nest cutter points inward toward +Y.
        cut_end_connector(start_end, [0, 0, 0], 0);

        // Finish nest cutter points inward toward -Y.
        cut_end_connector(
            finish_end,
            [0, straight_length, 0],
            180
        );
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
// PLUG TEST HARNESS
// ===========================================================================

module plug_test_coupon_body_raw(body_length = plug_test_coupon_body_length) {
    extrude_xz_profile_between_y(0, body_length)
        track_profile_2d(0);
}


module plug_test_coupon_body(body_length = plug_test_coupon_body_length) {
    intersection() {
        plug_test_coupon_body_raw(body_length);

        // Start end: inward is +Y.
        place_whole_end_chamfer_keep_mask([0, 0, 0], 0);

        // Plug end: inward is -Y.
        place_whole_end_chamfer_keep_mask(
            [0, body_length, 0],
            180
        );
    }
}


module plug_test_coupon(
    variant = plug_profile_variant,
    feature_diameter_add = plug_feature_diameter_add,
    body_length = plug_test_coupon_body_length
) {
    union() {
        plug_test_coupon_body(body_length);

        add_end_connector(
            "plug",
            [0, body_length, 0],
            0,
            variant,
            feature_diameter_add
        );
    }
}


module plug_test_array(variant = plug_profile_variant) {
    for (i = [0 : len(plug_test_array_diameter_adds) - 1]) {
        translate([i * plug_test_coupon_spacing, 0, 0])
            plug_test_coupon(
                variant,
                plug_test_array_diameter_adds[i],
                plug_test_coupon_body_length
            );
    }
}


// ===========================================================================
// GENERATE SELECTED MODEL
// ===========================================================================

if (output_mode == "track") {
    if (track_type == "straight") {
        straight_track();
    } else if (track_type == "curve") {
        curved_track(curve_direction);
    }
} else if (output_mode == "plug_test_coupon") {
    plug_test_coupon();
} else if (output_mode == "plug_test_array") {
    plug_test_array();
}


// ===========================================================================
// CONSOLE DIAGNOSTICS
// ===========================================================================

if (show_diagnostics) {
    echo("XSTL version:", "V6 Plug Lab R1");
    echo("Output mode:", output_mode);
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
    echo("Plug profile variant:", plug_profile_variant);
    echo("Plug feature diameter addition setting / effective (mm):",
         plug_feature_diameter_add,
         2 * plug_effective_radial_add(
             plug_profile_variant,
             plug_feature_diameter_add
         ));
    echo("Plug feature radial addition setting / effective (mm):",
         plug_feature_radial_add,
         plug_effective_radial_add(
             plug_profile_variant,
             plug_feature_diameter_add
         ));
    echo("Plug feature height / center Z (mm):",
         plug_feature_height, plug_feature_center_z);
    echo("Maximum effective plug-head diameter (mm):",
         plug_max_effective_head_diameter(
             plug_profile_variant,
             plug_radius,
             plug_feature_diameter_add
         ));
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

    if (output_mode == "plug_test_array") {
        echo("Plug test array order:", "left-to-right along +X");
        echo("Plug test array diameter additions (mm):",
             plug_test_array_diameter_adds);

        for (i = [0 : len(plug_test_array_diameter_adds) - 1]) {
            echo(str("Plug test array coupon ", i, " diameter add (mm):"),
                 plug_test_array_diameter_adds[i]);
            echo(str("Plug test array coupon ", i,
                     " max plug-head diameter (mm):"),
                 plug_max_effective_head_diameter(
                     plug_profile_variant,
                     plug_radius,
                     plug_test_array_diameter_adds[i]
                 ));
        }
    }
}
