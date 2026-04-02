// Tape measure mounting block for 40mm x 1.5mm galv

BAR_WIDTH = 40 + 0.5;
BAR_THICKNESS = 1.2 + 0.3;
SIDE_WIDTH = 10;
END_LENGTH = 20;
GAP = 7;
WALL = 3;

BLOCK_WIDTH = BAR_WIDTH + SIDE_WIDTH * 2;
BLOCK_LENGTH = END_LENGTH + BAR_WIDTH/2;

BLOCK_THICKNESS = GAP + BAR_THICKNESS + WALL;

SCREW_DIA = 4.3;

tiny = 0.01;
$fn = 20;

difference() {
  cube([BLOCK_WIDTH, BLOCK_LENGTH, BLOCK_THICKNESS]);
  ChamferVerticalCorners(BLOCK_WIDTH, BLOCK_LENGTH, BLOCK_THICKNESS);
  ChamferTopEdges(BLOCK_WIDTH, BLOCK_LENGTH, BLOCK_THICKNESS);
  // Bar slot
  translate([SIDE_WIDTH, -tiny, GAP]) cube([BAR_WIDTH, BLOCK_LENGTH - END_LENGTH, BAR_THICKNESS]);
  
  // Screw holes
  for (x=[BLOCK_WIDTH*0.2,BLOCK_WIDTH*0.8]) {
    translate([x, BLOCK_LENGTH - END_LENGTH/2, 0]) {
      translate([0,0,-tiny]) cylinder(d=SCREW_DIA,h=50);
      translate([0,0,BLOCK_THICKNESS-SCREW_DIA/2+tiny]) cylinder(r1=SCREW_DIA/2,r2=SCREW_DIA,h=SCREW_DIA/2);
    }
  } 
}

module ChamferVerticalCorners(x,y,z,size=2) {
  for (a=[0:x:x]) {
    for (b=[0:y:y]) {
      translate([a,b,0]) rotate([0,0,-45]) cube([size,size,z * 3], center=true);
    }
  }
}

module ChamferTopEdges(x,y,z,size=2) {
  for (a=[0:1]) {
    translate([a*x,y/2,z]) rotate([90,45,0]) cube([size,size,y], center=true);
    translate([x/2,a*y,z]) rotate([45,0,0]) rotate([0,90,0]) cube([size,size,x], center=true);
  }
}