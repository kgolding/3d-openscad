DEPTH = 100;
HEIGHT = 60;
WALL = 2;

SECTION_WIDTH = 20;
SECTION_QTY = 5;
SECTION_WALL = 1.8;

SKADIS = true;
ANGLE = 25;

$fn = 50;

ROUNDING = WALL;
WIDTH = WALL + (SECTION_WIDTH + SECTION_WALL) * SECTION_QTY + (WALL - SECTION_WALL);

if (SKADIS) {
  skadis();
} else {
  body();
}

module skadis() {
  angle_offset = cos(ANGLE) * HEIGHT;
  echo("angle_offset", angle_offset);
  rotate([90,0,180]) difference() {
    translate([0,0,HEIGHT]) rotate([-ANGLE,0,0]) union() {
      translate([0,0,-DEPTH]) rounded_body(DEPTH);
      body();
    }
    // Cut the bottom off
    #translate([-10,-10,-HEIGHT*4]) cube([WIDTH+20, DEPTH*2, HEIGHT*4]);
  }
  translate([-WIDTH,0,0]) hooks(WIDTH - 5, DEPTH);
}

module body() {
  difference() {
    rounded_body(HEIGHT);
    /*
        0   C      B                              A    
                                                      
         ──────────────────────────────────────────  G
         │ 5                                    6 │   
         │                                        │   
          \4                                   7//   F
           \\                                 //      
            │ 3                             8 │      E
            │                                 │       
            │                                 │       
            │\ 2                           9 /│      D
              \\                           //         
                \\                       //           
                  \\ 1             10  //             
                    \\───────────────//              0

        Edit/view: https://cascii.app/06c7c
    */
    A = DEPTH*0.68;
    B = A*0.3;
    C = 6;
    D = B-C;
    G = HEIGHT*0.68 + 1;
    E = G-1-C;
    F = G-1;
    translate([-1, (DEPTH-A)/2, HEIGHT - G + 1]) rotate([90,0,90]) linear_extrude(WIDTH+20) polygon([
      // Left
      [B,0], [C,D], [C,E], [0,F], [0,G], 
      //Right
      [A,G], [A,F], [A-C,E], [A-C,D], [A-B,0],
    ]);
    
    // Sections
    for (i=[0:1:SECTION_QTY-1]) {
      translate([WALL + i * (SECTION_WIDTH + SECTION_WALL), WALL, WALL])
          linear_extrude(HEIGHT) hull() {
            ROUNDING = SECTION_WALL;
            translate([ROUNDING, ROUNDING, 0]) circle(r=ROUNDING);
            translate([SECTION_WIDTH-ROUNDING, ROUNDING, 0]) circle(r=ROUNDING);
            translate([SECTION_WIDTH-ROUNDING, DEPTH-ROUNDING-2*WALL, 0]) circle(r=ROUNDING);
            translate([ROUNDING, DEPTH-ROUNDING-2*WALL, 0]) circle(r=ROUNDING);
          }
//        cube([SECTION_WIDTH, DEPTH - 2*WALL, HEIGHT]);
    }
  }
}

module rounded_body(h) {
  // Rounded main body
  linear_extrude(h) hull() {
    translate([ROUNDING, ROUNDING, 0]) circle(r=ROUNDING);
    translate([WIDTH-ROUNDING, ROUNDING, 0]) circle(r=ROUNDING);
    translate([WIDTH-ROUNDING, DEPTH-ROUNDING, 0]) circle(r=ROUNDING);
    translate([ROUNDING, DEPTH-ROUNDING, 0]) circle(r=ROUNDING);
  }  
}

module hooks(x, y, sparse=true) {
  cols = floor(x/40)+1;
  offsetX = (x - ((cols-1)*40)) / 2;  
  echo("cols", cols)
  echo("offsetX", offsetX);

  rows = floor(y/40)+1;
//  offsetY = (x - ((cols-1)*40)) / 2;  
//  echo("rows", rows)
//  echo("offsetY", offsetY);
  
  for (col = [0:1:cols-1]) {
    for (row = [0:1:rows-1]) {
      if (!sparse ||
          col == 0 || 
          col == cols-1 ||
          row == 0 ||
          row == rows-1) {
        translate([offsetX + col * 40, 0, 20 + row * 40]) hook();
      }
    }
  }
  
  for (col = [0:1:cols-2]) {
    for (row = [0:1:rows-2]) {
      if (!sparse ||
          col == 0 || 
          col == cols-2 ||
          row == 0 ||
          row == rows-2) {
        translate([20 + offsetX + col * 40, 0, 20 + 20 + row * 40]) hook();
      }
    }
  }

  
//  for (a = [offsetX + 20:40:x]) {
//    for (b = [40:40:y]) {
//      #translate([a,0,b]) hook();
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
