# Starter prompt for Gesha

Hello Gesha 😊

You are taking over day-to-day code iteration on Dan's native-OpenSCAD wooden-railway track generator.

Please read these files completely before editing:

1. `xstl_v6.scad` — current source of truth
2. `Gesha_XSTL_Handoff.md` — architecture, terminology, invariants, and next-work plan

## Task

Create a new experimental file named:

```text
xstl_v6_pluglab_r1.scad
```

Do not overwrite `xstl_v6.scad`.

The goal of this first round is to test small, controlled increases to plug-head retention while preserving all current track, curve, rail-well, nest, chamfer, and placement behavior.

## Required terminology

Use only `plug` and `nest` terminology. Do not use gendered connector terms anywhere in code, comments, diagnostics, documentation, or commit messages.

## Stage 1 variants

Add a Customizer setting:

```scad
plug_profile_variant = "standard"; // [standard,mid_band,rounded_bulge]
```

### 1. `standard`

This must reproduce the current `xstl_v6.scad` plug geometry exactly.

Refactor only as needed to create a clean variant architecture. Do not intentionally change dimensions, chamfers, overlap, tessellation, placement, or CSG order.

### 2. `mid_band`

Add a narrow, circumferential, sharp-sided band around the circular plug head.

Suggested controls:

```scad
plug_feature_diameter_add = 0.20; // total DIAMETER addition
plug_feature_height = 1.20;
plug_feature_center_z = 6.0;
```

Internally derive:

```scad
plug_feature_radial_add = plug_feature_diameter_add / 2;
```

The feature is centered on the plug-head axis at local:

```scad
[0, plug_neck_length, 0]
```

Keep it inside the ordinary vertical sidewall region by default so it does not erase the existing top/bottom plug-head chamfers.

### 3. `rounded_bulge`

Create a smooth, axisymmetric increase in radius over a limited Z range.

Prefer generating this as part of the radial/Z profile used by `rotate_extrude()`, rather than unioning a sphere with the head.

A sampled cosine-window bump is acceptable:

```text
u = (z - center_z) / half_height
bump = radial_add * 0.5 * (1 + cos(180 * u)), for |u| <= 1
bump = 0 otherwise
```

Remember that OpenSCAD trig functions use degrees.

Provide a reasonable sample-count control or use the existing render resolution thoughtfully. Preserve the original circular head chamfers outside the bulge region.

## Architecture requirements

Please separate:

- Standard/base plug-head geometry
- Axisymmetric variant profile generation
- Future directional plug-head features
- Future plug-neck variants

A directionally localized “back-only” bulge and a neck bulge will come later. Add clean extension points, but do not implement those two variants in r1.

The local directional convention is:

- Back of plug head = toward the neck/body = local `-Y` from the head center
- Front of plug head = away from the neck/body = local `+Y`

## Test-output harness

Add:

```scad
output_mode = "track"; // [track,plug_test_coupon,plug_test_array]
```

### `track`

Generate the current selected straight/curved track normally.

### `plug_test_coupon`

Generate a small, printable body stub with one real plug connector using the same local placement and body-overlap rules as a track end. It must print flat without supports and use much less material than a full track.

### `plug_test_array`

Generate a row of separated test coupons. Default to four diameter additions:

```text
0.00, 0.10, 0.20, 0.30 mm
```

Make the order clear in console diagnostics. Add simple physical identifiers such as notch count only if that can be done cleanly without complicating the plug geometry.

## Diagnostics and validation

Add console output for:

- Selected plug variant
- Diameter addition
- Derived radial addition
- Feature height and center Z
- Maximum effective plug-head diameter
- Test-array order and values

Add assertions preventing:

- Negative feature dimensions
- A feature range outside the plug's Z height
- A bulge that consumes or invalidates the circular head profile
- Invalid sample counts

## Invariants

Do not change:

- Track-body dimensions
- Rail-well geometry
- Curve math
- Left/right curve behavior
- Whole-profile track-end chamfers
- Nest geometry
- Connector presets
- `connector_body_overlap`
- Preview/render fragment controls
- CSG order `(body + plugs) - nests`

## Verification

After implementation:

1. Compare `standard` against the original `xstl_v6.scad` and explain why it is geometrically unchanged.
2. Run F5/F6 or command-line OpenSCAD checks if available.
3. Export or render the three variants and inspect for disconnected solids, internal coplanar surfaces, missing chamfers, or non-manifold geometry.
4. Summarize every file changed and each new user-facing parameter.
5. Do not proceed to neck or back-only bulges until this first architecture and test harness are reviewed.
