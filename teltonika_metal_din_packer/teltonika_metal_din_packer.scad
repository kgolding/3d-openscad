
W = 25;
SLOT = 2;
SLOT_DEPTH = 3;
SCREW_SPACING = 50;
SCREW_DIA = 4;
L = SCREW_SPACING + SCREW_DIA * 2;

PACKING_THICKNESS = 1.2;

assert(L < 70);

SCREW_OFFSET = (L - SCREW_SPACING)/2;

$fn=30;

difference() {
  union() {
    cube([W, L, PACKING_THICKNESS]);
    translate([W/2 - SLOT/2, SCREW_OFFSET + SCREW_DIA, - SLOT_DEPTH]) cube([SLOT, L - SCREW_OFFSET * 2 - SCREW_DIA * 2, SLOT_DEPTH]);
  }
  translate([W/2, SCREW_OFFSET, -1]) {
    cylinder(d=SCREW_DIA, h = 5);
    translate([0, SCREW_SPACING, 0]) cylinder(d=SCREW_DIA, h = PACKING_THICKNESS + 2);
  }
}
