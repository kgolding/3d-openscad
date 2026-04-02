// SKADIS Light switch holder

w = 18;
d = 9.5;


cw = 1.5;
difference() {
  union() {
    cube([50,3,50]);
    translate([50-18-2*cw,3,0]) {
      cube([18+2*cw,d+cw/2,50]);
    }

    // Pocket
    difference() {
      translate([0,3,0]) cube([50-w,d+cw/2,20]);
      translate([1.5,3,4]) cube([50-w,d+cw/2-1.5,20]);
    }
  }
  // Switch
  translate([50-cw-w,3,-10]) cube([w,d,70]);
  translate([50-w,3,-10]) cube([w-2*cw,d*2,70]);
  
  // Chamfers
  translate([25,3+d+cw/2,0]) rotate([45,0,0]) cube([51,2,2], center=true);
  translate([25,3+d+cw/2,50]) rotate([45,0,0]) cube([51,2,2], center=true);
  translate([0,0,50]) rotate([45,0,90]) cube([51,2,2], center=true);
}

translate([5,0,20]) {
  hook();
  translate([20,0,20]) hook();
}


module hooks(x, y, mode="all", min_edge=10) {
  hook_width = 5;
  hook_height = 15;
  cols = floor((x - 2*min_edge - hook_width)/20)+1;
  offsetX = (x - ((cols-1)*20)) / 2;
  echo("cols", cols)
  echo("offsetX", offsetX);

  rows = floor((y - 2*min_edge - hook_height)/40)+1;
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
