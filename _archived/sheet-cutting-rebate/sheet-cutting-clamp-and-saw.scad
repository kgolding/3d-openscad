THICKNESS = 0.8 + 0.2;
WIDTH = 1.5;
LENGTH = 100 + 3;
BLADE_GAP = 20;
BLADE_SLOT = 2;
SIDE = 20;
END_WIDTH = 20;
TOTAL_WIDTH = END_WIDTH + 80;
HEIGHT = 20;
TOTAL_X = SIDE + BLADE_GAP + LENGTH + BLADE_GAP + SIDE;
INSERT_DIA = 5.6; // M4 Insert

$fn = 50;

// Clamp side
translate([0,0,0])
    difference() {
        Body();
        translate([-0.01, TOTAL_WIDTH - END_WIDTH - BLADE_SLOT, -0.01])
            cube([TOTAL_X + 0.02, BLADE_GAP + END_WIDTH + 0.01, HEIGHT + 0.02]);
    }

// Material side
translate([0,0,HEIGHT + 10])
    difference() {
        Body();
        translate([-0.1, -0.1, -1])
            cube([TOTAL_X + 0.2, TOTAL_WIDTH - BLADE_SLOT - END_WIDTH + 0.10001, HEIGHT + 2]);
    }


module Body() {
    difference() {
        cube([TOTAL_X, TOTAL_WIDTH, HEIGHT]);
        
        // Label
        translate([TOTAL_X/2, 10, HEIGHT - 0.2]) linear_extrude(0.5) text(str(WIDTH, " x ", THICKNESS, " mm, ", BLADE_SLOT, " mm kerf"), size=10, halign="center");
        
        // CUT SLOT
        translate([SIDE, TOTAL_WIDTH - BLADE_SLOT - END_WIDTH, -0.1])
            cube([BLADE_GAP + LENGTH + BLADE_GAP, BLADE_SLOT, HEIGHT + 0.2]);

        // MATERIAL
        translate([SIDE + BLADE_GAP, -0.1, HEIGHT/2])
            cube([LENGTH, TOTAL_WIDTH - SIDE + WIDTH, THICKNESS]);
        
        // MATERIAL PUNCH OUT HOLES
        for (q = [1:4])
        translate([SIDE + BLADE_GAP + (LENGTH/5*q), TOTAL_WIDTH + 0.01, HEIGHT/2])
            rotate([90,0,0]) cylinder(d=HEIGHT/2, h=END_WIDTH + 0.02);    
        
        // JOINING SCREWS
        for (q = [SIDE/2, TOTAL_X - SIDE/2])
        translate([q, TOTAL_WIDTH + 0.01, HEIGHT/2])
            rotate([90,0,0]) cylinder(d=INSERT_DIA, h=END_WIDTH + THICKNESS + 20 + 0.02);    

        // CLAMPING HOLES
        translate([SIDE + BLADE_GAP, 10, -0.01])
            linear_extrude(HEIGHT/2+THICKNESS+0.02) offset(5) offset(-5)
                square([LENGTH, TOTAL_WIDTH - END_WIDTH - 30]);
    }
}
