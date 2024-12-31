// Customisable magnet holder for IKEA Sakdis pegboards
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

// Plate thickness (behind magnets)
plateT=3;   // [1:0.1:10]

/* [Hidden] */
$fn = 50;

/* [Hidden] */
// tiny is used to ensure preview works as well as render by making masks overlap a little
tiny=0.001;
tiny2=tiny*2;

assert(mOffset < s - chamfer, "Offset must be smaller than the Spacing less the chamfer");

body(mRows,mCols,chamfer);

// Tests
//translate([100,00,0]) {
//  translate([0,00,0]) body(1,1);
//  translate([30,30,0]) body(2,1);
//  translate([60,60,0]) body(2,2);
//  translate([0,90,0]) body(3,1);
//  translate([30,120,0]) body(3,2);
//  translate([60,150,0]) body(3,3);
//  translate([0,180,0]) body(4,1);
//  translate([30,210,0]) body(4,2);
//  translate([60,240,0]) body(4,3);
//  translate([90,270,0]) body(4,4);
//};

module body(rows, cols, chamfer=2) {
  // Width
  w = (mDia + s) * cols + s;
  // Height
  h = (mDia + s) * rows + s;
  // Depth
  d = plateT + mDepth;
  
  assert(chamfer < d, "Chamfer too large!");
  
  difference() {
    hull() {
        cube([w, d, h]);
    }
    
    c2 = chamfer * 2;

    if (chamfer > 0) {
      // Chamfers
      translate([0,d-chamfer,-tiny]) rotate([0, 0, 45]) cube([c2,c2,h+tiny2]); // Right
      translate([w,d-chamfer,-tiny]) rotate([0, 0, 45]) cube([c2,c2,h+tiny2]); // Left
      translate([0,d-chamfer,0]) rotate([0, 90, 0]) rotate([0, 0, 45]) cube([c2,c2,w+tiny2]); // Bottom
      translate([0,d-chamfer,h]) rotate([0, 90, 0]) rotate([0, 0, 45]) cube([c2,c2,w+tiny2]); // Top
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

module hooks(w, h) {
  echo("=== HOOKS()", w, h);
  hookCols = ceil((w-5) / 20);
  hookRows = ceil((h-15) / 20);
  echo("hookCols, hookRows", hookCols, hookRows);

  // Center by width
  offsetX = (w-((hookCols-1) * 20))/2;
  oddX = hookRows == 100 ? 10 : 0;
  echo("offsetX:", offsetX, "oddX:", oddX);
  // Vertically we start 5 mm from the top and work down
  offsetTop = 5;
  for (x=[offsetX:40:w-5]) {
    for (z=[0:40:h-15]) {
      translate([x+oddX, 0, h-offsetTop-z]) hook();
    };
  };
  for (x=[20:40:w-5]) {
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
