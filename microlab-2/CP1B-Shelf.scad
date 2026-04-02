include <microlab-2.scad>

SupportThickness = 2;
ShelfThickness = 2.55;

FLANGE_THICKNESS = 1.15;
FLANGE_DEPTH = 9;
FLANGE_LENGTH = 94.5;
FLANGE_TOTAL_WIDTH = 89;
OFFSET = 19;

$fn = 80;

// Shift all back so we can see the axis
translate([0,5,0]) {
    FrontPlate(1, showRear=false, openFace=true, halign="inside-right") {
        Shelf(shelfThickness=ShelfThickness, supportThickness=SupportThickness);
    }

    %translate([-FLANGE_TOTAL_WIDTH -SupportThickness -OFFSET , -6, ShelfThickness]) cube([FLANGE_TOTAL_WIDTH, FLANGE_LENGTH, FLANGE_THICKNESS]);


    /*
                    ┌──────────────────────────────┐            
                    │                              │            
                    │                              │            
                    │                              │            
             q      │                              │            
        1─────────2 │                              │ ──────────│
       h│     4─f─3 │                              │ │───      │
        0─────5  ───────────────────────────────────── │──────│
           a

    Edit/view: https://cascii.app/93fb7
    */
    a = 6;
    h = 5;
    f = FLANGE_DEPTH/2;
    q = a + f;
    w = FLANGE_TOTAL_WIDTH + 2*f;

    points = [
        [-5,0],
        // 0    1       2       3                           4                       5
        [0,0], [0,h], [q,h], [q,FLANGE_THICKNESS + 0.25], [q-f, FLANGE_THICKNESS], [q-f, -0],
        [q-f+5,0], [q-f+5,-1], [-5,-1]
    ];

    // Left
    translate([-w -OFFSET -SupportThickness +1.5, FLANGE_LENGTH, ShelfThickness]) rotate([90,0,0])
          translate([0,0,4])
              linear_extrude(FLANGE_LENGTH) offset(0.5) offset(-1) offset(0.5) polygon(points);

    // Right
    translate([-OFFSET -SupportThickness +a + 1 , 0, ShelfThickness]) rotate([90,0,180])
          translate([0,0,-4]) linear_extrude(FLANGE_LENGTH) offset(0.5) offset(-1) offset(0.5) polygon(points);
          
//    // Stop
//    #translate([-w -OFFSET -SupportThickness , -4 +FLANGE_LENGTH , ShelfThickness]) cube([w, 4, FLANGE_THICKNESS + 1]);
}