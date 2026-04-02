// Radio charger stand

INSIDE_WIDTH = 100;
LENGTH = 160;
LOWER_INSIDE_HEIGHT = 60;
UPPER_INSIDE_HEIGHT = 45;
SHELF_LENGTH = LENGTH / 2;

WALL = 3;
t = 0.01;

w = WALL + INSIDE_WIDTH + WALL;
h = WALL + LOWER_INSIDE_HEIGHT + WALL + UPPER_INSIDE_HEIGHT;

// Sides
translate([0,w,0]) Side();
difference() {    
    translate([0,WALL,0]) Side();
    // Text
    s = 10;
    translate([LENGTH/2, 0.4, WALL + 2*s+3]) rotate([90,0,0]) linear_extrude(0.5) text("MOTOTRBO/HYTERA", halign="center", size=s);
    translate([LENGTH/2, 0.4, WALL + s]) rotate([90,0,0]) linear_extrude(0.5) text("Charging station", halign="center", size=s);
}

// Base
cube([LENGTH, w, WALL]);

// Shelf
translate([LENGTH - SHELF_LENGTH, 0 , WALL + LOWER_INSIDE_HEIGHT]) cube([SHELF_LENGTH, w, WALL]);

module Side() {
    r = 5;
    rotate([90,0,0]) linear_extrude(WALL) hull() {
        // Bottom
        square([LENGTH, 1]);
        // Front
        translate([r, WALL + LOWER_INSIDE_HEIGHT + WALL - r]) circle(r);
        // Back
        translate([LENGTH - r, WALL + LOWER_INSIDE_HEIGHT + WALL + UPPER_INSIDE_HEIGHT + WALL - r]) circle(r);
    }
}
