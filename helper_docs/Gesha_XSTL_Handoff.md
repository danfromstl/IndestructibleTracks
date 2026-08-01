# XSTL / Rubber Track Generator — Handoff to Gesha

## 1. Purpose of this document

This is the working handoff for continued development of Dan's native-OpenSCAD wooden-railway track generator.

- **Current source of truth:** `xstl_v6.scad`
- **Project shorthand:** XSTL / RTG
- **Primary next workstream:** controlled plug-fit experiments
- **Coding partner name:** Gesha
- **Context/architecture partner name:** Emriss

The older source files are useful references, but they are not the file to modify:

- `train_tracks_generator.scad` / **torwan_2023**
- `Traintrack.scad` / **oymate_2025**
- `RubberTrackGenerator_v5.scad` / **RTG_v5**

Create a new experimental file or branch rather than overwriting `xstl_v6.scad`.

---

## 2. Project goal

Generate printable, BRIO-compatible straight and curved track geometry with:

- Native OpenSCAD only; no BOSL2 dependency
- Parametric track dimensions
- Independent `plug`, `nest`, or `none` selection at each end
- BRIO, IKEA, and Custom connector presets
- Rail wells on one or both sides
- Explicit centerline-based curve geometry
- Chamfered track bodies, track ends, plug heads/necks, and nest cavities
- Predictable, auditable module structure

The current product material is flexible/rubber-like filament, so tiny connector-profile changes can materially affect fit, retention, and ease of removal.

---

## 3. Terminology rule

Use only:

- `plug`
- `plug connector`
- `plug head`
- `plug neck`
- `nest`
- `nest connector`
- `nest cutter`
- `nest head`
- `nest neck`

Do **not** introduce the gendered connector terms that appear in some source files or conventional CAD terminology. This applies to code, comments, diagnostics, documentation, commit messages, and user-facing controls.

---

## 4. Lineage and design rationale

### Torwan-derived elements

`xstl_v6.scad` primarily inherits these physical dimensions and geometry ideas from torwan:

- 40 mm body width and 12 mm height defaults
- 2.9 mm rail-well depth
- 6.75 mm top and 4.75 mm bottom rail-well widths
- 25.7 mm rail-well center spacing
- Sharp trapezoidal rail wells
- Rotated-square 45-degree chamfer convention
- BRIO/IKEA plug and nest dimensions
- Revolved plug-head and nest-head profiles

### Oymate-derived elements

The curve parameter model follows oymate:

- `curve_centerline_radius` is measured to the track-body centerline
- `curve_arc_length` is measured along that centerline
- `curve_angle = curve_arc_length / curve_centerline_radius * 180 / PI`
- Left and right endpoint positions use explicit sine/cosine formulas
- Endpoint connector placement follows the path tangent

### Newer XSTL/RTG architecture

The current architecture adds or formalizes:

- Native OpenSCAD replacement for BOSL2 path sweeping
- Explicit X/Y/Z conventions
- Generic endpoint placement by position and heading
- Independent start/finish connector types
- Whole-profile track-end chamfers
- Plug-neck long-edge chamfers
- Nest-neck long-edge chamfers
- Four-sided nest-mouth flare
- Deliberate connector/body overlap
- Assertions and console diagnostics
- Named preview/render resolution controls
- No modeled weight-saving core

---

## 5. Coordinate conventions

### World/track coordinates

- **X:** across track, left/right
- **Y:** forward along a straight track
- **Z:** vertical/up

### Local connector coordinates

A local connector:

- Begins at the track end face at local `Y = 0`
- Points toward local `+Y`
- Occupies `Z = 0 ... track_height`
- Has its circular plug-head center at local:

```scad
[0, plug_neck_length, 0]
```

The head is centered vertically around:

```scad
Z = track_height / 2
```

For directional plug experiments:

- **Back of the plug head:** side toward the neck/body, local `-Y` from the head center
- **Front of the plug head:** side away from the neck/body, local `+Y` from the head center

Do not use screen orientation such as left/right/front/back without relating it to these local coordinates.

---

## 6. Current call structure

### Shared track profile

```text
track_profile_2d()
├── track_body_outline_2d()
│   └── chamfered_rectangle_2d()
│       └── corner_chamfer_cutter_2d()
└── subtract track_well_cutters_2d()
    └── rail_well_cutter_2d()
```

### Plug connector

