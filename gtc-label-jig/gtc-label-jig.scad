// GTX Label alignment jig

VERSION = "V1";

// GTC Bounding box
GTC_X = 88.1;
GTC_Y = 94.5;
GTC_Z = 33.5;

LABEL_HOLE_DIA_X = 2;
LABEL_HOLE_DIA_Y = 2.5;
LABEL_HOLE_SPACING = 8;
LABEL_HOLE_OFFSET_X = 4.9;
LABEL_HOLE_OFFSET_Y = 18.5;

WALL = 4;

GAP = 0.2;

BASE_X = WALL + GTC_X + WALL;
BASE_Y = WALL + GTC_Y + LABEL_HOLE_OFFSET_Y + (LABEL_HOLE_DIA_Y) + WALL;

BLOCK_Y = WALL + LABEL_HOLE_DIA_Y + LABEL_HOLE_OFFSET_Y;

$fn = 50;

r = WALL;

difference() {
    // Base
    cube([BASE_X, BASE_Y, 2 * WALL]);

    // GTC Cutout
    translate([WALL - GAP, WALL - GAP, WALL]) cube([GTC_X + 2*GAP, GTC_Y + GAP, WALL + 1]);
    
    // Text
    translate([BASE_X/2, BASE_Y/2 - 10, WALL - 0.8])
        linear_extrude(1) rotate(180) text("PRD-GTC", size=8, halign="center");
    translate([BASE_X/2, BASE_Y/2, WALL - 0.5])
        linear_extrude(1) rotate(180) text("Label aligner", size=8, halign="center");
    translate([BASE_X/2, BASE_Y/2 + 10, WALL - 0.8])
        linear_extrude(1) rotate(180) text(VERSION, size=8, halign="center");
}

translate([0, WALL + GTC_Y, 0]) {
    // Alignment block
    // cube([BASE_X, BLOCK_Y, WALL + GTC_Z]);
    hull() {
        cube([BASE_X, BLOCK_Y, WALL]);
        translate([r,0,WALL + GTC_Z - r]) rotate([-90,0,0]) cylinder(r=r, h=BLOCK_Y);
        translate([BASE_X - r,0,WALL + GTC_Z - r]) rotate([-90,0,0]) cylinder(r=r, h=BLOCK_Y);
    }

    // Pins
    translate([LABEL_HOLE_OFFSET_X, LABEL_HOLE_OFFSET_Y, WALL + GTC_Z]) {
        for (x = [LABEL_HOLE_SPACING:LABEL_HOLE_SPACING:GTC_Y - LABEL_HOLE_SPACING]) {
            // Dome topped pin
            translate([x,0,0.5]) hull() {
                for (y = [0,0.75]) translate([0,y,0]) {
                    sphere(LABEL_HOLE_DIA_X/2);
                    rotate([180,0,0]) cylinder(r=LABEL_HOLE_DIA_X/2, 1);
                }
            }
        }
    }
}
