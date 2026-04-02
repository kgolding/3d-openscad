// Clamp rack 
// To be cut from 18 mm material

SELECT = "ALL"; // ["ALL", "MAIN", "TOP", "BRACKET"]

QTY_CLAMPS = 4;
SPACING = 50;
DEPTH = 120;
DEPTH2 = 35;
SLOT_WIDTH = 10;
SLOT_DEPTH = 30;
THICKNESS = 18.5; // OSB is a little over 18
ROUNDING = 5;

assert(ROUNDING <= SLOT_WIDTH / 2);

w = QTY_CLAMPS * SPACING;
tiny = 0.01;
$fn=30;

if (SELECT == "ALL") {
  Rack(DEPTH);
  color("green") translate([0,0,THICKNESS]) Rack(DEPTH2);
  color("blue") {
    Bracket(40);
    translate([w-THICKNESS,0,0]) Bracket(40);
  }
} else if (SELECT == "MAIN") {
  Rack(DEPTH);
} else if (SELECT == "BRACKET") {
  Bracket(40);
} else {
  Rack(DEPTH2);
}

module Rack(d) {
  difference() {
    hull() {
      // Back
      translate([0,d-1,0]) cube([w,1,THICKNESS]);
      translate([ROUNDING, ROUNDING, 0]) cylinder(r=ROUNDING,h=THICKNESS);
      translate([w-ROUNDING, ROUNDING, 0]) cylinder(r=ROUNDING,h=THICKNESS);
      
    }
    for(c = [0:QTY_CLAMPS-1]) {
      translate([SPACING/2 + c*SPACING - SLOT_WIDTH/2, -tiny, -tiny]) {
        // sphere(3);
        cube([SLOT_WIDTH, SLOT_DEPTH - SLOT_WIDTH/2, THICKNESS+2*tiny]);
        translate([SLOT_WIDTH/2, SLOT_DEPTH - SLOT_WIDTH/2, 0]) cylinder(d=SLOT_WIDTH, h=THICKNESS+2*tiny);
        difference() {
          translate([-ROUNDING,-ROUNDING,0]) cube([2*ROUNDING,2*ROUNDING,THICKNESS+2*tiny]);
          translate([-ROUNDING,ROUNDING,0]) cylinder(d=SLOT_WIDTH, h=THICKNESS+2*tiny);
        }
        difference() {
          translate([ROUNDING,-ROUNDING,0]) cube([2*ROUNDING,2*ROUNDING,THICKNESS+2*tiny]);
          translate([SLOT_WIDTH+ROUNDING,ROUNDING,0]) cylinder(d=SLOT_WIDTH, h=THICKNESS+2*tiny);
        }
      }
    }
  }
}

module Bracket(h=40) {
  translate([0,DEPTH,0]) rotate([-90,0,-90]) hull() {
    // Top
    cube([DEPTH-SLOT_DEPTH,tiny,THICKNESS]);
    // Back
    cube([tiny, h,THICKNESS]);
    translate([DEPTH-SLOT_DEPTH-ROUNDING,ROUNDING,0]) cylinder(r=ROUNDING,h=THICKNESS);
    // translate([ROUNDING,h-ROUNDING,0]) cylinder(r=ROUNDING,h=THICKNESS);
  }
}