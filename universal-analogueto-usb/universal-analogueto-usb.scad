// Universal Analogue to USB

SHOW = "All"; // ["All", "Text"]

PCB_WIDTH = 53.6;
PCB_DEPTH = 34.6;
PCB_THICK = 1.6;

PCB_BELOW = 5.4 - PCB_THICK;
PCB_ABOVE = 4.1 - PCB_THICK;

WALL = 2.1;

USB_WIDTH = 10;
USB_HEIGHT = 4;

TERM_WIDTH = PCB_WIDTH;
TERM_DEPTH = 12.2;

CLIP_WIDTH = 12;
CLIP_HEIGHT = 9.5;
CLIP_THICK = 1.4;

TEXT_SIZE = 5;

CASE_SPLIT = 6.15;

EXTERNAL_HEIGHT = PCB_BELOW + PCB_THICK + PCB_ABOVE + 2 * WALL;
EXTERNAL_DEPTH = PCB_DEPTH + 2 * WALL;
EXTERNAL_WIDTH = PCB_WIDTH + 2 * WALL;

$fn = 30;

*translate([0,0,30]) {
    Body();
    PCB();
}


if (SHOW == "Text") {
    translate([0,0, EXTERNAL_HEIGHT]) rotate([180,0,0]) Text("top");
    translate([0,10,0]) Text("bottom");
} else {
    // Top
    translate([0,0, EXTERNAL_HEIGHT]) rotate([180,0,0]) {
        difference() {
            Body();
            translate([-1,-1,-100 + EXTERNAL_HEIGHT - CASE_SPLIT]) cube(100);
            Text("top");
        }
        Clips();
    }

    // Bottom
    translate([0,10,0]) union() {
        difference() {
            Body();
            translate([-1,-1, EXTERNAL_HEIGHT - CASE_SPLIT]) cube(100);
            Text("bottom");
            Clips();
        }
        // Lip for PCB below terms to sit on
        translate([WALL, WALL, WALL]) cube([PCB_WIDTH, 5, PCB_BELOW]);
        translate([WALL, WALL + PCB_DEPTH - 1.5, WALL]) cube([PCB_WIDTH, 1.5, PCB_BELOW]);
    }
}

module Text(side = "top") {
    t = 0.4;
    color("WHITE") {
        if (side == "top") {
            // Top face
            translate([0, 15.5, EXTERNAL_HEIGHT - t + 0.001]) {
                translate([WALL-0.5, 0, 0]) {
                    lm = [1,8,16,19,20]; // Long markers
                    nm = [17,18]; // No markers
                    for (i=[1:1:20]) {
                        x = 53 - i * 2.5 + (i > 10 ? -1.5 : 0);
                        l = len(search(i,nm)) > 0 ? 0: len(search(i,lm)) > 0 ? 3: 2;
                        translate([x,0,0]) {
                            cube([0.8, l, t]);
                            translate([3, 4, 0]) linear_extrude(t) rotate(90)
                            if (i == 1) {
                                text("1", size=TEXT_SIZE);
                            } else if (i == 8) {
                                text("8", size=TEXT_SIZE);
                            } else if (i == 16) {
                                text("16", size=TEXT_SIZE);
                            } else if (i == 18) {
                                // translate([-4, -1, 0]) text("x", size=6);
                            } else if (i == 19) {
                                translate([0,1.25,0]) text("GND", size=TEXT_SIZE);
                            }
                        }
                    }
                }
            }    
        } else {
            // Bottom
            translate([EXTERNAL_WIDTH/2, EXTERNAL_DEPTH/2, t - 0.001]) rotate([180,0,212]) translate([0,2,0]) linear_extrude(t) text("smc-gateway.com", size=TEXT_SIZE, halign="center", valign="center");
            translate([EXTERNAL_WIDTH/2, EXTERNAL_DEPTH/2, t - 0.001]) rotate([180,0,212]) translate([0,-4,0]) linear_extrude(t) text("ACC-16A-USB", size=TEXT_SIZE, halign="center", valign="center");
        }
    }
}

module Body() {
    rounding = 1;
    difference() {
        minkowski() {
            translate([rounding, rounding, rounding]) cube([EXTERNAL_WIDTH - 2 * rounding, EXTERNAL_DEPTH - 2 * rounding, EXTERNAL_HEIGHT - 2 * rounding]);
            sphere(rounding);
        }
        PCB();
    }
}

module Clips() {
    for (x=[WALL * 2, EXTERNAL_WIDTH - WALL * 2 - CLIP_WIDTH])
        translate([x, 0, 2 - 0.01]) {
            Clip();
            translate([0 + CLIP_WIDTH, EXTERNAL_DEPTH, 0]) rotate([0, 0, 180]) Clip();
        }
}

module Clip() {
    cube([CLIP_WIDTH, CLIP_THICK, CLIP_HEIGHT]);
//    #hull() {
//        cube([CLIP_WIDTH, CLIP_THICK, 0.1]);
//        translate([0,0, CLIP_HEIGHT-0.1]) cube([CLIP_WIDTH, CLIP_THICK*2, 0.1]);
//    }
    
    // cube([CLIP_WIDTH, CLIP_THICK, CLIP_HEIGHT]);
    LIP = 0.6;
    LIP_DIA = LIP * sqrt(2);
    translate([0, CLIP_THICK, 0]) rotate([45,0,0]) cube([CLIP_WIDTH, LIP, LIP]);
}

module PCB() {
    translate([WALL, WALL, WALL])  {
        cube([PCB_WIDTH, PCB_DEPTH, EXTERNAL_HEIGHT - 2*WALL]);
        // USB
        translate([-10+0.01, 27 - USB_WIDTH/2, PCB_BELOW/2]) rotate([0,90,0]) cube([USB_HEIGHT,USB_WIDTH,20], center=true);
        // Terminals
        translate([0, 0, PCB_BELOW + PCB_THICK]) cube([TERM_WIDTH, TERM_DEPTH, 10]);
        translate([0, 11.2, 0]) { // Shift PICO position
            // Reset (paperclip)
            translate([11.5, 13.8, -10+0.01]) cylinder(d=1.8,h=10);
            // LED
            translate([4.7, 16, -WALL-0.01]) cylinder(r2=1, r1=2, h=WALL+0.02);
        }
    }
}