// 3D Printed Yagi
// Inspired from https://www.thingiverse.com/thing:3887195

Frequency_MHz = 868.5;
Element_Count = 4; // [2:6];
Feeder_Diameter = 4.5;
Folded_Dipole = false;
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
Dipole_Test = false;

// Minimum wall thickness where theres a hole behind external flat surface
Minimum_Wall_Thickness = 0.8;

Folded_Dipole_Gap = 5;

// For two colour printing
Text_Inlay_Only = false;

/* [Hidden] */
// This constants are from lots of research on the Internet and help from ChatGPT
lengthFactors = [0.52, 0.485, 0.44, 0.43, 0.42, 0.41];
spacingFactors = [0.2, 0.15, 0.15, 0.15, 0.15, 0.15];

// Create arrays of element lengths and spacing based on the wavelength anf the above constants
elements = [for(i=[0:Element_Count-1]) wavelength * lengthFactors[i]];
spacing = [for(i=[0:Element_Count-2]) wavelength * spacingFactors[i]];
  
echo("Element lengths", elements);
echo("Element spacing", spacing);

assert(len(elements) == len(spacing)+1, "There must be one less spacing than there are elements");

WireDiaWithClearence = Wire_Diameter + Wire_Diameter_Clearance;
t = (WireDiaWithClearence+Minimum_Wall_Thickness) * 2 + (Folded_Dipole ? Folded_Dipole_Gap : 0);
r = 6;
externalCornerRadius = 5;
tiny = $preview ? 0.001: 0;

$fn=30;

assert(Feeder_Diameter + Minimum_Wall_Thickness < t, "Coax diameter is too big for the body thickness");

x_positions = calculate_x_positions(spacing);
echo("Elements postions from relector", x_positions);

lastElement = elements[len(elements)-1];
boomLength = x_positions[len(x_positions)-1];
 
TopPoints = [for (i = [0:len(elements)-1]) [x_positions[i], elements[i]/2]];
BotPoints = [for (i = [0:len(elements)-1]) [x_positions[i], -elements[i]/2]];

bodyTopLeft = [-t/2-externalCornerRadius/2, elements[0]/2];
bodyTopRight = [boomLength+t/2+externalCornerRadius/2, lastElement/2];
bodyBottomRight = [boomLength+t/2+externalCornerRadius/2, -lastElement/2];
bodyBottomLeft = [-t/2-externalCornerRadius/2, -elements[0]/2];

// Body polygon points
points = concat(
  [bodyTopLeft],
  TopPoints,
  [bodyTopRight],
  [bodyBottomRight],
  reverse(BotPoints),
  [bodyBottomLeft]
);

if (!Text_Inlay_Only) {
  difference() {
    union() {
      Frame();
      if (Mounting == "H") {
        Handle();
      } else if (Mounting == "R") {
        MountingBar();
      } else if (Mounting == "B") {
        MountingBolt();
      }
    }
    CoaxConnectionMask(Feeder_Diameter);
  }
} else {
  // The text for two colour printing
  Text();
}

if (Wire_Size_Gauge) {
  translate([-100,0,0])
    WireSizeTest(1,3);
}

if (Dipole_Test) {
  translate([-200,0,0])
    DipoleTest(173, 2, 179);
}

module CoaxConnectionMask(dia) {
  bo = Folded_Dipole ? t-Minimum_Wall_Thickness-dia-Minimum_Wall_Thickness : 0;
  translate([spacing[0],0,bo]) {
    linear_extrude(t+tiny, center=true) offset(2) offset(-2) square([t,t*2], center=true);
  }
  
  co = Folded_Dipole ? t/2-dia/2-Minimum_Wall_Thickness : 0;
  translate([0,0,co]) {
    x = t+dia*2;
    translate([x,0,0]) rotate([0,90,0]) cylinder(d=dia,h=spacing[0]-x+tiny*2);
    translate([x,0,0]) rotate([0,45,90]) translate([-10,0,0]) rotate_extrude(angle=90) translate([10,0]) circle(d=dia);
  }
}

