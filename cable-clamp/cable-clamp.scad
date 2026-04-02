CABLE_DIA = 7;
CABLE_QTY = 10;
SCREW_DIA = 3.3;

SPACING = 4.23333;
SCREW_W = SCREW_DIA + SPACING * 2;

BLOCK_W = SPACING + SCREW_DIA + SPACING + CABLE_DIA + SPACING + CABLE_DIA;

w = BLOCK_W * CABLE_QTY/2 + SPACING + SCREW_DIA + SPACING;
d = CABLE_DIA * 2;
h = 4 + CABLE_DIA + 4;

$fn = 20;

echo(str("Block width: ", BLOCK_W, " mm (fixing screw centers)"));

// FULL();

SQUISH_GAP = 1;

// Bottom
translate([0,100,0]) difference() {
  FULL();
  translate([-10,-10,(h - SQUISH_GAP)/2]) cube([w+20, d+20, h]);
}

// Top
translate([0,50,0]) difference() {
  FULL();
  translate([-10,-10,-1]) cube([w+20, d+20, (h + SQUISH_GAP)/2 + 1]);
}

module FULL() {
  difference() {
    W = BLOCK_W * CABLE_QTY / 2;
    for (x = [0 : BLOCK_W : W]) {
        translate([x,0,0 ]) BlockOfTwo(x == W);
    }
  }
}

module BlockOfTwo(NoCables=false) {
  KNOB = 0.75;
  W = NoCables ? SPACING + SCREW_DIA + SPACING : BLOCK_W;
  difference() {
    cube([W+0.01,d,h]);
    // Screwhole
    translate([SPACING + SCREW_DIA/2, d/2, -0.01]) {
      cylinder(d=SCREW_DIA, h=h+1);
      r=SCREW_DIA/2;
      translate([0,0,h-r+0.02]) cylinder(r1=r, r2=r*2, h=r);
    }
    if (!NoCables) {
      // Cable 1
      translate([BLOCK_W - CABLE_DIA/2, d/w, h/2]) rotate([90,0,0]) translate([0,0,-d/2]) cylinder(d=CABLE_DIA, h=d+1, center=true);
      // Cable 2
      translate([BLOCK_W - CABLE_DIA - SPACING - CABLE_DIA/2, d/w, h/2]) rotate([90,0,0]) translate([0,0,-d/2]) cylinder(d=CABLE_DIA, h=d+1, center=true);
    }
  }
  if (!NoCables) {
    // Cable 1 knob top
    translate([BLOCK_W - CABLE_DIA/2, d/w, h/2 + CABLE_DIA/2]) rotate([90,0,0]) translate([0,0,-d/2]) sphere(KNOB);
    // Cable 2 knob top
    translate([BLOCK_W - CABLE_DIA - SPACING - CABLE_DIA/2, d/w, h/2 + CABLE_DIA/2]) rotate([90,0,0]) translate([0,0,-d/2]) sphere(KNOB);
    // Cable 1 knob bottom
    translate([BLOCK_W - CABLE_DIA/2, d/w, h/2 - CABLE_DIA/2]) rotate([90,0,0]) translate([0,0,-d/2]) sphere(KNOB);
    // Cable 2 knob bottom
    translate([BLOCK_W - CABLE_DIA - SPACING - CABLE_DIA/2, d/w, h/2 - CABLE_DIA/2]) rotate([90,0,0]) translate([0,0,-d/2]) sphere(KNOB);
  }
}


