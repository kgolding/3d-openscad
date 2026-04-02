// Pogo Clip

// Add a few mm for the pogo pins!
GAP = 11.5; // Screw terms are 8.5
PIN_COUNT = 3;
SPACING = 5.08;
PIN_DIA = 1.7; 
WALL = 2.5;
LABEL = "3x 5.08mm";
HINGE_DIA = 3.1;
SPRING_WIDTH = 4;
SPRING_LENGTH = 30;
HINGE_PIN_RETAINER_DIA = 0; // 1.9;
CABLE = "ties"; // ["holes", "ties"]
CABLE_DIA = 3;

jaw_width = (PIN_COUNT + 1) * SPACING;
jaw_length = SPRING_LENGTH * 2 + WALL * 2;

$fn = 50;

// Pogo pin side
union() {
  difference() {
    Side();
    SpringMask();
    // Pogo pins
    translate([SPACING,jaw_length - PIN_DIA/2 - 2,-0.1]) {
      for (x = [0:PIN_COUNT-1]) {
        translate([x * SPACING,0,0]) cylinder(d=PIN_DIA, h=WALL*2);
      }
    }
    if (CABLE == "holes") {
      for (p=[ [0,4],
                [jaw_width/4,jaw_length/5],
                [-jaw_width/4,jaw_length/5],]) {
        translate([jaw_width/2 + p.x,jaw_length-CABLE_DIA/2-2-PIN_DIA-p.y,-0.01]) {
          cylinder(d=CABLE_DIA, h = WALL*2);
          cylinder(r1=CABLE_DIA/2+WALL/3, r2=CABLE_DIA/2, h = WALL/3);
          translate([0,0,WALL - WALL/3+0.02]) cylinder(r2=CABLE_DIA/2+WALL/3, r1=CABLE_DIA/2, h = WALL/3);
        }
      }      
    } else if (CABLE == "ties") {
//      for (x=[0,1]) for(y=[0,1]) {
//        translate([jaw_width/4 + x*jaw_width/2,jaw_length-CABLE_DIA/2-2-PIN_DIA-6 -y*12,-0.01]) cylinder(d=CABLE_DIA, h = WALL*2);
//      }
      twidth= 3;
      theight = 1.6;
      tlenght = jaw_width/4;
      for (offset=[3 + PIN_DIA + 3, 3 + PIN_DIA + 3 + twidth*2]) {
        translate([jaw_width/2-tlenght/2,jaw_length-twidth/2-offset,WALL/2]) {
          translate([0,0,theight]) rotate([0,135,0]) cube([tlenght*2,twidth,theight]);
          translate([tlenght,0,theight]) rotate([0,-135,0]) mirror([1,0,0]) cube([tlenght*2,twidth,theight]);
          cube([tlenght,twidth,theight]);
        }
      }
    }
  }
  Hinge(false);
}

// Other side
translate([-jaw_width*2,0,0]) {
  difference() {
    Side();
    SpringMask();
    translate([jaw_width/2,jaw_length-3,0.4])
      rotate([180,0,90]) linear_extrude(0.5)
        text(LABEL, size = 5, halign="right", valign="center");
  }
  Hinge(true);
  // Location bumps
  translate([SPACING,jaw_length - PIN_DIA/2 - 2,WALL]) {
    for (x = [0:PIN_COUNT-1]) {
      translate([x * SPACING,0,0]) sphere(d=2.5);
    }
  }
}

translate([-jaw_width/2,jaw_length/2,0])  HingePin();

module HingePin() {
  difference() {
    cylinder(d=HINGE_DIA, h=jaw_width);
    if (HINGE_PIN_RETAINER_DIA > 0) {
      translate([-HINGE_DIA,0,(jaw_width - SPRING_WIDTH)/4/2])
        rotate([0,90,0])
          cylinder(d=HINGE_PIN_RETAINER_DIA,h=HINGE_DIA*2);
    }
  }
//  t = 1;
//  #translate([-HINGE_DIA/2 - t, -t/2,0]) cube([HINGE_DIA + t*2, t,t]);
}

module SpringMask() {
  p = 1.5;
  translate([jaw_width/2 - SPRING_WIDTH/2,jaw_length/2-SPRING_LENGTH,WALL-p+0.01]) cube([p,SPRING_LENGTH,p]);
}

module Hinge(alt = false) {
  w = HINGE_DIA + 6;
  h = GAP/2; // Center of pin
  
  // Slight larger holes on the inner hinge to allow the pin to pivot
  hd = alt ? HINGE_DIA : HINGE_DIA + 0.3;
  translate([jaw_width,-w/2 + jaw_length/2,WALL]) rotate([0,-90,0]) difference() {
    // Hinge rounded body
    hull() {
      // Angled not round for better 3D print finish
      translate([h+HINGE_DIA/2+2,w/2-HINGE_DIA/2,0]) cube([0.01, HINGE_DIA, jaw_width]);
      translate([h+HINGE_DIA/2,w/2-HINGE_DIA*2,0]) cube([0.01, HINGE_DIA*4, jaw_width]);
      bw = jaw_length / 2.5;
      translate([0,(-bw+w)/2,0]) cube([0.01, bw, jaw_width]);
    }
    translate([h,w/2,-1]) cylinder(d=hd, h=jaw_width+2);
    hw = jaw_width - SPRING_WIDTH;
    if (alt) {
      translate([0,-jaw_length/2,hw/4]) cube([w+1,jaw_length,hw/2 + SPRING_WIDTH]);
      if (HINGE_PIN_RETAINER_DIA > 0) {
        // Pin retainer
        translate([w/2,w/2,hw/4/2])
          rotate([90,0,0])
            cylinder(d=HINGE_PIN_RETAINER_DIA,h=HINGE_DIA*2);
      }
    } else {
      translate([0,-jaw_length/2,-1]) cube([w+1,jaw_length,hw/4+1]);
      translate([0,-jaw_length/2,hw/2]) cube([w+1,jaw_length,SPRING_WIDTH]);
      translate([0,-jaw_length/2,jaw_width - hw/4]) cube([w+1,jaw_length,hw/4+1]);
    }
  }
}

module Side() {
  linear_extrude(WALL)
    offset(4) offset(-4)
      square([jaw_width, jaw_length]);
}