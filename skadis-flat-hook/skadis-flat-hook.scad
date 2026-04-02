// SKADIS wide hook

WIDTH =  230;
HEIGHT = 75;
GAP = 7;
WALL = 8;
ANGLE = 15;

tiny = 0.01;

rotate([0,ANGLE,0]) difference() {
  {
    difference() {
      cube([WALL+GAP+WALL, WIDTH, WALL+HEIGHT]);
      translate([WALL,-tiny,WALL]) cube([GAP, WIDTH+2*tiny, HEIGHT+tiny]);
    }
    translate([0,(WIDTH-110)/2,0]) cube([WALL+GAP+WALL, 110, WALL+40]);
  }
  translate([WALL+GAP+WALL-0.5, WIDTH/2, WALL + HEIGHT/2])
    rotate([90,0,90])
      linear_extrude(1)
        text("Anti-Static PCB Holder", size=14, valign="center", halign="center");
}

translate([0,WIDTH,0]) rotate([0,0,-90]) hooks(WIDTH, WALL+HEIGHT, "normal", 10);


// mode: "all" | "edge" | "normal"
module hooks(x, y, mode="edge", min_edge=10) {
  /*
    R2C0    R2C2    R2C4
        R1C1    R1C3
    R0C0    R0C2    R0C4
  
    cols are spaced at 20 mm
    rows are spaced at 20 mm
  */
  echo("mode", mode);
  hook_width = 5;
  hook_height = 15;
  cols = floor((x - 2*min_edge - hook_width)/20)+1;
  offsetX = (x - ((cols-1)*20)) / 2;
  echo("cols", cols)
  echo("offsetX", offsetX);

  rows = floor((y - 2*min_edge)/20)+1;
  offsetY = min_edge + (hook_height/2) + (y - ((rows)*20)) / 2;
  echo("rows", rows)
  echo("offsetY", offsetY);

  translate([offsetX, 0, offsetY])
  for (col = [0:cols-1]) {          // Each col
    for (row = [0:rows-1]) {        // Each row
      if ((row + col)%2 == 0) {     // Just the ones that exist on the pegboard
//        is_middle_row = row == (rows-1)/2;
        echo("R", row, "C", col);
        is_bottom_row = row <= 1;
        is_top_row = row >= rows-2;
        is_left = col <= 1;
        is_right = col >= cols-2;
        is_middle_row = !is_bottom_row && !is_top_row;
        is_middle_col = col == (col-1)/2;
        if (mode == "all" ||
           (mode == "edge" && (
              is_left ||
              is_bottom_row ||
              is_right ||
              is_top_row)) ||
            (mode == "normal" && (
              is_left ||
              is_right ||
              (cols%2 == 0 ?
                col == cols/2 || col == cols/2-1:     // Even cols (2)
                cols > 8 ?                            // Odd cols
                  (col > cols/2-2 && col < cols/2+1) :  // (3)
                  col == cols/2-0.5                       // (1)
              )))
  //          (mode == "sparse" && (
  //            col == 0 || col == cols-1 || is_middle_col))
          ) {
            color(is_middle_row ? "blue" : is_middle_col ? "green" : is_top_row ? "pink" : is_bottom_row ? "red" : "black")
              translate([col * 20, 0, row * 20]) hook();
          }
      }
    }
  }
}

module hook() {
  // t is the amount we reduce the width/height by to let it fit ok
  t = 0.1;
  // w = width
  w = 5;
  // wt is the width less the t
  wt = w - t * 2;
  // h is the height less a bit to make it fit
  h = 15 - 0.3;
  // h2 is the height of the smaller part of the peg
  h2 = h - 5;
  // ht is the height less t
  ht = h - t;
  // d is the depth of the board
  d = 5;
  // 6 gives us enough facets to create a easy to print angle
  // 4 gives us 45 degrees
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
