// Stickvise PCB Vise Sakdis holder

WIDTH = 29;
HEIGHT = 100;

$fn=20;


// Rear plate
cube([WIDTH,5,100]);

// Front
difference() {
  // translate([0,0,HEIGHT-65]) cube([WIDTH,70,35]);
  translate([WIDTH,5,0]) rotate([0,-90,0]) linear_extrude(WIDTH) polygon([
    [0,0], [HEIGHT-0.1,0], [HEIGHT-0.1,60], [HEIGHT-10,70], [70,70]
  ]);
  
  // Two Vises slighting overlapping to create clearence
  translate([10,40,HEIGHT-200]) rotate([0,0,-90]) ViseMask();
  translate([10.5,40,HEIGHT-200]) rotate([0,0,-90]) ViseMask();
  // Cut out for wing nut side
  translate([5,30,0]) difference() {
    cube([WIDTH,60,70]);
    translate([0,0,70]) rotate([45,0,0]) cube([WIDTH*3,5,5], center=true);
  }
  // Cut out for rod
  //translate([6.5,35,0]) cube([7.5,50,HEIGHT]);
  // Bottom cutout
  translate([4.5,5,0]) cube([15,80,70]);
  
  translate([0.5,40,50])
    rotate([90,45,-90])
      linear_extrude(0.6)
        text("Stickvise", size=10, halign="center", valign="center");
}

// Hooks
hooks(WIDTH,100,min_edge=5);

module ViseMask() {
  cylinder(d=6,h=200);
  // Jaw offset is 5.5
  // Fixed jaw
  translate([0,19.5/2-5.5,200-13/2]) cube([71.5,19.5,13], center=true);
  // Sliding Jaw
  translate([0,19.5/2-5.5,200-13/2-13]) cube([71.5,19.5,13], center=true);
  // Sliding block with wing nut, plus the label!
  translate([0,(13+1)/2-5.5,200-13/2-13-13-15]) {
    cube([71.5,13+1,13], center=true);
    translate([-6,013/2,0]) rotate([-90,0,0]) cylinder(d=22,h=12);
  }
  // Block out for springs
  translate([0,(13+1)/2-5.5,200-13/2-13-14]) cube([71.5,(13+1),15], center=true);
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
