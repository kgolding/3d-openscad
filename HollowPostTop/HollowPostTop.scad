// Square tube cap

INSIDE = 80;
OVERHANG = 5;
ROUNDING = 3;
FIN = 6;
FIN_EXTRA = 1;
FIN_THICKNESS = 1.6;

top = INSIDE + 2*OVERHANG;

$fn = 30;

// Top
translate([0,0,-2]) hull() {
  linear_extrude(2)
    offset(ROUNDING) offset(-ROUNDING)
      square(top);
  translate([top/2, top/2, -20])
    linear_extrude(2)
      offset(2) offset(-2)
        #square(5, center=true);
}

// Bottom
translate([OVERHANG + FIN, OVERHANG + FIN, 0]) {
  cube([INSIDE - 2*FIN, INSIDE - 2*FIN, 40]);
//  difference() {
//    cube([INSIDE - 2*FIN, INSIDE - 2*FIN, 40]);
//    translate([5,5,0]) cube([INSIDE - 2*FIN - 10, INSIDE - 2*FIN - 10, 40+0.01]);
//  }
  translate([0,0,5]) {
    lw = INSIDE - 2*FIN;
    fins();
    translate([lw,0,0]) rotate([0,0,90]) fins();
    translate([lw, lw,0]) rotate([0,0,180]) fins();
    translate([0,lw,0]) rotate([0,0,270]) fins();
  }
}

module fins() {
  fx = FIN + FIN_EXTRA;
  mx = INSIDE - 2*FIN - fx;
  for (x = [0:mx/3:mx]) {
    difference() {
      translate([x,0,0]) linear_extrude(35) rotate(270) polygon([
        [0,0], [0,FIN_THICKNESS], [fx, fx], [fx,fx-FIN_THICKNESS]
      ]);
      translate([0,-fx,35]) rotate([45,0,0]) cube([INSIDE*2,fx,fx], center=true);
    }
  }
}