// Course sieve

TOP_DIA = 120;
BOTTOM_DIA = 60;
HEIGHT = 80;
WALL = 2;

HOLE_SIZE = 1.65;
MIN_GAP = 1.5;

tiny = 0.001;
$fn = 60;

difference() {
    cylinder(r1=BOTTOM_DIA/2, r2 = TOP_DIA/2, h = HEIGHT);
    translate([0,0,-tiny]) cylinder(r1=BOTTOM_DIA/2 - 2*WALL, r2 = TOP_DIA/2 - 2*WALL, h = HEIGHT + 2*tiny);
}

difference() {
    // Bottom
    cylinder(r1=BOTTOM_DIA/2, h = 2);
    
    // Holes
    translate([0,0,-tiny]) linear_extrude(WALL + 2*tiny) concentric_circles(
        max_r = BOTTOM_DIA/2 - 2*WALL,
        circle_r = HOLE_SIZE/2,
        min_gap = MIN_GAP
    );
}


// Concentric circles with guaranteed minimum spacing
//
// Params:
//   max_r     : max radius for circle centers
//   circle_r  : radius of each circle
//   min_gap   : minimum edge-to-edge spacing between circles
//   include_center : add a circle at the origin
module concentric_circles(
    max_r,
    circle_r = 1,
    min_gap  = 1,
    include_center = true
) {
    min_cc = 2*circle_r + min_gap;   // minimum center-to-center distance

    // Center circle
    if (include_center)
        circle(r = circle_r);

    // Rings
    for (r = [min_cc : min_cc : max_r - circle_r]) {

        // circumference-based count, enforcing spacing
        circumference = 2 * PI * r;
        n = max(1, floor(circumference / min_cc));

        for (i = [0 : n-1]) {
            a = 360 * i / n;
            translate([r*cos(a), r*sin(a)])
                circle(r = circle_r);
        }
    }
}

