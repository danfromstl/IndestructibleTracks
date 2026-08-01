include <BOSL2/std.scad>;

/**
 * Wave Generator
 *      
 * Author: Jason Koolman  
 * Version: 1.0  
 *
 * Description:
 * This OpenSCAD script generates a variety of fully parametric waveforms 
 * for applications in mechanical design, functional 3D-printed springs, 
 * signal processing visualization, and decorative patterns. It supports 
 * multiple wave types, including sine, square, triangle, sawtooth, and 
 * pulse waves, with customizable amplitude, frequency, phase, and smoothing. 
 * Optional end attachments allow for integration with other structures.
 *
 * License:
 * This script is shared under the Standard Digital File License (SDFL).
 */

/* [〰 Wave] */

// Type of wave to generate.
Type = "square"; // [square: Square, triangle: Triangle, sine: Sine, sawtooth: Sawtooth, pulse: Pulse]

// Wave height from peak to trough.
Amplitude = 10;

// Number of complete wave cycles.
Frequency = 4;  

// Total wave length in mm.
Length = 60;

// Height of the wave.
Height = 3.0;

// Thickness of the wave.
Thickness = 2.0;

// Phase shift to adjust start position.
Phase = 0; // [0:0.01:1]

/* [🔗 Extension] */

// Additional length beyond the waveform.
Extend = 0;

// Type of endcap applied to both ends of the waveform.
Endcaps = "round"; // [butt: None, round: Round, square: Square, line: Line, chisel: Chisel, cross: Cross, diamond: Diamond, dot: Dot, block: Block]

// Width of the endcaps as a multiple of the thickness (0 = auto).
Endcap_Width = 0;

// Length of the endcaps as a multiple of the thickness (0 = auto).
Endcap_Length = 0;

/* [Options: Square wave] */

// Softens square wave transitions.
Delta = 0; // [0:0.01:1]

/* [Options: Sine wave] */

// Type of wave interference applied.
Interference = "none"; // [constructive: Constructive, destructive: Destructive, none: None]

// Amplitude of the interfering wave.
Sub_Amplitude = 10;

// Frequency for the interfering wave.
Sub_Frequency = 1;

/* [Options: Pulse wave] */

// High-state duration for pulse waves.
Duty_Cycle = 0.3; // [0:0.01:1]

/* [Hidden] */

Debug = false;
Min_Angle = 3;
Resolution = ceil(Frequency * 180 / Min_Angle);

$fa = 2;
$fs = 0.2;

// Render
left(Length / 2)
wave();

/**
 * Generates a parametric waveform with optional interference and endcap extensions.
 *
 * This module supports various wave types including sine, square, triangle, sawtooth, 
 * and pulse waves. It allows fine-tuned control over amplitude, frequency, phase, 
 * and optional attachments like endcaps.
 *
 * @see https://en.wikipedia.org/wiki/Waveform
 *
 * @param type           Wave type: "sine", "square", "triangle", "sawtooth", or "pulse".
 * @param amplitude      Peak-to-trough height of the wave.
 * @param frequency      Number of full wave cycles within the total length.
 * @param phase          Phase shift, adjusting the starting position of the wave [0-1].
 * @param delta          Transition smoothing factor for square waves (0 = sharp edges).
 * @param length         Total length of the waveform in millimeters.
 * @param height         Extrusion height of the waveform.
 * @param thickness      Stroke width of the waveform profile.
 * @param resolution     Number of points used to construct the wave (higher = smoother).
 * @param interference   Type of wave interference: "constructive", "destructive", or "none".
 * @param sub_amplitude  Amplitude of the interfering secondary wave (if interference is enabled).
 * @param sub_frequency  Frequency multiplier for the interfering wave.
 * @param duty_cycle     High-state duration for pulse waves (0 = no pulse, 1 = full on).
 * @param extend         Additional length beyond the waveform for end attachments.
 * @param endcaps        Type of endcap applied at both ends: "round", "square", "diamond", etc.
 * @param endcap_width   Width of the endcap as a multiple of the waveform thickness (0 = auto).
 * @param endcap_length  Length of the endcap as a multiple of the waveform thickness (0 = auto).
 * @param debug          Enables debugging mode, displaying construction points.
 */
