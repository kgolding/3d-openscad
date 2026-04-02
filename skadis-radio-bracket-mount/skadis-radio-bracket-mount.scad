// SKADIS Radio bracket mount

HEIGHT = 50;
THICKNESS = 8.5; // M5 threaded inserts are 7mm deep
BORDER = 15;
HOLE_SPACING = [14,92,14];
HOLE_DIA = 6.4;
$fn = 20;

holes_width = add(HOLE_SPACING);
w = BORDER + holes_width + BORDER;
echo(str("Width:",w))

difference() {
  translate([0,THICKNESS,0]) rotate([90,0,0]) linear_extrude(THICKNESS) difference() {
    // Back plate with rounded corners
    // offset(3) offset(-3) square([w, HEIGHT]);
    // Back plate with angled corners
    square([w, HEIGHT]);
    for (x=[0:1]) for (y=[0:1]) translate([w*x,HEIGHT*y,0]) rotate(45) square(4,center=true);
    // Holes
    translate([BORDER,HEIGHT/2]) {
      for(x =concat(0,cumsum(HOLE_SPACING))) hull() {
        translate([x,0]) circle(d=HOLE_DIA);
        // Tear drop to make print better
        translate([x,-HOLE_DIA*0.6]) rotate(0) circle(0.1);
      }
    }
  }
  translate([w/2,THICKNESS-0.4,10]) rotate([-90,180,0]) linear_extrude(0.4+0.01) text("Radio Bracket (M5)", size=8,halign="center",valign="center");
}

hooks(w, HEIGHT, "all", 10, true);


// add([1,2,3]) = [6]
function add(values, i = 0, r = 0) = i < len(values) ? add(values, i + 1, r + values[i]) : r;

// cumsum([1,2,3]) = [1,3,6]
function cumsum(values) = [ for (a=0, b=values[0]; a < len(values); a= a+1, b=b+(values[a]==undef?0:values[a])) b];
  
module hooks(x, y, mode="all", min_edge=10, flip=false) {
  hook_width = 5;
  hook_height = 15;
  cols = floor((x - 2*min_edge - hook_width)/20)+1;
  offsetX = (x - ((cols-1)*20)) / 2;
  echo("cols", cols)
  echo("offsetX", offsetX);

  rows = floor((y - 2*min_edge)/20)+1;
  offsetY = (hook_height/2) + (y - ((rows)*20)) / 4 + 10;
  echo("rows", rows)
  echo("offsetY", offsetY);

  translate([offsetX, 0, offsetY])
  for (col = [0:1:cols-1]) {
    for (row = [0:1:rows-1]) {
      echo(row, col, row%2, col%2);
      if (col%2 == 0 ? row%2 == (flip?0:1) : row%2 == (flip?1:0)) {
        is_bottom_row = col % 2 == 0 ? row == 0 : row == 1;
        if (mode == "all" ||
           (mode == "edge" && (
              col == 0 || // Left
              row == 0 || // Bottom
              col == cols-1 || // Right
              (col % 2 == 0 ? row == rows-1 : false))) // Top
          ) {
          //color(is_bottom_row ? "red" : "black")
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
