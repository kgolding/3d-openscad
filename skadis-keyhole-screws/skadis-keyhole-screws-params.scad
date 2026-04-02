// SKADIS back plate for screws to use with keyhole mounted kit

ORIENTATION = "Horizontal"; // ["Horizontal", "Vertical"]
KEYHOLE_DISTANCE = 56;
MIN_HEIGHT = 80;
MIN_WIDTH = 80;
POSITION = "Centered"; // ["Centered", "Manual"]
TEXT = "Skadis";
TEXT_SIZE = 10;

MANUAL_LEFT = 10;
MANUAL_TOP = 10;

SCREW_HOLE_DIA = 3.3;
WALL = 5;
ROUNDING = 5;
KEYHOLE_MIN_FROM_EDGE = 6;
HOOKS_MODE = "edge"; // ["edge", "all"]

HEIGHT = max(
  MIN_HEIGHT,
  SCREW_HOLE_DIA + 2*KEYHOLE_MIN_FROM_EDGE +
    (ORIENTATION == "Horizontal" ?
      0 : KEYHOLE_DISTANCE + SCREW_HOLE_DIA ));

WIDTH = max(
  MIN_WIDTH,
  SCREW_HOLE_DIA + 2*KEYHOLE_MIN_FROM_EDGE +
    (ORIENTATION == "Horizontal" ?
      KEYHOLE_DISTANCE + SCREW_HOLE_DIA : 0));

// Screw position
LEFT = POSITION == "Centered" ?
  (ORIENTATION == "Horizontal" ?
    (WIDTH - KEYHOLE_DISTANCE)/2 :
    HEIGHT/2) :
  MANUAL_LEFT;

TOP = POSITION == "Centered" ?
  (ORIENTATION == "Horizontal" ?
    HEIGHT/2 :
    (WIDTH - KEYHOLE_DISTANCE)/2):
  MANUAL_TOP;

echo("WIDTH:", WIDTH, ", HEIGHT:", HEIGHT);

tiny = 0.01;
$fn=30;

TEXT_ONLY = false;

Plate(TEXT_ONLY) {
  if (TEXT != "") {
    translate([WIDTH/2, WALL-0.4, HEIGHT/2]) rotate([90,-45,180]) linear_extrude(0.4+tiny) text(TEXT, size=TEXT_SIZE, halign="center", valign="center");
  }
};


module Plate(text_only) {
  if (text_only) {
    children();
  } else {
    difference() {
      // Rear plate
      translate([0, WALL, 0])
        rotate ([90,0,0]) linear_extrude(WALL) offset(ROUNDING) offset(-ROUNDING) square([WIDTH, HEIGHT]);

      // Screw holes
      translate([WIDTH - LEFT, WALL+tiny, HEIGHT-TOP]) rotate([90,0,0]) cylinder(d=SCREW_HOLE_DIA, WALL+2*tiny);
      if (ORIENTATION == "Horizontal") {
        translate([WIDTH - LEFT - KEYHOLE_DISTANCE, WALL+tiny, HEIGHT-TOP]) rotate([90,0,0]) cylinder(d=SCREW_HOLE_DIA, WALL+2*tiny);
      } else {
            translate([WIDTH - LEFT , WALL+tiny, HEIGHT-TOP-KEYHOLE_DISTANCE]) rotate([90,0,0]) cylinder(d=SCREW_HOLE_DIA, WALL+2*tiny);
      }
      if (!text_only) {
        children();
      }
    }
    // Hooks
    hooks(WIDTH, HEIGHT, mode=HOOKS_MODE, min_edge=10);
  }
}

module hooks(x, y, mode="all", min_edge=10) {
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
      if (mode == "all" ||
         (mode == "edge" && (
            col == 0 || // Left
            row == 0 || // Bottom
            col == cols-1 || // Right
            (col % 2 == 0 ? row == rows-1 : false)))
        ) {
        //color(is_bottom_row ? "red" : "black")
        if (inbetween_offset + row * 40 > 0)
          translate([col * 20, 0, inbetween_offset + row * 40]) hook();
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
