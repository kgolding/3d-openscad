// RIOLINK E1 stand

DIA = 76;
WALL = 6;
HEIGHT = 160;
SW = 40;

ScrewDia = 4.7;

$fn = 50;

// Base
Plate();

// Top
translate([0,0,HEIGHT - WALL]) difference() {
  Plate();
  // Holes
  #translate([0,-DIA - WALL,-0.1]) rotate([0,0,10]) {
    translate([18/2,0,0]) cylinder(d=ScrewDia, h = WALL + 0.2);
    translate([-18/2,0,0]) cylinder(d=ScrewDia, h = WALL + 0.2);
  }
}

// Back
difference() {
  translate([-DIA/2,0,0]) cube([DIA, WALL, HEIGHT]);
  // Cable hole
  translate([0, WALL+0.1, HEIGHT - WALL -  10]) rotate([90,0,0]) cylinder(d=15, h=WALL+0.2);
}

// Trigs
Trig();
translate([0,0,HEIGHT+WALL]) rotate([0,180,0]) Trig();

// Support
for (x = [-DIA/2, DIA/2-WALL]) translate([x, -WALL, 0]) cube([WALL, 10, HEIGHT]);


module Trig() {
  for (x = [-DIA/2, DIA/2-WALL]) translate([x, 0, WALL])
    rotate([0,270,180]) linear_extrude(WALL) polygon([
      [0,0], [0,SW], [SW,0]
    ]);
}

module Plate() {
  translate([0,-DIA - WALL,0]) {
    cylinder(d=DIA,h=WALL);
    translate([-DIA/2,0,0]) cube([DIA, DIA + WALL, WALL]);
  }
}




//DIA = 83.5 + 0.5;
//DEPTH = 9.5;
//WALL = 3;
//HEIGHT = 40;
//ANGLE = 15;
//
//OUTER_DIA = DIA + 2 * WALL;
//
//$fn = 80;
//
//difference () {
//  union () {
//    hull() {
//      translate([0,0,HEIGHT]) Disc();
//      translate([0,0,-50]) Disc();
//    }
//    translate([0,0,HEIGHT]) Top();
//  }
//  translate([-DIA, -DIA, -200]) cube([2 * DIA, 2 * DIA, 200]);
//}
//
//module Top() {
//  rotate([0,ANGLE,0]) difference () {
//    cylinder(d=OUTER_DIA, h = DEPTH + 1);
//    translate([0,0,1 + 0.01]) cylinder(d=DIA, h = DEPTH);
//  }
//}
//
//module Disc() {
//  rotate([0,ANGLE,0]) difference () {
//    cylinder(d=OUTER_DIA, h = 0.1);
//  }
//}