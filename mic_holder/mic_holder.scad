// MIC PCB Stack

QTY = 8;
PCB_THICKNESS = 1.6 + 0.1;
PCB_WIDTH = 43;
HOLE_DIA = 3;
HOLE_OFFSET = 4;
RADIOUS = 8;
DISTANCE_BETWEEN = 25;
WALL = 3;

L = QTY * (PCB_THICKNESS + DISTANCE_BETWEEN);
W = PCB_WIDTH + 2*WALL;
H = WALL + HOLE_OFFSET + HOLE_DIA;

$fn = 40;

difference() {
  // Body
  linear_extrude(H) {offset(10) offset(-10) square([W,L]);}
  for (i = [0:QTY-1]) {
    translate([HOLE_OFFSET, DISTANCE_BETWEEN/2 + (DISTANCE_BETWEEN + PCB_THICKNESS) * i, HOLE_OFFSET]) PCB();
  }
}

// translate([PCB_WIDTH + 10, 0,0]) PCB();

module PCB() {
  translate([0,PCB_THICKNESS, 0]) rotate([90,0,0]) difference() {
    linear_extrude(PCB_THICKNESS) {
      difference() {
        offset(RADIOUS/2) offset(-RADIOUS/2) square([PCB_WIDTH, PCB_WIDTH]);
      }
    }
    translate([HOLE_OFFSET, HOLE_OFFSET]) sphere(d=HOLE_DIA/2);
    translate([PCB_WIDTH-HOLE_OFFSET, HOLE_OFFSET]) sphere(d=HOLE_DIA/2);
    translate([PCB_WIDTH-HOLE_OFFSET, PCB_WIDTH-HOLE_OFFSET]) sphere(d=HOLE_DIA/2);
    translate([HOLE_OFFSET, PCB_WIDTH-HOLE_OFFSET]) sphere(d=HOLE_DIA/2);
  }
}