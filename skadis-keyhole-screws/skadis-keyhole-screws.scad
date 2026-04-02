
// SKADIS back plate for screws to use with keyhole mounted kit

WIDTH = 45;
KEYHOLE_DISTANCE = 160;
KEYHOLE_TOP_OFFSET = 10;
SCREW_HOLE_DIA = 3.3;
WALL = 5;
ROUNDING = 5;
KEYHOLE_MIN_FROM_EDGE = 10;

HEIGHT = KEYHOLE_DISTANCE + KEYHOLE_TOP_OFFSET + KEYHOLE_MIN_FROM_EDGE;

tiny = 0.01;
$fn=30;

rotate([-90,0,0]) {
  difference() {
    // Rear plate
    translate([-WIDTH/2, WALL, 0])
      rotate ([90,0,0]) linear_extrude(WALL) offset(ROUNDING) offset(-ROUNDING) square([WIDTH, HEIGHT]);

    // Screw holes
    translate([0, WALL+tiny, HEIGHT-KEYHOLE_TOP_OFFSET]) rotate([90,0,0]) cylinder(d=SCREW_HOLE_DIA, WALL+2*tiny);
    translate([0, WALL+tiny, HEIGHT-KEYHOLE_TOP_OFFSET-KEYHOLE_DISTANCE]) rotate([90,0,0]) cylinder(d=SCREW_HOLE_DIA, WALL+2*tiny);
  }

  // Hooks
  translate([-WIDTH/2,0,0]) hooks(WIDTH, HEIGHT, sparse=true, min_edge=10);
}

module hooks(x, y, sparse=true, min_edge=10) {
  hook_width = 5;
  hook_height = 15;
  cols = floor((x - 2*min_edge - hook_width)/20)+1;
  offsetX = (x - ((cols-1)*20)) / 2;
  echo("cols", cols)
  echo("offsetX", offsetX);

  rows = floor((y - 2*min_edge)/40)+1;
  offsetY = (hook_height/2) + (y - ((rows)*40)) / 2;
  echo("rows", rows)
  echo("offsetY", offsetY);

  translate([offsetX, 0, offsetY])
  for (col = [0:1:cols-1]) {
    for (row = [0:1:rows-1]) {
      inbetween_offset = col % 2 ? 0 : 20;
      is_bottom_row = col % 2 == 0 ? row == 0 : row == 1;
      if (!sparse ||
          col == 0 || 
          col == cols-1 ||
          is_bottom_row ||
          row == rows-1) {
        //color(is_bottom_row ? "red" : "black")
        if (inbetween_offset + row * 40 > 0)
          translate([col * 20, 0, inbetween_offset + row * 40]) hook();
      }
    }
  }
  
//  for (col = [0:1:cols-2]) {
//    for (row = [0:1:rows-2]) {
//      if (!sparse ||
//          col == 0 || 
//          col == cols-2 ||
//          row == 0 ||
//          row == rows-2) {
//        translate([20 + offsetX + col * 40, 0, offsetY + 20 + 20 + row * 40]) hook();
//      }
//    }
//  }

  
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
