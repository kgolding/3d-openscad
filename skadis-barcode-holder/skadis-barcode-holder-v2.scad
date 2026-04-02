// Barcode holder V2

WT = 43.5;
WB = 37;
T = 46;
D = 26.5;
LIP = 5;

WALL = 2;

WIDTH = WT + 2 * WALL;

SideAngle = sin((WT-WB)/2) * T;
echo(SideAngle);
echo(sin(SideAngle) * T);

//hull() {
//  translate([0,0,T]) linear_extrude(0.01) Top2D();
//  linear_extrude(0.01) Bot2D();
//}

//rotate([0,-45,0])
CBody();

module Mask(wall=0) {
  translate([0,0,-30]) cube([]);
  
}

module CBody() {
  difference() {
    hull() {
      // Bottom
      cube([D + 2*WALL, WB + 2*WALL, 0.01]);
      // Top
      translate([0,-(WT-WB)/2,T]) cube([D + 2*WALL, WT + 2*WALL, 0.01]);
    }
    hull() {
      // Bottom
      translate([WALL,WALL,-0.01]) cube([D,WB, 0.01]);
      // Top
      translate([WALL,WALL-(WT-WB)/2,T+0.01]) cube([D,WT, 0.01]);
    }
    // Front cutout
    hull() {
      // Bottom
      translate([D,WALL+LIP,-0.01]) cube([D,WB - 2*LIP,0.01]);
      // Top
      translate([D,WALL-(WT-WB)/2+LIP,T+0.01]) cube([D,WT - 2*LIP,0.01]);
    }
  }
}


module Top2D() {
  translate([0,-(WT+2*WALL)/2]) difference() {
    square([D + 2*WALL, WT + 2*WALL]);
    translate([WALL,WALL]) square([D,WT]);
    translate([D,WALL+LIP]) square([D,WT-2*LIP]);
  }
}

module Bot2D() {
  translate([0,-(WB+2*WALL)/2]) difference() {
    square([D + 2*WALL, WB + 2*WALL]);
    translate([WALL,WALL]) square([D,WB]);
    translate([D,WALL+LIP]) square([D,WB-2*LIP]);
  }
}


