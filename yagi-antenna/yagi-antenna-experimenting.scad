// 3D Printed Yagi experimenting
// Inspired from https://www.thingiverse.com/thing:3887195

Frequency_MHz = 868.5;
Element_Count = 4; // [2:6];
Feeder_Diameter = 3;
Folded_Dipole = true;
Wire_Diameter = 1.6;
Wire_Diameter_Clearance = 0.4;

Mounting = "H"; // [N:None, H:Handle, R: "U-Bolt", B: "Bolt"]
/* [Mounting bar options] */
Mounting_Bar_Hole_Diameter = 8;
Mounting_Bar_U_Bolt_Pole_Diameter = 50;
Mounting_Bar_Distance_Pole_Reflector = 40; // [10:1:500]

// Dimensions from https://www.thingiverse.com/thing:3887195
// elements = [167, 164, 157, 156];
// spacing = [83,26,36];

wavelength = 300 / Frequency_MHz * 1000; // mm
echo("Wavelength", wavelength/2, "mm");

/* [Advanced] */
// Include a printable wire size gauge to measure wire of unknown diameter
Wire_Size_Gauge = false;
Dipole_Test = true;

// Minimum wall thickness where theres a hole behind external flat surface
Minimum_Wall_Thickness = 0.8;

Folded_Dipole_Gap = 5;

// For two colour printing
Text_Inlay_Only = false;

WireDiaWithClearence = Wire_Diameter + Wire_Diameter_Clearance;
t = (WireDiaWithClearence+Minimum_Wall_Thickness) * 2 + (Folded_Dipole ? Folded_Dipole_Gap : 0);
r = 6;
externalCornerRadius = 5;
tiny = $preview ? 0.001: 0;

$fn=30;

assert(Feeder_Diameter + Minimum_Wall_Thickness < t, "Coax diameter is too big for the body thickness");

if (!Text_Inlay_Only) {
  difference() {
    union() {
      Frame();
    }
  }
} else {
  // The text for two colour printing
  Text();
}

Elements();

Clip=8;
BW = 8;

module Frame() {
  holeDia = Mounting_Bar_Hole_Diameter;
  x = 240;
  y = Clip + 5*2;
  w = BW;
  r = 10;
  holeOffset = 5 + holeDia;
  
  difference() {
    hull() {
      cylinder(d=y, h=w, center=true);
      translate([x,0,0]) cube([1,y,w], center=true);
    }
    // Bolt holes
    translate([0,0,0]) cylinder(d=holeDia, h=w*2, center=true);
    // Slots
    translate([120,0,0]) cube([Clip,Clip,w*2], center=true);
    translate([65,0,0]) cube([80,Clip,w*2], center=true);
    translate([185,0,0]) cube([100,Clip,w*2], center=true);
    
    for (i=[-90:10:x-30-80]) {
      translate([10+i+110,y/2,0]) cylinder(d=1, h=w*2, center=true);
      translate([10+i+110+2.5,y/2-0.5]) rotate([-90,90,0]) linear_extrude(1) text(str(i/10), size=3, valign="center", halign="center");
    }
  }
}

module Elements(start=160, step=2, end=178) {
  for (x=[start:step:end])
    translate([(x-start)/step*25, end/2+30, 0])
      difference() {
        union() {
          cube([8,x,8], center=true);
          translate([-4-3/2,0,0]) rotate([0,-90,0]) cube([8,30,3], center=true);
          // Clip
          translate([-4-3,-Clip/2,-Clip/2]) rotate([0,-90,0]) cube([Clip,Clip,BW]);
          *translate([-4-3-BW,-Clip/2-1.5,-Clip/2]) rotate([0,-90,0]) cube([Clip,Clip+3,BW]);
        }
        
//        // Wedge
//        for(i=[0:1]) mirror([0,i*180,0])
//          translate([-4-3-2,2,-Clip/2-tiny]) hull() {
//            rotate([0,-90,0]) cylinder(d=3, h=BW+tiny*2);
////            cube([1,0.2,BW+tiny*2]);
////            translate([-BW,0,0]) cube([1,1.6,BW+tiny*2]);
//          }
        
        
        // Marks
        for(i=[0:1]) mirror([0,i*180,0])
          translate([-7, 10, WireDiaWithClearence/2]) rotate([90,0,0]) cylinder(d=1, h=12, center=true);
        
        // Feeder
        translate([0,0,Feeder_Diameter/2-1]) rotate([0,-90,0]) cylinder(d=Feeder_Diameter,h=50, center=true);
        
        translate([tiny,0,Feeder_Diameter-1]) cube([8,20,10+tiny*2], center=true);
        translate([3.5,x/4,0]) rotate([90,0,90]) linear_extrude(1) text(str(x), size = 7, valign="center");
        translate([0, 0, WireDiaWithClearence/2]) rotate([90,0,0]) cylinder(d=WireDiaWithClearence, h=x*2, center=true);
      }
}

module Rounding(r, h=t*2) {
   translate([0,0,tiny]) linear_extrude(h, center=true) {
    translate([r,-r])
      difference() {
        rotate(90) square(r+1);
        circle(r);
      }
  }
}
function calculate_x_positions(arr) = [for (i = [0:len(arr)]) sum(arr, i)];

function reverse(v) = [ for(i = [0:len(v)-1])  v[len(v) -1 - i] ]; 

// Returns sum of the arr elements up to but excluding maxIndex
function sum(arr, maxIndex, index = 0) =
    (index < maxIndex) ? arr[index] + sum(arr, maxIndex, index + 1) : 0;
