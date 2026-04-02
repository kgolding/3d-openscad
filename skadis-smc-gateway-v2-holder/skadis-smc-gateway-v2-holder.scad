// RUT2XXOne Skadis holder
WIDTH = 106 + 0.5;
HEIGHT = 90 + 0.5;
THICKNESS = 32 + 0.5;
FRONT_HEIGHT = 30;
WALL = 3;
TEXT = "SMC Gateway";
ANGLE = 16;

bt = THICKNESS + 2 * WALL;
bw = WIDTH + 2 * WALL;
cr = FRONT_HEIGHT + tan(ANGLE) * bw;

$fn = 30;

difference() {
  body();
  // Mask
  translate([0, WALL + WIDTH, -12]) rotate([0,0,180]) GW2();
  // Text
  translate([bt/2 - 0.5, bw/2, FRONT_HEIGHT + (cr-FRONT_HEIGHT)/2 - 8])
    rotate([90, ANGLE, 90])
      linear_extrude(1)
        text(TEXT, halign="center", valign="top", size=10);
  translate([-bt/2 + 0.5, bw/2, FRONT_HEIGHT + (cr-FRONT_HEIGHT)/2 - 8])
    rotate([90, -ANGLE, -90])
      linear_extrude(1)
        text(TEXT, halign="center", valign="top", size=10);
}

translate([0,0,20]) hook();
translate([0,0,60]) hook();

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
        [-1, cr*2],       // 2
        [bw+1, cr*2],     // 3
        [bw+1, cr],           // 4
        [bw - WALL, cr],      // 5
        [WALL, FRONT_HEIGHT], // 6
      ]);
      // Chamfered front edges
      translate([0, bw, FRONT_HEIGHT/2]) rotate([0,0,45]) cube([2,2,FRONT_HEIGHT+2], center=true);
      translate([bt, bw, FRONT_HEIGHT/2]) rotate([0,0,45]) cube([2,2,FRONT_HEIGHT+2], center=true);
      // translate([bt/2, bw, 0]) rotate([45,0,0]) rotate([0,90,0]) cube([2,2,bt+2], center=true);
      //translate([bt/2, bw, FRONT_HEIGHT]) rotate([45,0,0]) rotate([0,90,0]) cube([2,2,bt+2], center=true);
    }
  }
}

module GW2() {
  lip = 5;
  lipw = 14.5;
  translate([-THICKNESS/2+lip,0,0]) {
    cube([THICKNESS - lip, WIDTH, HEIGHT]);
    translate([-lip, 0, lipw]) cube([lip + 0.1, WIDTH, HEIGHT - 2*lipw]);
    // Lights
    lw = 8;
    translate([-lip-10, 99.5-lw/2, 25]) cube([11,lw,20]);
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
