// Skadis roundness holder

ROUNDS = [128.5 + 0.5, 115.5 + 0.5, 80 + 0.5];
ROUND_WIDTH = 10.5 + 0.5;

WIDTH = ROUND_WIDTH * len(ROUNDS); 
HEIGHT = 65;
DEPTH = ROUNDS[0];
FRONT_HEIGHT = 45;
WALL = 3;
TEXT = "Roundness gauges";
TEXT_SIZE = 8;

bt = (ROUND_WIDTH * len(ROUNDS)) + WALL * 2;
bw = ROUNDS[0] + 2 * WALL;
cr = FRONT_HEIGHT + tan(20) * bw;

$fn = 50;

*translate([0, WALL, WALL]) Mask();

difference() {
  body();
  // Mask
  translate([0, WALL, WALL]) Mask();
  // Text
  translate([bt/2 - 0.5, bw/2, (FRONT_HEIGHT)/2])
    rotate([90, 0, 90])
      linear_extrude(1)
        text(TEXT, halign="center", valign="center", size=TEXT_SIZE);
  translate([-bt/2 + 0.5, bw/2, (FRONT_HEIGHT)/2])
    rotate([90, 0, -90])
      linear_extrude(1)
        text(TEXT, halign="center", valign="top", size=TEXT_SIZE);
}

for (y = [20:40:HEIGHT]) translate([0,0,y]) hook();

module body() {  
  translate([-bt/2,0,0]) {
    difference() {
      cube([bt, bw, HEIGHT]);
      /* Angled mask
        2-----3
        |   5-4
        |   /
        |  /
        1-6
      */
      rotate([90,0,-90]) translate([-bw,0,-bt-1]) linear_extrude(bt+2) polygon([
        [-1,FRONT_HEIGHT],    // 1
        [-1, HEIGHT*2],       // 2
        [bw+1, HEIGHT*2],     // 3
        [bw+1, cr],           // 4
        [bw - WALL, cr],      // 5
//        [WALL, FRONT_HEIGHT], // 6
      ]);
      // Chamfered front edges
      translate([0, bw, FRONT_HEIGHT/2]) rotate([0,0,45]) cube([2,2,FRONT_HEIGHT+2], center=true);
      translate([bt, bw, FRONT_HEIGHT/2]) rotate([0,0,45]) cube([2,2,FRONT_HEIGHT+2], center=true);
    }
  }
}

module Mask() {
  translate([-WIDTH/2, ROUNDS[0], ROUNDS[0]])
  for (x = [0:1:len(ROUNDS)-1]) {
    translate([ROUND_WIDTH * x, -ROUNDS[x]/2, -ROUNDS[x]/2 - x * 10])
      rotate([0,90,0])
        translate([0,0,-0.01])
          cylinder(d=ROUNDS[x], h=ROUND_WIDTH + 0.01);
  }
}

module hook() {
  // t is the amount we reduce the width/height by to let it fit ok
  t = 0.1;
  // w = width
  w = 5;
  // wt is the width less the t
  wt = w - t * 2;
  // h is the hight less a bit to make it fit
  h = 15 - 0.3;
  // h2 is the height of the smaller part of the peg
  h2 = h - 5;
  // ht is the height less t
  ht = h - t;
  // d is the depth of the board
  d = 5;
  // 12 gives us enough facets to create a easy to print angle
  $fn = 6;

  translate([0, -d*2, -wt/2]) rotate([270, 90,0]) union() {
    // The larger part of the peg
    hull() {
      cylinder(d=wt, h=d + 0.3);
      // -0.3 is the taper applied to the face that makes contact with the back on the pegboard
      translate([ht-w, 0, 0]) cylinder(d=wt, h=d -0.3);
    }
    // The smaller part of the peg
    translate([0, 0, 0]) hull() {
      cylinder(d=wt, h = d * 2);
      translate([h2 - w - t * 2 ,0 ,0]) cylinder(d=wt, h=d * 2);
      };
  }
}
