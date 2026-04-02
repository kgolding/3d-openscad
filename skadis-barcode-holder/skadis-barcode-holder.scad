// Barcode scanner holder

$fn = 30;

iw = 44;
WALL = 1.8;

tx = 10;
ty = 40;
bx = 30;
by = 15;

rotate([0,-90,0]) Right();

translate([10,0,iw/2+WALL]) rotate([0,90,0]) Left();

module Left() {
  translate([-iw/2-WALL,0,0]) difference() {
    body();
    translate([iw/2+WALL-2*iw,-bx,-ty]) cube([2*iw,3*bx,3*ty]);
    Pins(1.1);
  }
}

module Right() {
  difference() {
    body();
    translate([iw/2+WALL,-bx,-ty]) cube([2*iw,3*bx,3*ty]);
  }
  Pins(0.9);
}

module Pins(scaled=1) {
  po = (WALL*2)/3;
  translate([iw/2+WALL,po,po]) Pin(scaled);
  translate([iw/2+WALL,bx+WALL-po,po]) Pin(scaled);
  translate([iw/2+WALL,po,ty+WALL-po]) Pin(scaled);
  translate([iw/2+WALL,tx,ty]) Pin(scaled);
  translate([iw/2+WALL,bx,by]) Pin(scaled);
}


module Pin(scaled=1) {
  scale(scaled) {
    rotate([0,90,0]) cylinder(r1=WALL/3, r2=WALL/4, h=1);
    rotate([0,-90,0]) cylinder(r1=WALL/3, r2=WALL/4, h=1);
  }
}

module body() {
  difference() {
    translate([WALL,0,0]) rotate([90,0,90]) linear_extrude(iw) Profile();
    Text();
  }

  // Right side
  rotate([90,0,90]) linear_extrude(WALL) hull() Profile();

  // Left side
  translate([iw+WALL,0,0]) rotate([90,0,90]) linear_extrude(WALL) hull() Profile();

  // Hooks
  hooks(iw+2*WALL,ty,mode="all",min_edge=0);
}

// Text
module Text() {
  s = 6.7;
  translate([iw/2+WALL,bx+WALL-0.3,1.4]) rotate([90,0,180]) linear_extrude(0.5) {
    translate([0,s]) text("Barcode", size=s,halign="center");
    text("Scanner", size=s,halign="center");
  }
}

module Profile() {
  offset(-WALL) offset(WALL) {
    // Top circle
    translate([tx,ty]) circle(d=WALL*2);
    
    // Rear
    square([WALL,ty]);
    
    // Top bar
    hull() {
      translate([tx,ty+WALL/2]) circle(d=WALL);
      translate([0,ty]) square(WALL);
    }
   
    // Bottom circle
    translate([bx,by]) circle(d=WALL*2);
    
    // Bottom bar
    hull() {
      translate([0,0]) square(WALL);
      translate([bx+WALL/2,WALL/2]) circle(d=WALL);
    }

    // Vertical bar
    hull() {
      translate([bx+WALL/2,WALL/2]) circle(d=WALL);
      translate([bx+WALL/2,by]) circle(d=WALL);
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