module Handle() {
  x = 50;
  y = 100;
  w = 12;
  h = 8;
  r = 10;
  translate([bodyTopLeft.x-x,-t/2-y/2,-t/2]) {
    difference() {
      cube([x,y,t]);
      rotate([0,0,90]) Rounding(r);
      translate([0,y,0]) rotate([0,0,0]) Rounding(r);
      translate([w,h,-tiny]) linear_extrude(t*2) hull() {
        translate([r, y-h*2-r]) circle(r);
        translate([x-w-r, y-h*2-r]) circle(r);
        translate([x-w-r, r]) circle(r);
        translate([r, r]) circle(r);
      }
    }
    // Fillets
    translate([x, 0, t/2]) rotate([0,0,-90]) Rounding(r, h=t);
    translate([x, y, t/2]) rotate([0,0,180]) Rounding(r, h=t);
  }
}

module MountingBar() {
  poleDia = Mounting_Bar_U_Bolt_Pole_Diameter;
  holeDia = Mounting_Bar_Hole_Diameter;
  x = poleDia + holeDia + Mounting_Bar_Distance_Pole_Reflector - poleDia/2;
  y = 20;
  w = 12;
  r = 10;
  holeOffset = 5 + holeDia;
  
  // Work from the bottom left of the mounting bar
  translate([bodyTopLeft.x-x,-y/2,-t/2]) {
    difference() {
      union() {
        cube([x,y,t]);
        // Fillets
        translate([x, 0, t/2]) rotate([0,0,-90]) Rounding(r, h=t);
        translate([x, y, t/2]) rotate([0,0,180]) Rounding(r, h=t);
        // U Bolt block
        blockW = holeOffset+poleDia+holeDia/2+holeOffset;
        translate([0,0,t]) cube([blockW, y, t]);
        // U Bolt block fillet
        translate([blockW, y/2, t]) rotate([-90,0,0]) Rounding(t, h=y);
      }
      // Rounding
      translate([0, 0, t/2]) rotate([0,0,90]) Rounding(r, h=t*4);
      translate([0, y, t/2]) Rounding(r, h=t*4);

      // U Bolt holes
      translate([holeOffset-holeDia/2,y/2,-tiny]) cylinder(d=holeDia, h=t*3);
      translate([holeOffset+poleDia+holeDia/2,y/2,-tiny]) cylinder(d=holeDia, h=t*3);
      // Mounting pole cut out
      translate([holeOffset + poleDia/2,y/2,t + poleDia/2])
        rotate([90,0,0])
          cylinder(d=poleDia, h=y+tiny*2, center=true);
    }
  }
}

module MountingBolt() {
  holeDia = Mounting_Bar_Hole_Diameter;
  x = holeDia + Mounting_Bar_Distance_Pole_Reflector;
  y = 20;
  w = 12;
  r = 10;
  holeOffset = 5 + holeDia;
  
  // Work from the bottom left of the mounting bar
  translate([bodyTopLeft.x-x,-y/2,-t/2]) {
    difference() {
      union() {
        cube([x,y,t]);
        // Fillets
        translate([x, 0, t/2]) rotate([0,0,-90]) Rounding(r, h=t);
        translate([x, y, t/2]) rotate([0,0,180]) Rounding(r, h=t);
      }
      // Rounding
      translate([0, 0, t/2]) rotate([0,0,90]) Rounding(r, h=t*4);
      translate([0, y, t/2]) Rounding(r, h=t*4);

      // U Bolt holes
      translate([holeOffset-holeDia/2,y/2,-tiny]) cylinder(d=holeDia, h=t*3);
    }
  }
}

module Text(h=0.4) {
  translate([spacing[0]/2 + t/2,0,t/2-h+tiny])
    linear_extrude(h)
      color("orange") 
        text(str(Frequency_MHz, " MHz"), size = 6, halign="center", valign="center");
}  

