WIDTH = 150;
DEPTH = 80;
SLIDES = 2;
WALL = 3;
SCREW_DIA = 4.3;
REAR_STOP = true;
BALL_CATCH = true;

EdgeWidth = 20;
ScrewSpread = DEPTH-2*EdgeWidth;
ScrewSpacing = ScrewSpread / round(ScrewSpread / 50);

SlideHeight = 6;
SlideWidth = (WIDTH - 2*EdgeWidth - SLIDES*2*SlideHeight) / (SLIDES);
SlideOffset = EdgeWidth - SlideHeight/2 + SlideWidth/2 ;

BallCatchOffset = 10;

// Vertical
//rotate([90,0,0]) Top();
//translate([0,-WALL-SlideHeight-12,DEPTH]) rotate([-90,0,0]) Bottom();

// Flat
translate([0,0,WALL + SlideHeight]) rotate([180,0,0]) Top();
translate([0,10,WALL]) rotate([0,0,0]) Bottom();


module Top(gap=0.1) {
  translate([0,0,SlideHeight]) {
    difference() {
      union() {
        cube([WIDTH, DEPTH, WALL]);
        for (i = [0:SLIDES-1]) {
          translate([(WIDTH/SLIDES) * i + SlideOffset,0,-SlideHeight])
            Slide(SlideWidth - 4*gap, DEPTH, SlideHeight, r=1);
        }
        if (REAR_STOP) {
          translate([0,0,-SlideHeight+gap]) rotate([-90,0,0]) hull() {
            translate([WIDTH-WALL/2,-WALL/2,0]) cylinder(d=WALL, h=WALL, $fn=30);
            translate([WALL/2,-WALL/2,0]) cylinder(d=WALL, h=WALL, $fn=30);
            translate([0,-SlideHeight,0]) cube(WALL);
            translate([WIDTH-WALL,-SlideHeight,0]) cube(WALL);
          }
        }
      }
      // Screw holes
      for (i = [0:SLIDES-1]) {
        translate([(WIDTH/SLIDES) * i + SlideOffset,0,-SlideHeight])
        for (y = [0:ScrewSpacing:ScrewSpread])
          translate([0,EdgeWidth + y,0]) ScrewHole();
      }  
      if (BALL_CATCH) {
        for (i = [0:SLIDES-1]) {
          translate([(WIDTH/SLIDES) * i + SlideOffset,BallCatchOffset,-SlideHeight])
            BallCatch5x6();
//          sphere(1);
        }
      }
    }
  }
}

module ScrewHole() {
  // Screw hole
  cylinder(d=SCREW_DIA, h=WALL+SlideHeight+1, $fn=30);
  // Countersink
  translate([0,0,1.49]) cylinder(r1=SCREW_DIA, r2=SCREW_DIA/2, h=SCREW_DIA/2, $fn=30);
  // Top clearance
  cylinder(r=SCREW_DIA, h=1.5, $fn=30);
}

module Bottom() {
  difference() {
    union() {
      translate([0,0,-WALL]) cube([WIDTH, DEPTH, WALL]);  
      difference() {  
        cube([WIDTH, DEPTH, SlideHeight]);
        for (i = [0:SLIDES-1]) {
          translate([(WIDTH/SLIDES) * i + SlideOffset,-0.01,0])
            Slide(SlideWidth, DEPTH+0.02, SlideHeight + 0.01, r=1);
        }
      }
    }
    // Screw holes
    for (i = [0:SLIDES]) {
      EdgeOffset = i == 0 ? EdgeWidth / 2 :
        i == SLIDES ? -EdgeWidth/2 : 0;
      translate([EdgeOffset + (WIDTH/SLIDES) * i ,0,0])
        for (y = [0:ScrewSpacing:ScrewSpread])
          translate([0,EdgeWidth + y,SlideHeight + 0.01]) rotate([180,0,0]) ScrewHole();
      }
    if (REAR_STOP) {
      translate([-1,-0.01,0]) cube([WIDTH+2, WALL + 0.2, SlideHeight+0.01]);
    }
    if (BALL_CATCH) {
      for (i = [0:SLIDES-1])
        translate([(WIDTH/SLIDES) * i + SlideOffset + 5/2,BallCatchOffset,-1.2]) {
          rotate([90,0,-90]) intersection() {
            linear_extrude(5) polygon([ // Edit/view: https://cascii.app/c5b44
                [0,0], [-5/2, 1], [-5/2, 2], [BallCatchOffset+1, 2],
                [BallCatchOffset+1, 0], [BallCatchOffset/2, 1],
            ]);
            translate([-5,5/2,5/2]) rotate([0,90,0]) cylinder(d=5,h=2*BallCatchOffset, $fn=30);
          }
        }
    }
  }
}

module Slide(width, length, height, r=2) {
  s = 1 - length / SlideHeight*2 / 100;
  rotate([-90,0,0])
    linear_extrude(height=length, scale=[s,1])
      SlideProfile(width, height+0.001, r);
}

//translate([0,0,50]) rotate([90,0,0]) SlideProfile(50, 12, 2);
//translate([0,50,50]) Slide(50, 50, 12, 2);

module SlideProfile(width, height, r) {
  halfheight = height/2;
  bl = [-width/2 - halfheight, 0];
  br = [width/2 + halfheight, 0];
  tl = [-width/2 + halfheight, -height];
  tr = [width/2 - halfheight, -height];
  $fn = 30;

  hull() {
    translate([bl.x + r, bl.y - r]) circle(r);
    translate([br.x - r, br.y - r]) circle(r);
    translate([tl.x,tl.y]) square([tr.x-tl.x, 0.01]);
  }
  // Inside fillets
  ir = 4*r;
  for (m=[0:1]) mirror([m,0,0]) {
    // @TODO Calc the r*X factor!
    translate([tl.x - r*3, tl.y + r]) difference() {
      polygon([
        [0,r-0.1], [0,-r], [ir,-r], [ir, 0]
      ]);
      circle(r);
    }            
  }
}

module BallCatch5x6() {
  // https://www.amazon.co.uk/sourcing-map-Precision-Positioning-Mechanical/dp/B0DY7T4QF9/ref=asc_df_B0DY7WGCCS
  // 5x6 is 5 mm dia, 6 mm deep plus a 1 mm deep 5.5 mm dia rim
  // Main body
  cylinder(d=5.1, h=6.8, $fn=30);
  // Top rim
  cylinder(d=5.6, h=1.2, $fn=30);
}

