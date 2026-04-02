
THICKNESS = 2.5;
WIDTH = 20;
FLAT = 22;
OUT = 15;

$fn=20;

SCREW_DIA = 3.2;
difference() {
  rotate([90,0,0]) linear_extrude(WIDTH) offset(-10) offset(10) {
    square([FLAT, THICKNESS]);
    hull() {
      translate([FLAT,0]) square([0.01, THICKNESS]);
      translate([FLAT*2,OUT]) circle(d=THICKNESS);
    }
  }
  
  translate([FLAT/3-1,-WIDTH/4,0]) ScrewHole(THICKNESS);
  translate([FLAT/3*2-1,-WIDTH/4*3,0]) ScrewHole(THICKNESS);
}

module ScrewHole(t) {
  translate([0,0,-0.01]) cylinder(d=SCREW_DIA,h=t+0.02);
  translate([0,0,t-SCREW_DIA/2+0.01]) cylinder(r1=SCREW_DIA/2,r2=SCREW_DIA,h=SCREW_DIA/2);
}


*linear_extrude(WIDTH)  {
  square([FLAT, THICKNESS]);
  translate([FLAT,0]) rotate(25) offset(-10) offset(10) square([FLAT, THICKNESS]);
}

*difference() {
  union() {
    cube([FLAT, WIDTH, THICKNES]);
    translate([FLAT,0,0]) rotate([0,-15,0]) cube([FLAT, WIDTH, THICKNES]);
  }
}
