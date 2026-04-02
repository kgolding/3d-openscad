include <microlab-2.scad>

SupportThickness = 2;
ShelfThickness = 2.55;

DIN_SCREW_DIA = 4.3;

// Requires 2x M6 10mm Countersunk machine screws and 2x nuts

$fn = 80;

difference() {
    FrontPlate(1, showRear=false, openFace=true, halign="inside-left") {
        Shelf(shelfThickness=ShelfThickness, supportThickness=SupportThickness);
    }
    // DIN Rail mounting holes
    for (x =[15, ML2_FRAME_WIDTH_INSIDE-15-2]) {
        translate([x,48,-0.01]) {
            // Hole
            cylinder(d=DIN_SCREW_DIA, h=ShelfThickness+0.02);
            // Countersink
            cylinder(r1=DIN_SCREW_DIA, r2=DIN_SCREW_DIA/2, h=DIN_SCREW_DIA/2+0.02);
        }
    }
};
