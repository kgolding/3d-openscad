// Metal shear magnetically attached fence

WIDTH = 100;
DEPTH = 155;
HEIGHT = 35;

FENCE_HEIGHT = 10;
FENCE_THICKNESS = 15;

BOLT_FROM_TOP = 21;
BOLTS = [[38, BOLT_FROM_TOP], [115,BOLT_FROM_TOP]];
BOLT_DIA = 21 + 2;
BOLT_HEIGHT = 8;

MAGNET_DIA = 20.5;
MAGNET_HEIGHT = 6.05;
MAGNETS = [
    [3 + MAGNET_DIA/2, BOLT_FROM_TOP],
    [BOLTS[0].x + BOLT_DIA/2 + MAGNET_DIA/2 + 4, BOLT_FROM_TOP],
    [BOLTS[1].x - BOLT_DIA/2 - MAGNET_DIA/2 - 4, BOLT_FROM_TOP],
    [DEPTH - 3 - MAGNET_DIA/2, BOLT_FROM_TOP],
];
SCREW_DIA = 5.5; // M4 Insert
SCREW_LEN = 15;

$fn = 50;

difference() {
    union() {
        // Body
        rotate([90,0,90]) linear_extrude(DEPTH) {
            polygon([
                [-WIDTH, 0], [0, 0], [0, -HEIGHT], [-20, -HEIGHT], [-WIDTH, -20]
            ]);
        }

        // Fence
        translate([0,-WIDTH,0]) cube([FENCE_THICKNESS, WIDTH, FENCE_HEIGHT]);
    }
    
    // Bolt holes
    for (p = BOLTS) {
        translate([DEPTH - p.x, 0.01, -p.y]) rotate([90,0,0]) cylinder(d=BOLT_DIA, h=BOLT_HEIGHT);
    }
    
    // Magnet holes
    for (p = MAGNETS) {
        translate([DEPTH - p.x, 0.01, -p.y]) rotate([90,0,0]) cylinder(d=MAGNET_DIA, h=MAGNET_HEIGHT);
        // Screwhole
        translate([DEPTH - p.x, 0.01, -p.y]) rotate([90,0,0]) cylinder(d=SCREW_DIA, h=MAGNET_HEIGHT + SCREW_LEN);
    }

}