```text
plug_connector_local_3d()
├── plug_neck_3d()
│   └── plug_neck_profile_2d()
└── translate to neck end
    └── plug_head_3d()
```

### Nest cutter

```text
nest_connector_cutter_local_3d()
├── nest_neck_cutter_3d()
│   └── nest_neck_cutter_profile_2d()
├── translate to neck end
│   └── nest_head_cutter_3d()
└── nest_mouth_end_chamfer_cutter_local()
```

### Straight track

```text
straight_track()
├── union
│   ├── straight_body()
│   │   ├── straight_body_raw()
│   │   └── whole-profile end-chamfer keep masks
│   └── requested plug connectors
└── subtract requested nest cutters
```

### Curved track

```text
curved_track(direction)
├── calculate endpoint position and tangent heading
├── union
│   ├── curved_body(direction)
│   │   ├── curved_body_raw(direction)
│   │   └── tangent-aligned end-chamfer keep masks
│   └── requested plug connectors
└── subtract requested nest cutters
```

---

## 7. Important current geometry decisions

### Rail wells

Current defaults:

```scad
track_well_depth = 2.9;
track_well_width_top = 6.75;
track_well_width_bottom = 4.75;
track_well_spacing = 25.7; // center-to-center
```

The 2.9 mm depth is intentionally retained pending physical calibration. Public descriptions commonly round the nominal groove depth to 3.0 mm, but no verified BRIO engineering specification is being treated as authoritative.

### Solid bodies

XSTL does not model torwan's optional weight-saving core. The only ordinary voids are:

- Rail wells
- Optional underside wells
- Selected nest-connector cavities

Slicer infill is separate from modeled cavities.

### Resolution

```scad
preview_curve_fragments = 96;
render_curve_fragments = 240;
$fn = $preview ? preview_curve_fragments : render_curve_fragments;
```

The final render/export value controls tessellation of circular and revolved geometry. Preserve these controls.

### Connector/body overlap

```scad
connector_body_overlap = 1.25;
```

This overlap prevents seams after whole-profile end chamfering. Do not remove it casually.

### CSG order

Plugs are added to the body. Nests are subtracted from the body. Preserve this ordering:

```text
(body + plugs) - nests
```

---

## 8. Plug-fit experiment design principles

The next work should distinguish between:

1. **Nominal connector dimensions** — the standard BRIO/IKEA/Custom base geometry
2. **Fit features** — small, optional additions or profile changes used to tune retention

Do not overwrite `plug_radius` or silently redefine what a BRIO plug is. A standard variant must remain available and geometrically identical to `xstl_v6.scad`.

### User-facing dimension convention

For fit features, expose **diameter addition** rather than radius addition where practical:

```scad
plug_feature_diameter_add = 0.20;
plug_feature_radial_add = plug_feature_diameter_add / 2;
```

This reduces the common ambiguity between “0.2 mm larger” in radius and diameter.

### Suggested variant families

#### A. Standard

No modification. This must reproduce the current plug exactly.

#### B. Mid-height band

A narrow circumferential band around the circular head:

- Centered near `track_height / 2`
- Slightly larger diameter
- Adjustable height and Z position
- Initially sharp-sided for easy comparison

Conceptually:

```scad
translate([0, 0, band_center_z - band_height / 2])
    cylinder(
        r = plug_radius + plug_feature_diameter_add / 2,
        h = band_height
    );
```

This geometry is placed at the plug-head center and unioned with the standard head.

Keep the band within the vertical sidewall region unless deliberately testing overlap with the top/bottom head chamfers.

#### C. Rounded circumferential bulge

For a genuinely smooth, uniform bulge, prefer modifying the revolved radial/Z head profile rather than unioning an unrelated sphere.

A useful sampled radius function is:

```text
outside feature range: radius = plug_radius
inside feature range:  radius = plug_radius + smooth_bump(z)
```

One smooth bump shape is a cosine window:

```text
u = (z - center_z) / half_height
bump = radial_add * 0.5 * (1 + cos(180 * u)), for |u| <= 1
```

This reaches full addition at the center and blends to zero with zero slope at each boundary.

Because OpenSCAD uses degrees for trigonometric functions, the `180 * u` form is intentional.

#### D. Neck bulge or neck widening

The current neck is a constant X/Z profile extruded along Y. A neck feature that changes along Y requires either:

