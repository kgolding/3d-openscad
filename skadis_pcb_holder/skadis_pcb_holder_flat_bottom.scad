// SKADIS PCB Holder

SLOTS = 13;
SLOT_WIDTH = 3;
SLOT_SPACING = 5;
SLOT_DEPTH = 5;
HEIGHT = 140;
DEPTH = 100;
WALL = 10;
ANGLE = 10;

tiny = 0.01;

aoffset = sin(ANGLE) * HEIGHT;
boffset = cos(ANGLE) * HEIGHT; 
echo(aoffset, boffset);

w = SLOTS * (SLOT_WIDTH + SLOT_SPACING) + SLOT_SPACING;

difference() {
  d = DEPTH+aoffset;
  fh=WALL+sin(ANGLE)*d;
  // Body
  cube([d, w, HEIGHT]);
  // Bottom front chamfer
  translate([d,w/2,0]) rotate([0,45,0]) cube([3, w+2*tiny, 3], center=true);
  // Bottom left chamfer
  translate([d/2,0,0]) rotate([45,0,0]) cube([d+2*tiny,3,3], center=true);
  // Bottom rightchamfer
  translate([d/2,w,0]) rotate([45,0,0]) cube([d+2*tiny,3,3], center=true);
  // Front chamfer
  translate([d,w/2,fh]) rotate([0,45,0]) cube([3, w+2*tiny, 3], center=true);
  // Front left chamfer
  translate([d,0,fh/2]) rotate([0,0,45]) cube([3,3, fh+tiny], center=true);
  // Front right chamfer
  translate([d,w,fh/2]) rotate([0,0,45]) cube([3,3, fh+tiny], center=true);
  
  // Slots and body mask
  translate([WALL + aoffset,0,0]) rotate([0,-ANGLE,0]) {
    translate([SLOT_DEPTH,-tiny,WALL+SLOT_DEPTH]) cube([DEPTH+aoffset+2*tiny,w+2*tiny,HEIGHT]);
    // Slots
    for (s=[0:1:SLOTS-1]) {
      // Slot
      translate([-tiny, SLOT_SPACING + s * (SLOT_SPACING + SLOT_WIDTH), WALL]) cube([DEPTH+2*tiny, SLOT_WIDTH, HEIGHT]);
    }
  }
}

translate([0,w,0]) rotate([0,0,-90]) hooks(w, boffset, "edge", 10);

//translate([aoffset,0,0]) rotate([0,-ANGLE,0]) {
//  // Bottom
//  SlottedPlate(DEPTH, w);
//  // Upright
//  rotate([0,90,0]) translate([-HEIGHT,0,0]) SlottedPlate(HEIGHT, w);
//}
//
//// Body
//translate([0,w,0]) rotate([90,0,0]) linear_extrude(w) polygon([
//  [0,0], [0,boffset], [aoffset,0]
//]);
//
//translate([0,w,0]) rotate([0,0,-90]) hooks(w, boffset, "edge", 10);

module SlottedPlate(x,y) {
  difference() {
    cube([x, y, WALL + SLOT_DEPTH]);
    for (s=[0:1:SLOTS-1]) {
      translate([-tiny, SLOT_SPACING + s * (SLOT_SPACING + SLOT_WIDTH), WALL]) cube([x+2*tiny, SLOT_WIDTH, SLOT_DEPTH+tiny]);
    }
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
