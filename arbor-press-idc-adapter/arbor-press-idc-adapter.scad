// Arbor press adapter for IDC connectors

TYPE = "sqaure"; // ["round", "sqaure"]

PEG = 14.5;
PEG_LENGTH = 30;

IDC_X = 50;
IDC_Y = 6.5;
IDC_Z = 9.5 - 4;
IDC_PEG_X = 4.4 + 0.6;

WALL = 3;
LIFT = 3;

IDC_Y_OUTSIDE = WALL + IDC_Y + WALL;
t = 0.01;
$fn = 50;

if (TYPE == "round") {
    translate([0,0,-PEG_LENGTH/2]) rotate([0,0,45]) cylinder(d=PEG, h=PEG_LENGTH, center=true);
} else {
    translate([0,0,-PEG_LENGTH/2]) rotate([0,0,45]) cube([PEG, PEG, PEG_LENGTH], center=true);
}

difference() {
    bw = PEG * 1.5;
    
//    // Body
    hull() {
        translate([-IDC_X/2, -bw/2, 0]) cube([IDC_X, bw, t]);
        translate([-IDC_X/2, -IDC_Y_OUTSIDE/2, 0]) cube([IDC_X, IDC_Y_OUTSIDE, LIFT + WALL + IDC_Z]);
    }
    
    // Chamfer edges
    // Ends
    translate([-IDC_X/2, 0, LIFT + WALL + IDC_Z]) rotate([0,45,0]) cube([10, bw, 10], center=true);
    translate([IDC_X/2, 0, LIFT + WALL + IDC_Z]) rotate([0,45,0]) cube([10, bw, 10], center=true);

    // Inside
    translate([0, -IDC_Y/2, LIFT + WALL + IDC_Z]) rotate([30,0,0]) cube([IDC_X,2,5], center=true);
    translate([0, IDC_Y/2, LIFT + WALL + IDC_Z]) rotate([-30,0,0]) cube([IDC_X,2,5], center=true);


    // Connector mask
    translate([0,0, LIFT]) {
        // Connector mask
        translate([-IDC_X/2 - t, -IDC_Y/2, WALL]) cube([IDC_X + 2*t, IDC_Y, IDC_Z + t]);
        
        // Connector peg mask
        translate([-IDC_PEG_X/2, -bw/2, WALL]) cube([IDC_PEG_X, bw/2, IDC_Z + t]);
    }
}