- A unioned local feature, or
- A loft-like hull between thin neck-profile slices of different widths

Keep the existing four long-edge chamfers unless the experiment explicitly changes them.

#### E. Back-only head bulge

A back-only feature is **not axisymmetric**, so it cannot be represented by `rotate_extrude()` alone.

Build it as a separate localized 3D feature and clip it to the back half of the head:

- Head center is at `Y = plug_neck_length`
- Back half is toward smaller local Y
- Union the clipped feature with the standard head

Possible tools:

- `intersection()` with a half-space cube
- A scaled sphere/ellipsoid
- A larger cylinder clipped to an angular or rectangular region
- `hull()` between small localized slices

Keep directional geometry in a separate module from the axisymmetric head profile.

---

## 9. Recommended plug-module refactor

Do not put every experiment directly inside the current `plug_head_3d()`.

A clean architecture is:

```text
plug_connector_local_3d()
├── plug_neck_variant_3d()
└── plug_head_variant_3d()
    ├── standard_plug_head_3d()
    ├── axisymmetric plug profile variants
    └── optional directional plug feature
```

Possible module layout:

```scad
module standard_plug_head_3d(radius = plug_radius) { ... }

module plug_head_axisymmetric_3d(variant, radius = plug_radius) { ... }

module plug_head_directional_feature_3d(variant, radius = plug_radius) { ... }

module plug_head_variant_3d(variant = plug_profile_variant) {
    union() {
        // Exactly one base/axisymmetric head implementation.
        ...

        // Optional non-axisymmetric addition.
        plug_head_directional_feature_3d(variant, plug_radius);
    }
}

module plug_neck_variant_3d(variant = plug_profile_variant) { ... }
```

Avoid unioning the standard head and a complete replacement axisymmetric head, which would create redundant internal surfaces. Use one axisymmetric head body, then add only truly directional features.

---

## 10. Testing harness recommendation

Add an output selector separate from `track_type`, for example:

```scad
output_mode = "track"; // [track,plug_test_coupon,plug_test_array]
```

### `plug_test_coupon`

Generate a short body stub ending in one plug. It should:

- Use the real body/connector placement conventions
- Print flat without support
- Be easy to hold and insert repeatedly
- Use much less filament and time than a complete track

### `plug_test_array`

Generate several separated coupons with controlled diameter additions, for example:

```text
0.00 mm, +0.10 mm, +0.20 mm, +0.30 mm diameter
```

These are sensible starting increments, not a universal fit standard.

Make identification unambiguous using one or more of:

- Position order documented in console output
- Small notch counts on the handle
- Embossed/debossed labels if rendering cost remains acceptable

The diagnostic output should state each coupon's:

- Variant
- Diameter addition
- Maximum effective plug-head diameter
- Band/bulge height and Z center

---

## 11. Acceptance criteria for experimental revisions

1. `plug_profile_variant = "standard"` preserves `xstl_v6.scad` geometry.
2. No nest geometry changes unless explicitly requested.
3. No track body, rail-well, curve, or endpoint-placement changes.
4. No gendered connector terminology anywhere.
5. F5 preview and F6 render complete without warnings caused by the new code.
6. Exported geometry is watertight/manifold in the slicer.
7. The modified plug remains connected to the neck/body with no coincident-face seam.
8. Existing head top/bottom chamfers remain intact unless the selected experiment intentionally crosses them.
9. User-facing controls clearly distinguish diameter from radius.
10. Diagnostics state the resulting dimensions.
11. Experimental code is modular enough to add neck and back-only variants later.

---

## 12. Versioning and workflow

Recommended first file:

```text
xstl_v6_pluglab_r1.scad
```

Recommended Git branch:

```text
plug-fit-lab
```

Suggested commit sequence:

1. Refactor standard plug head without changing geometry
2. Add output/test-coupon harness
3. Add sharp mid-height band
4. Add rounded circumferential bulge
5. Add assertions and diagnostics
6. Render/export comparison and document test matrix

Keep each geometry family in a separate commit so regressions are easy to isolate.

---

## 13. First experimental scope

Implement only these in the first round:

- `standard`
- `mid_band`
- `rounded_bulge`
- `plug_test_coupon`
- `plug_test_array`

Design extension points for `neck_bulge` and `rear_bulge`, but leave those for the next round. The first physical prints should answer whether a small uniform interference feature improves retention before adding directional complexity.
