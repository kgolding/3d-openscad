// Router jig jig!

FromEdge = 70;
Width = 100.1;
InnerWidth = 40;
Wall = 5;

Length = FromEdge + InnerWidth * 1.5 + 50;

$fn = 100;

difference() {
  union() {
    // Plate
    cube([Width, Length, Wall]);
    // Sides
    translate([-Wall,0,0]) cube([Wall, Length, Wall*2]);
    translate([Width,0,0]) cube([Wall, Length, Wall*2]);
    translate([-Wall,-Wall,0]) cube([Width+Wall*2,Wall, Wall*2]);
  }
  // Cut out
  translate([Width/2,FromEdge, -1]) CutOut();
  // Corners
  translate([-Wall,-Wall,-1]) cylinder(r=3*Wall, h=3*Wall);
  translate([Width,-Wall,-1]) cylinder(r=3*Wall, h=3*Wall);
}

module CutOut() {
  translate([0,InnerWidth/2,0])
  linear_extrude(2*Wall) {
    hull() {
      circle(d=InnerWidth);
      translate([-InnerWidth/2,-InnerWidth/2]) square([InnerWidth, InnerWidth/2]);
    };
  }
}