module wave(
    type = Type,
    amplitude = Amplitude,
    frequency = Frequency,
    phase = Phase, 
    delta = Delta,
    length = Length,
    height = Height,
    thickness = Thickness,
    resolution = Resolution, 
    interference = Interference,
    sub_amplitude = Sub_Amplitude,
    sub_frequency = Sub_Frequency,
    duty_cycle = Duty_Cycle,
    extend = Extend,
    endcaps = Endcaps,
    endcap_width = Endcap_Width > 0 ? Endcap_Width : undef,
    endcap_length = Endcap_Length > 0 ? Endcap_Length : undef,
    debug = Debug
) {
    waveform = 
        (type == "square") ? 
            square_wave(frequency, length, amplitude, resolution, phase, delta) :
        (type == "triangle") ? 
            triangle_wave(frequency, length, amplitude, resolution, phase) :
        (type == "pulse") ? 
            pulse_wave(frequency, length, amplitude, resolution, phase, duty_cycle) :
        (type == "sine") ?
            sine_wave(frequency, length, amplitude, resolution, phase, interference, sub_amplitude, sub_frequency) :
        (type == "sawtooth") ? 
            sawtooth_wave(frequency, length, amplitude, resolution, phase) :
            undef;
            
    assert(!is_undef(path), "Unkown wave type supplied.");
    
    start = waveform[0];
    end = waveform[len(waveform) - 1];
    
    path = path_merge_collinear([
        [start.x - extend, start.y],
        each waveform,
        [end.x + extend, end.y]
    ]);

    // Waveform stroke
    linear_extrude(height = height) {
        if (debug) {
            move_copies(path) circle(r = 0.2);
        } else {
            stroke(path,
                width = thickness,
                endcaps = endcaps,
                endcap_width = endcap_width,
                endcap_length = endcap_length,
            );
            // offset_stroke(path, width = thickness, closed = false);
        }
    }
}

function sine_wave(frequency, length, amplitude, resolution, phase = 0, interference = "none", sub_amplitude = 1, sub_frequency = 15) =
    let (
        points = [
            for (i = [0:1:resolution])
                let (
                    x = i * (length / resolution),
                    base_wave = amplitude * sin((x / length) * frequency * 360 + phase * 360),
                    interference_wave = (interference == "constructive") ? 
                        +sub_amplitude * sin((x / length) * sub_frequency * 360 + phase * 360) :
                        (interference == "destructive") ? 
                        -sub_amplitude * sin((x / length) * sub_frequency * 360 + phase * 360) :
                        0 // No interference
                ) 
                [x, base_wave + interference_wave]
        ],
        path = resample_path(points, spacing = 2, keep_corners = 3, closed = false)
    ) path;

function square_wave(frequency, length, amplitude, resolution, phase = 0, delta = 0, rounding = 0.5) =
    let (
        points = [
            for (i = [0:resolution])
                let (
                    x = i * (length / resolution),
                    angle = (x / length) * frequency * 360 + phase * 360,
                    y = delta > 0
                        ? amplitude * (atan(sin(angle) / delta) / atan(1 / delta))
                        : amplitude * sign(sin(angle))
                ) [x, y]
        ],
        path = resample_path(points, spacing = 2, keep_corners = 3, closed=false),
    ) path;
    
function triangle_wave(frequency, length, amplitude, resolution, phase = 0) =
    let (
        points = [
            for (i = [0:resolution])
                let (
                    x = i * (length / resolution),
                    angle = (x / length) * frequency * 360 + (phase + 0.25) * 360,
                    y = amplitude * (4 * abs((angle / 360) - floor(angle / 360 + 0.5)) - 1)
                ) [x, y]
        ],
        path = resample_path(points, spacing = 2, keep_corners = 30, closed=false)
    ) path;

function sawtooth_wave(frequency, length, amplitude, resolution, phase) =
    let (
        points = [
            for (i = [0:resolution])
                let (
                    x = i * (length / resolution),
                    angle = (x / length) * frequency * 360 + (phase + 0.5) * 360,
                    y = 2 * amplitude * ((angle / 360) - floor(angle / 360)) - amplitude
                ) [x, y]
        ],
        path = resample_path(points, spacing = 2, keep_corners = 30, closed=false)
    ) path;
    
function pulse_wave(frequency, length, amplitude, resolution, phase = 0, duty_cycle = 0) =
    let (
        points = [
            for (i = [0:resolution])
                let (
                    x = i * (length / resolution),
                    angle = (x / length) * frequency * 360 + phase * 360,
                    y = (angle % 360 < duty_cycle * 360) ? amplitude : -amplitude
                ) [x, y]
        ],
        path = resample_path(points, spacing = 2, keep_corners = 30, closed=false)
    ) path;