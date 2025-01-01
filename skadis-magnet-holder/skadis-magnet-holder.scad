// Customisable magnet holder for IKEA Skadis pegboards
// Author: Kevin Golding

// Number of rows
mRows = 3; // [1:1:24]

// Number of columns
mCols = 2; // [1:1:24]

// Magnet thickness
mDepth = 2; // 0.1

// Magnet diameter
mDia = 15; // 0.1

// Oversize magnet diameter to fine tune the fit
mOffset = 0.01; // 0.01

// Spacing between magnets
s = 4.5; // [0.5:0.1:20]

// Chamfer size
chamfer=2; // [0:0.1:5]

// Corner rounding
rounding=5; // [0:0.1:15]

// Plate thickness (behind magnets)
plateT=3;   // [1:0.1:10]

/* [Hidden] */
$fn = 50;

/* [Hidden] */
// tiny is used to ensure preview works as well as render by making masks overlap a little
tiny=0.001;
tiny2=tiny*2;

assert(mOffset < s - chamfer, "Offset must be smaller than the Spacing less the chamfer");

MagneticHolder(mRows,mCols,chamfer,rounding);

// Tests
*translate([100,00,0]) {
  translate([0,00,0])   MagneticHolder(1,1,chamfer,rounding);
  translate([30,30,0])  MagneticHolder(2,1,chamfer,rounding);
  translate([60,60,0])  MagneticHolder(2,2,chamfer,rounding);
  translate([0,90,0])   MagneticHolder(3,1,chamfer,rounding);
  translate([30,120,0]) MagneticHolder(3,2,chamfer,rounding);
  translate([60,150,0]) MagneticHolder(3,3,chamfer,rounding);
  translate([0,180,0])  MagneticHolder(4,1,chamfer,rounding);
  translate([30,210,0]) MagneticHolder(4,2,chamfer,rounding);
  translate([60,240,0]) MagneticHolder(4,3,chamfer,rounding);
  translate([90,270,0]) MagneticHolder(4,4,chamfer,rounding);
};

module MagneticHolder(rows, cols, chamfer=2, rounding=10) {
  // Width
  w = (mDia + s) * cols + s;
  // Height
  h = (mDia + s) * rows + s;
  // Depth
  d = plateT + mDepth;
  
  assert(chamfer < d, "Chamfer too large, or plate thickness too shallow!");
  
  difference() {
    if (rounding == 0) {
      // With no corner rounding we use a cube and mask the chamfers if needed
      difference() {
        hull() {
          cube([w, d, h]);
        }
        if (chamfer > 0) {
          // Chamfers
          c2 = chamfer * 2;
          translate([0,d-chamfer,-tiny]) rotate([0, 0, 45]) cube([c2,c2,h+tiny2]); // Right
          translate([w,d-chamfer,-tiny]) rotate([0, 0, 45]) cube([c2,c2,h+tiny2]); // Left
          translate([0,d-chamfer,0]) rotate([0, 90, 0]) rotate([0, 0, 45]) cube([c2,c2,w+tiny2]); // Bottom
          translate([0,d-chamfer,h]) rotate([0, 90, 0]) rotate([0, 0, 45]) cube([c2,c2,w+tiny2]); // Top
        }
      }
    } else {
      // For corner rounding we hull cylinders at the rear of the body with cones at the front
      // to give round corners and a chamfers
      hull() {
        // Handle rounding when the chamfer is larger than the rounding
        sround = rounding < chamfer ? 0 : rounding-chamfer;
        for (x=[rounding,w-rounding]) {
          for (z=[rounding,h-rounding]) {
            if (chamfer == 0) {
              translate([x,0,z]) rotate([-90,0,0]) cylinder(r=rounding,h=d);
            } else {
              translate([x,0,z]) rotate([-90,0,0]) cylinder(r=rounding,h=tiny);
              translate([x,d,z]) rotate([90,0,0]) cylinder(r1=sround,r2=rounding,h=chamfer);
            }
          }
        };
      };
    }
    
    // Magnets
    for (row=[0:1:rows-1]) {
      for (col=[0:1:cols-1]) {
        translate([s+mDia/2+col*(mDia+s),d+tiny,mDia/2 + s + row*(mDia+s)]) rotate([90,0,0]) cylinder(d=mDia+mOffset, h=mDepth+tiny);
      }
    }
  }
  hooks(w, h);
}

// Hooks renders an grid of hook horizonitally centered for the given width/height
module hooks(w, h) {
  hookCols = ceil((w-5) / 20);
  hookRows = ceil((h-15) / 20);

  // Center by width
  offsetX = (w-((hookCols-1) * 20))/2;
  // Vertically we start 5 mm from the top and work down
  offsetTop = 5;
  for (x=[offsetX:40:w-5]) {
    for (z=[0:40:h-15]) {
      translate([x, 0, h-offsetTop-z]) hook();
    };
  };
  for (x=[20:40:w-5-offsetX]) {
    for (z=[20:40:h-15]) {
      translate([offsetX+x, 0, h-offsetTop-z]) hook();
    };
  };
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
