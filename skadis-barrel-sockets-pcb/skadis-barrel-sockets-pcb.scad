
// SKADIS Holder for 5 way DC Barrel PCB

PCB_WIDTH = 18;
PCB_DEPTH = 25;
PCB_HEIGHT = 52;
PCB_TAILS_HEIGHT = 2.3;

WALL = 2;
WIDTH = PCB_WIDTH + WALL + PCB_TAILS_HEIGHT;
HEIGHT = PCB_HEIGHT + 2*WALL;
SCREW_HOLE_DIA = 2.7; // M3

LID = true;
BODY = true;

tiny = 0.01;
$fn=30;

if (LID) {
  // Lid
  translate([WALL,-20,0]) rotate([0,0,180]) lid();
}

if (BODY) {
  difference() {
    union() {
      // Rear plate
      translate([-WIDTH/2, WALL, 0])
        rotate ([90,0,0]) linear_extrude(WALL) square([WIDTH, HEIGHT]);

      translate([-WIDTH/2+WALL, WALL, WALL]) {
        difference() {
          union () {
            translate([-WALL,0,-WALL]) {
              // Left
              cube([WALL, PCB_DEPTH, PCB_HEIGHT+WALL]);
              // Top
              translate([0,0,PCB_HEIGHT+WALL]) cube([PCB_WIDTH + WALL + PCB_TAILS_HEIGHT, PCB_DEPTH, WALL]);
              // Bottom
              cube([PCB_WIDTH + WALL + PCB_TAILS_HEIGHT, PCB_DEPTH, WALL]);
            }
            // Screw pillers
            translate([-tiny,8,4]) rotate([0,90,0]) cylinder(d1=2*(SCREW_HOLE_DIA+2),d2=SCREW_HOLE_DIA+2, PCB_TAILS_HEIGHT+2*tiny);
            translate([-tiny,3,37]) rotate([0,90,0]) cylinder(d1=2*(SCREW_HOLE_DIA+2),d2=SCREW_HOLE_DIA+2, PCB_TAILS_HEIGHT+2*tiny);
        }
          // Screw holes
          translate([-tiny,8,4]) rotate([0,90,0]) cylinder(d=SCREW_HOLE_DIA, h=WALL*3, center=true);
          translate([-tiny,3,37]) rotate([0,90,0]) cylinder(d=SCREW_HOLE_DIA, h=WALL*3, center=true);
          // Top barrel
          translate([12/2 + PCB_TAILS_HEIGHT + 1.5,10.5,PCB_HEIGHT]) cube([12,10,3*WALL], center=true);
        }
      }
    }
    lid();
  }

  // Hooks
  translate([-WIDTH/2,0,0]) hooks(WIDTH, HEIGHT, sparse=true, min_edge=1);
}

module lid() {
  difference() {
    translate([WIDTH/2, 0, 0]) {
      cube([WALL, PCB_DEPTH+WALL, HEIGHT]);
      translate([-4, PCB_DEPTH, WALL+tiny]) cube([4, WALL, PCB_HEIGHT-2*tiny]);
      /*                                                4     
                                                        /     
                                                     ch/ \    
                            cl                    3   /   \ 5 
      2  │───────────────────────────────────────────/ cw  \ 
      ct │                                                 │  
      1  │─────────────────────────────────────────────────│ 6
      Edit/view: https://cascii.app/14e9e
      */
      ct = 1.6;
      cl = 1;
      ch = 1;
      cw = 3;
      clip = [
        //1    2       3        4
        [0,0], [0,ct], [cl,ct], [cl+cw/2, ct+ch],
        //5             6
        [cl+cw, ct], [cl+cw, 0]
      ];
      w = PCB_WIDTH;
      translate([0, WALL + PCB_DEPTH/2,0]) { // Center lid at bottom
        translate([0, w/2, WALL + ct]) rotate([-90,0,180]) linear_extrude(w) polygon(clip);
        translate([0, -w/2, PCB_HEIGHT]) rotate([90,0,180]) linear_extrude(w) polygon(clip);
      }
      translate([0, WALL + ct, WALL + 5]) rotate([0,0,180]) linear_extrude(PCB_HEIGHT - 10) polygon(clip);
    }
    translate([WIDTH/2 +1.5,PCB_DEPTH/2+WALL,PCB_HEIGHT/2+WALL]) rotate([0,90,]) linear_extrude(1) rotate(180) text("12V DC", size=10, halign="center", valign="center");
  }
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
