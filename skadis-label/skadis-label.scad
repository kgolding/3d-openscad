// SKADIS Label

Width = 50;
Height = 30;
Thickness = 2.5;
Radius = 1.5;
HookFromTop = 7.5;
$fn = 50;

assert(Radius < Width/2);
assert(Radius < Height/2);

// Plate
if (Radius < 0.1) {
  cube([Width, Thickness, Height]);
} else {
  translate([0,Thickness,0]) rotate([90,0,0]) hull() {
    translate([Radius, Radius, 0]) cylinder(r=Radius, h=Thickness);
    translate([Width-Radius, Radius, 0]) cylinder(r=Radius, h=Thickness);
    translate([Width-Radius, Height-Radius, 0]) cylinder(r=Radius, h=Thickness);
    translate([Radius, Height-Radius, 0]) cylinder(r=Radius, h=Thickness);
  }
}

// Hook(s)
// Assume they only need one or 2 hooks
z = Height - HookFromTop;
if (Width < 50) { // 1 hook
  translate([Width/2, 0, z]) hook();
} else { // 2 Hooks
  x = (Width - 40) / 2;
  translate([x, 0, z]) hook();
  translate([x + 40, 0, z]) hook();
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
  // 6 gives us enough facets to create a easy to print angle
  $fn = 6;

  translate([0, -d*2, -wt/2]) rotate([270, 90,0]) union() {
    // The larger part of the peg
    hull() {
      //cylinder(d=wt, h=d+0.3);
      // -0.1 is the taper applied to the face that makes contact with the back on the pegboard
      translate([h2 - w - t * 2, 0, 0]) cylinder(d=wt, h=d+0.0);
      // -0.3 is the taper applied to the face that makes putting the hook on easier
      translate([ht-w, 0, 0]) cylinder(d=wt, h=d-0.3);
    }
    // The smaller part of the peg
    translate([0, 0, 0]) hull() {
      cylinder(d=wt, h = d * 2);
      translate([h2 - w - t * 2 ,0 ,0]) cylinder(d=wt, h=d * 2);
      };
  }
}
