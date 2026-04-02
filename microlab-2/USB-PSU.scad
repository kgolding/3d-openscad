// https://www.amazon.co.uk/dp/B0F8QLDLBL

include <microlab-2.scad>

Thickness = 2;

WIDTH = 125;
HEIGHT = 34.1;
DEPTH = 79.4;
RADIUS = 10.5;

FRAME_TOP = 3;
FRAME_BOTTOM = 5;
FRAME_SIDE = 5;

$fn = 30;

difference() {
    FrontPlate(1, false, halign="center") {
        Shelf(shelfThickness=Thickness);
    }
    
    // Move to top of shelf
    translate([0,0,Thickness]) {        
        // Cutout
        cutout_width = WIDTH - 2 * FRAME_SIDE;
        cutout_height = HEIGHT - FRAME_TOP - FRAME_BOTTOM;
        translate([-cutout_width/2, 0.01, FRAME_BOTTOM]) 
            rotate([90,0,0]) linear_extrude(10) offset(2) offset(-2) square([cutout_width, cutout_height]);
    }
    
    // Text
//    translate([WIDTH_INSIDE,-3,22]) rotate([90,0,0]) linear_extrude(4) text("12V / 5V PSU", valign="center", halign="right");
   
};

// Move to top of shelf
translate([0,0,Thickness]) {
    for (m = [0:1]) mirror([m,0]) {
        difference() {
            // Holders
            holder_width = 4;
            holder_thickness = 4;
            holder_height = 12 + 4;        
            translate([-WIDTH/2 + holder_width - holder_thickness, DEPTH ,0])
                rotate([0,-90,0]) {
                    points = [
                        [0,7], [0,-15-20], [20, -15], [20,7],
                    ];
                    %for (i = [0:len(points)-1]) translate([points[i].x, points[i].y, 13]) text(str(i), size=1, halign="center");
                    linear_extrude(holder_width) polygon(points);
                }
            translate([-WIDTH/2,DEPTH,0]) Stop(true);
        }
            
    }
    // USB PSU
    %translate([-WIDTH/2,0,0])
            linear_extrude(HEIGHT) offset(RADIUS) offset(-RADIUS) square([WIDTH, DEPTH]);
    %translate([-WIDTH/2,DEPTH,0]) Stop(true);
}

translate([20,-4,20]) rotate([-90,0,0]) Stop();
translate([-20,-4,20]) rotate([-90,0,0])  Stop();
//%translate([0,-50,0]) {
//    Stop(true);
//    #sphere(2);
//}

// Stop creates the end stop that fits into the wings, and optional a mask
// version that is extended to allow the peg to fit in and slide
module Stop(mask=false) {
    //              5─────────────────────────────6
    //      b       │      f         ----/        │
    //    1───2    e│              /              │
    //    │   │     │           /                 │
    //    │  c│     │         /                   │
    //    │   │  d  │       /                     │
    //   a│   3─────4 ORG  /                      │
    //    │               |                       │
    //    │              /                        │
    //    │             |                         │
    //    │            /                          │
    //    │           |                           │
    //    │    g     /                            │
    //    0───────────────────────────────────────7
    
    a = 12;
    b = 3;
    c = 3;
    d = 4 + (mask ? 0 : 0.2); // Thickness of mating plate
    e = c + 4; // Keep e long as it has the pressure of the unit pushing on it
    f = RADIUS;
    g = b+d+f;
    top = a + e - c;
    
    points = [
        // 0    1       2       3        4            5          6          7
        [0,0], [0,a], [b,+a], [b,a-c], [b+d,a-c], [b+d,top], [b+d+f,top], [g,0],
    ];
    
    translate([-b-d,-a+c-1]) {
        %for (i = [0:len(points)-1]) translate([points[i].x, points[i].y, 13]) text(str(i), size=1, halign="center");
        linear_extrude(12 + (mask ? 0.25 : 0)) offset(mask ? 0 : 0.75) offset(mask ? 0 : -0.75) difference() {
            union() {
                polygon(points);
                if (mask) { // Extend to allow the catch to enter and slide
                    translate([0,-c-0.5]) square(b+d, c+0.5);
                }
            }
            translate([b+d+RADIUS,0]) circle(r=RADIUS);
        }
    }
}

