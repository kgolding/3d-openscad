
// Bolts M4 x 8 mm

h = 23;
w = 106;
t = 8-5+1;
fixCenters = 78.5;
fixT = 4.2;

$fn = 30;

difference() {
  union() {
    difference() {
      // rotate([90,0,0]) linear_extrude(t) offset(4) offset(-4) square([w,h], center=true);
      cube([w,t,h], center=true);
      for (x=[-w/2,w/2]) for (z=[-h/2,h/2])
        translate([x,0,z]) rotate([0,45,0]) cube(t+0.01, center=true);
      }

    hookZ = 9;
    translate([-40,0,hookZ]) hook();
    translate([0,0,hookZ]) hook();
    translate([40,0,hookZ]) hook();
  }

  translate([-fixCenters/2,t/2,6]) fixing();
  translate([fixCenters/2,t/2,6]) fixing();
}

module fixing() {
  rotate([-90,0,0]) translate([0,0,-8+5-0.2]) cylinder(d=3.8, h=6);
//  pt = 5;
//  rotate([-90,0,0]) {
//    hull() {
//      cylinder(d=5, h=pt);
//      translate([0,5,0]) cylinder(d=6, h=pt);
//    };
//    translate([0,0,pt]) hull() {
//      cylinder(d=5, h=2);
//      translate([0,-2,0]) cylinder(d=5, h=2);
//    }
//  }
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