module Frame() {
  difference() {
    // Square body
    linear_extrude(t, center=true) polygon(points);

    Text();
    
    // Wires
    for (i = [0:len(elements)-1]) {
      if (Folded_Dipole && i == 1) {
        translate([x_positions[i], 0, WireDiaWithClearence/2 + Folded_Dipole_Gap/2]) rotate([90,0,0]) cylinder(d=WireDiaWithClearence, h=elements[i]*2, center=true);
        translate([x_positions[i], 0, -WireDiaWithClearence/2 - Folded_Dipole_Gap/2]) rotate([90,0,0]) cylinder(d=WireDiaWithClearence, h=elements[i]*2, center=true);
        for(m=[0:1])
          mirror([0, m*180,0])
            for(j=[0:0.4:3])
              translate([x_positions[i], elements[i]/2 - t/2+WireDiaWithClearence/2 + j, 0])
                rotate([0,90,0]) union() {
                  rotate_extrude(angle=180) translate([t/2-Minimum_Wall_Thickness*2,0]) circle(d=WireDiaWithClearence);
                }
      } else {
        translate([x_positions[i], 0, 0]) rotate([90,0,0]) cylinder(d=WireDiaWithClearence, h=elements[i]*2, center=true);
      }
    }
    
    // Rounded corners
    translate(bodyTopLeft) Rounding(externalCornerRadius);
    translate(bodyTopRight) rotate([0,0,-90]) Rounding(externalCornerRadius);
    translate(bodyBottomRight) rotate([0,0,180]) Rounding(externalCornerRadius);
    translate(bodyBottomLeft) rotate([0,0,90]) Rounding(externalCornerRadius);
    
    // Holes
    for (i = [0:len(spacing)-1]) {
      left = x_positions[i] + t/2 + r;
      right =  x_positions[i+1] - t/2 - r;
      bottom = t+r;
      topLeft = elements[i]/2 - t - r;
      topRight = elements[i+1]/2 - t - r;
      for(m=[0:1]) {
        mirror([0, m*180,0])
          hull() {
            translate([left,bottom,0]) cylinder(r=r, h=t*2, center=true);
            translate([right,bottom,0]) cylinder(r=r, h=t*2, center=true);
            translate([left,topLeft,0]) cylinder(r=r, h=t*2, center=true);
            translate([right,topRight,0]) cylinder(r=r, h=t*2, center=true);
          }
      }
    }
  }
}

module DipoleTest(start=160, step=4, end=174) {
  for (x=[start:step:end])
    translate([-(x-start)/step*20, 0, 0])
      difference() {
        union() {
          cube([8,x,10], center=true);
          translate([-6.4,0,0]) rotate([0,-90,0]) linear_extrude(5, center=true, scale=0.8) square([10,30], center=true);
        }
        translate([0,0,Feeder_Diameter/2-1]) rotate([0,-90,0]) cylinder(d=Feeder_Diameter,h=20, center=true);
        translate([tiny,0,Feeder_Diameter-1]) cube([8,20,10+tiny*2], center=true);
        translate([3.5,x/4,0]) rotate([90,0,90]) linear_extrude(1) text(str(x), size = 7, valign="center");
        union() {
          translate([0, 0, WireDiaWithClearence/2 + Folded_Dipole_Gap/2]) rotate([90,0,0]) cylinder(d=WireDiaWithClearence, h=x*2, center=true);
          translate([0, 0, -WireDiaWithClearence/2 - Folded_Dipole_Gap/2]) rotate([90,0,0]) cylinder(d=WireDiaWithClearence, h=x*2, center=true);
          for(m=[0:1])
            mirror([0, m*180,0])
              for(j=[0:0.4:3])
                translate([0, x/2 - t/2+WireDiaWithClearence/2 + j, 0])
                  rotate([0,90,0]) union() {
                    rotate_extrude(angle=180) translate([t/2-Minimum_Wall_Thickness*2,0]) circle(d=WireDiaWithClearence);
                  }
         }
      }
}

module WireSizeTest(start=1,end=3,step=0.1) {
  qty = (end - start) / step;
  w = 20;
  h = qty * 5 + 10;
  translate([-w/2,-h/2,0])
    difference() {
      linear_extrude(10, center=true) offset(2) offset(-2) square([w, qty*5+10]);
      for(i=[0:1:qty]) {
        d = start + i * 0.1;
        x = 5 + i * 5;
        translate([5, x, 0]) cylinder(d=d,h=20,center=true);
        translate([9, x, 4.5]) linear_extrude(1) text(str(d), size=4, valign="center");
      }
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
