TERM_WIDTH = 50.8 + 0.5;
TERM_DEPTH = 11.4;
TERM_HEIGHT = 14.3;
TERM_SCREW_HEIGHT = 6.5;

CRIMP_LENGTH = 16;
WIRE_HOLE_SIZE = 8;

WALL = 2;
SIDE_WALL = 1.5;

difference() {
  union() {
    translate([-SIDE_WALL, -1, 0.001]) cube([TERM_WIDTH + 2*SIDE_WALL, TERM_DEPTH + CRIMP_LENGTH + WALL, TERM_HEIGHT + WALL]);
    // Tab
    translate([TERM_WIDTH,2,0]) difference() {
      hull() {
        cube([2, TERM_DEPTH-2, 1]);
        cube([11, 1, 1]);
        translate([11-4, TERM_DEPTH-2-4, 0]) cylinder(r=4, $fn=20);
      }
      translate([6.1,8-2,0]) cylinder(d=4.2, h=5, $fn=20);
    }
    // Tab side
    translate([TERM_WIDTH + SIDE_WALL,2+1,1])
      rotate([90,0,0]) linear_extrude(1) polygon([[0,0], [9.5,0], [0,6]]);
  }
  translate ([0,-0.01,0]) MASK();
  translate([1,-1,-TERM_SCREW_HEIGHT]) cube([TERM_WIDTH-2, 2, TERM_HEIGHT]);
}


module MASK() {
  // Case
//  translate([-19, -50+0.01, 0]) cube([TERM_WIDTH + 11 + 19, 50, 35]);

  hull() {
    // Terminals
    cube([TERM_WIDTH, TERM_DEPTH+2, TERM_HEIGHT]);
    // Crimps
    translate([2, TERM_DEPTH, 0]) cube([TERM_WIDTH-4, CRIMP_LENGTH, TERM_HEIGHT]);
  }
  // Wire
  translate([2, TERM_DEPTH + CRIMP_LENGTH - WIRE_HOLE_SIZE, 0]) cube([TERM_WIDTH-4, WIRE_HOLE_SIZE + WALL + 0.001, TERM_SCREW_HEIGHT]);
  
  // Adj pot
  translate([-8, 0,0]) cube([8.001, TERM_DEPTH, 10]);
}
