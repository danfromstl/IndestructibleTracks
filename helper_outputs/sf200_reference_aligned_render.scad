sqrt2 = sqrt(2);

translate([0, -20.76023532708862, 0])
    multmatrix([
        [-1 / sqrt2,  1 / sqrt2, 0, 0],
        [ 1 / sqrt2,  1 / sqrt2, 0, 0],
        [0,           0,         1, 0],
        [0,           0,         0, 1]
    ])
        import("C:/Users/danfr/Downloads/New folder/Reverse Engineering/Adapted Original - SF200.stl");
