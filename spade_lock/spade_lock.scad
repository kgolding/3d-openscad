// Crimp spade joing cover

WALL = 2;
CRIMP_WIDTH = 10;
CRIMP_HEIGHT = 7.5;
CRIMP_BODY = 12 + CRIMP_HEIGHT;
CRIMP_CYLINDER_DIA = 7;

BODY_LENGTH = CRIMP_BODY + 2 * (WALL + 3.5);
BODY_WIDTH = CRIMP_WIDTH + 2 * WALL;
BODY_HEIGHT = CRIMP_HEIGHT + 2 * WALL;

CLIP_WIDTH = 4;
CLIP_HEIGHT = BODY_HEIGHT / 3;

// Two of the same part
translate([0, -BODY_WIDTH - 10, 0]) {
  difference() {
    Body();
    translate([-1,-1,BODY_HEIGHT/2]) cube([BODY_LENGTH+2, BODY_WIDTH+2, BODY_HEIGHT]);
    Clips2(true);
    // Screwdriver release slots
    sdw = 6;
    sdh = 0.75;
    translate([BODY_LENGTH/2-sdw/2,BODY_WIDTH+1,BODY_HEIGHT/2])
      rotate([90,0,0])
        linear_extrude(BODY_WIDTH+2)
          polygon([
            [0,0.01], [sdh,-sdh], [sdw-sdh,-sdh], [sdw,0.01],
          ]);
    //cube([6,BODY_WIDTH+1,2], center=true);
  }
  Clips2();

}


// Two part
*translate([0, BODY_WIDTH + 10, 0]) union() {
  difference() {
    Body();
    translate([-1,-1,BODY_HEIGHT/2]) cube([BODY_LENGTH+2, BODY_WIDTH+2, BODY_HEIGHT]);
  }
  Clips();
}

*difference() {
  Body();
  translate([-1,-1,BODY_HEIGHT/2]) cube([BODY_LENGTH+2, BODY_WIDTH+2, BODY_HEIGHT]);
  translate([0,0,BODY_HEIGHT]) mirror([0,0,1]) Clips(true);
}


$fn=25;

module Clips2(mask=false) {
  cw = 5 + (mask ? 0.2 : 0);
  cx = 1.8;
  cd = 0.35;
  ct = 1.4;
  co = 4;
  maskTiny = mask ? 0.01 : 0;
  translate([0,BODY_WIDTH/2,0])
    for (m = [0,1])
      mirror([0,m,0])
        translate([0,-BODY_WIDTH/2,0])
          translate([mask ? BODY_LENGTH-cw+0.01 : cw,0,BODY_HEIGHT/2])
            rotate([0,mask ? 180:0,0]) {
              difference() {
                rotate([0,-90,0])
                  linear_extrude(cw)
                      polygon([
                        [-maskTiny,-maskTiny], [CLIP_HEIGHT,-maskTiny], [CLIP_HEIGHT,cx],
                        [CLIP_HEIGHT-ct/2,cx+cd],[CLIP_HEIGHT-ct,cx],
                        [-maskTiny,cx+cd]
                      ]);
                translate([-cw,0,-0.05]) linear_extrude(CLIP_HEIGHT+1) polygon([
                  [-0.01,-0.01], [1,-0.01], [-0.01,1]
                ]);
              }
              // Location pins
              pin = (mask?1.4:1.2);
              translate([BODY_LENGTH - 2*cw - 1.8,WALL/2,0]) rotate([0,45,0]) cube([pin,WALL + (mask ? 0.1 : 0),pin] , center=true);
            }
}

module Clips(plus=false) {
  cw = CLIP_WIDTH + (plus ? 0.2 : 0);
  cx = 2;
  cd = 0.4;
  ct = 1.4;
  co = 4;
  translate([0,BODY_WIDTH/2,0])
  for (m = [0,1])
    mirror([0,m,0])
      translate([0,-BODY_WIDTH/2,0]) for(x = [co, BODY_LENGTH - co])
        translate([x + cw/2,0,BODY_HEIGHT/2])
          rotate([0,-90,0])
          linear_extrude(cw)
              polygon([
                [0,0], [CLIP_HEIGHT,0], [CLIP_HEIGHT,cx],
                [CLIP_HEIGHT-ct/2,cx+cd],[CLIP_HEIGHT-ct,cx],
                [0,cx]
              ]);
}

module Body() {
  difference() {
    hull() {
      c = 1;
      c2 = c * 2;
      // Main body
      translate([0,0,c]) linear_extrude(BODY_HEIGHT - c2) ChamferedSquare(BODY_LENGTH, BODY_WIDTH, c);
      //translate([0,0,c]) cube([BODY_LENGTH, BODY_WIDTH, BODY_HEIGHT - c2]);
      translate([c,c,0]) cube([BODY_LENGTH - c2, BODY_WIDTH - c2, 0.01]);
      translate([c,c,BODY_HEIGHT-0.01]) cube([BODY_LENGTH - c2, BODY_WIDTH - c2, 0.01]);
    }
    
    translate([BODY_LENGTH/2, BODY_WIDTH/2, BODY_HEIGHT/2]) {
      //rotate([0,90,0]) cylinder(d=CRIMP_CYLINDER_DIA, h=BODY_LENGTH+1, center=true);
      scale([1,1,0.75]) rotate([0,90,0]) cylinder(d=CRIMP_CYLINDER_DIA, h=BODY_LENGTH+1, center=true);
      cb2 = CRIMP_BODY/2;
      ch2 = CRIMP_HEIGHT/2;
      translate([0,CRIMP_WIDTH/2,0]) rotate([90,0,0]) linear_extrude(CRIMP_WIDTH) polygon([
        [-cb2,0], [-cb2+ch2,ch2], [cb2-ch2,ch2], [cb2,0],
        [cb2-ch2,-ch2], [-cb2+ch2,-ch2]
      ]);
      //cube([CRIMP_BODY, CRIMP_WIDTH, CRIMP_HEIGHT], center=true);
    }
    
    translate([BODY_LENGTH/2,BODY_WIDTH/2,0.4])
      rotate([180,0,180])
        linear_extrude(0.5) {
          translate([0,2.2,0]) text("Spade", size = 4.5, font="DejaVu Sans:style=Bold", halign="center", valign="center");
          translate([0.675,-2.8,0]) text("safe", size = 4.5, font="DejaVu Sans:style=Bold", halign="center", valign="center");
        }
  }
}

module ChamferedSquare(x, y, c) {
  polygon([
    [0, c], [0,y-c], [c,y], [x-c, y], [x, y-c], [x,c], [x-c,0], [c,0]
  ]);
}