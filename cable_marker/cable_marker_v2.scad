// Cable marker V2

// FAILED - The clips are small thin to print and break easy

CABLE_DIA = 5;
TEXT = "Cable 1";
WALL = 1;

TEXT_INLAY_ONLY = false;

h = CABLE_DIA + 2 * WALL;
w = CABLE_DIA + 3 * WALL;

LENGTH = 30;

$fn = 20;

MIN_WALL = 0.8;
ClipW = MIN_WALL;
ClipH = h/2 - 1;

//translate([20,0,0]) Half();

if (TEXT_INLAY_ONLY) {
  color("black") Label();
} else {
  difference () {
    union() {
      linear_extrude(LENGTH/5) Half();
      translate([0,0,LENGTH/5]) linear_extrude(LENGTH/5) rotate([0,180,0]) Half();
      translate([0,0,LENGTH/5 * 2]) linear_extrude(LENGTH/5) Half();
      translate([0,0,LENGTH/5 * 3]) linear_extrude(LENGTH/5) rotate([0,180,0]) Half();
      translate([0,0,LENGTH/5 * 4]) linear_extrude(LENGTH/5) Half();
    }
    //Label();
  }
}

module Label() {
  translate([0,-h/2 + 0.2,LENGTH/2])
    rotate([90,-90,0])
      color("black")
        linear_extrude(0.2)
          text("Cable 1", size = CABLE_DIA, valign="center", halign="center");
}

module Half() {
   translate([-w/2, -h/2]) difference() {
    Clip();
    translate([w,h]) rotate([0,0,180]) intersection() {
      Clip();
      translate([w/2,0]) square([w/2, h]);
    }
    translate([w/2, h/2]) circle(d=CABLE_DIA);
  }
}
/*
0                     1
----------------------|
|                     |
|                     |
|                     |
--------------------- | h/2
7                  6| |
                  5/  |     
                 4 \  | 
                    \ |
                    3-|2
*/
p3 = 0.8;
p4 = 1.0;
points = [
  [0,0],
  [w,0],
  [w,h-1],
  [w-p3,h-1],
  [w-p4,h-ClipH/4-1],
  [w-p3, h - ClipH/2 - 1],
  [w-p3, h/2],
  [0,h/2]
];

module Clip() {
  difference() {
    polygon(points);
    for (x = [0, w])
      translate([x,0]) rotate(-45) square(WALL, center=true);
  }
}


module Solid() {
  difference() {
    square([h,h], center=true);
    circle(d=CABLE_DIA);
  }
}
