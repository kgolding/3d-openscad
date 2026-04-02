// Baldwin Boxall Back box

OUTSIDE = 134;
WALL = 5;
ROUNDING = 16;
DEPTH = 40;
SCREW_DIA = 3.5; // For M4 Screw
SCREW_X = 121;
SCREW_Y = 60;

PILLER_DIA = SCREW_DIA + 3;

$fn = 50;

//translate([150,0,0]) mask();

difference() {
    // Outside
    linear_extrude(DEPTH) rbox(OUTSIDE, OUTSIDE, ROUNDING);

    // Inside
    mask();
    
    // 20mm entry Top/Bottom
    // translate([OUTSIDE/2, OUTSIDE+ 0.01, DEPTH/2]) rotate([90,0,0]) cylinder(d=20, OUTSIDE + 1);
    // 20mm entry Sides
    // translate([-0.01, OUTSIDE/2, DEPTH/2]) rotate([90,0,90]) cylinder(d=20, OUTSIDE + 1);
    
    // Cable entry Sides (10mm)
    translate([-0.01, OUTSIDE/2, WALL + 10/2]) rotate([90,0,90]) cylinder(d=10, OUTSIDE + 1);

    // Side bolts M4
    translate([-0.01, (OUTSIDE-SCREW_Y)/2/2, DEPTH/2]) rotate([90,0,90]) cylinder(d=4.5, WALL+ 1);
    translate([-0.01, OUTSIDE - (OUTSIDE-SCREW_Y)/2/2, DEPTH/2]) rotate([90,0,90]) cylinder(d=4.5, WALL + 1);

}

module mask() {
    // Screw Pillers
    sx = (OUTSIDE - SCREW_X) / 2;
    sy = (OUTSIDE - SCREW_Y) / 2;
    
    translate([0,0,WALL]) linear_extrude(DEPTH) {
        offset(ROUNDING/2) offset(-ROUNDING/2) {
            difference() {
                // Body
                translate([WALL,WALL]) square(OUTSIDE - 2 * WALL);
                
                // Screw pillers            
                for (y = [sy,sy+SCREW_Y]) {
                    translate([sx, y]) circle(d=PILLER_DIA);
                    translate([sx + SCREW_X, y]) circle(d=PILLER_DIA);
                }    
            }
        }
        // Screw pillers holes
        for (y = [sy,sy+SCREW_Y]) {
            #translate([sx, y]) circle(d=SCREW_DIA);
            translate([sx + SCREW_X, y]) circle(d=SCREW_DIA);
        }    
    }
}

module rbox(x, y, r) {
    q = r/2;
    hull() {
        translate([q, q]) circle(d=r);
        translate([x-q, q]) circle(d=r);
        translate([x-q, y-q]) circle(d=r);
        translate([q, y-q]) circle(d=r);
    }
}