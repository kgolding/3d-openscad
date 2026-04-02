// Single gang multi-plate

ROWS = 2;
COLS = 3;
GAP = 1;

PLATE_HEIGHT = 86;
PLATE_WIDTH = 86;
BB_HEIGHT = 70;
BB_WIDTH = 70;
SCREW_SPACING = 60.3;
SCREW_DIA = 3.2;
SCREW_BORDER = 3;
ROUNDING = 3;

$fn = 40;

linear_extrude(18) difference() {
    offset(ROUNDING) offset(-ROUNDING) square([GAP + (PLATE_WIDTH + GAP) * COLS, GAP + (PLATE_HEIGHT + GAP) * ROWS]);
    translate([GAP, GAP]) for (r=[0:ROWS-1]) for (c=[0:COLS-1]) {
        translate([(PLATE_WIDTH + GAP) * c, (PLATE_HEIGHT + GAP) * r]) SinglePlateMask2D();
    }
}

module SinglePlateMask2D() {
    tab = SCREW_DIA + 2 * SCREW_BORDER;
    screwFromEdge = (PLATE_WIDTH - SCREW_SPACING)/2;
    offset(3.1) offset(-3.1) difference() {
        translate([(PLATE_WIDTH-BB_WIDTH)/2,(PLATE_HEIGHT-BB_HEIGHT)/2]) square([BB_WIDTH, BB_HEIGHT]);
        translate([PLATE_WIDTH/2,0])
        for (m=[0,1]) mirror([m,0]) hull() translate([-PLATE_WIDTH/2,0]) {
            translate([screwFromEdge, PLATE_HEIGHT/2]) circle(d=tab);
            translate([-1, PLATE_HEIGHT/2 - tab/2]) square([1, tab]);
        }
    }
    translate([screwFromEdge, PLATE_HEIGHT/2]) circle(d=SCREW_DIA);
    translate([PLATE_WIDTH - screwFromEdge, PLATE_HEIGHT/2]) circle(d=SCREW_DIA);
}