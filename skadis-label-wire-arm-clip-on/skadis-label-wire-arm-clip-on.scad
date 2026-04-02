// SKADIS large hook label

// Recommend adding 2 mm to label width
Width = 52;
// Recommend adding 2 mm to label height
Height = 32;
// Corner radius
Radius = 1.5;
// Thickness in addition to the wire size
Thickness = 1;
// Thickness of the IKEA wire clip
WireDia = 4.4;
// Clip overlap determines how tight it is to push the clip on
ClipOverlap = 0.6;

$fn = 50;

assert(Radius < Width/2);
assert(Radius < Height/2);

t = Thickness + WireDia + ClipOverlap;


difference() {
  // Plate
  if (Radius < 0.1) {
    cube([Width, t, Height]);
  } else {
    translate([0,t,0]) rotate([90,0,0]) hull() {
      translate([Radius, Radius, 0]) cylinder(r=Radius, h=t);
      translate([Width-Radius, Radius, 0]) cylinder(r=Radius, h=t);
      translate([Width-Radius, Height-Radius, 0]) cylinder(r=Radius, h=t);
      translate([Radius, Height-Radius, 0]) cylinder(r=Radius, h=t);
    }
  }
  translate([0,0,0.5]) { // Push down from top
    // Main Wire
    translate([Width/2,WireDia/2 - 0.1, WireDia/2]) cylinder(d=WireDia, h=Height);
    w = WireDia - ClipOverlap;
    // Cutout to let wire push in
    translate([Width/2 - w/2, -WireDia/2, WireDia/2]) cube([w, WireDia, Height+2]);
    // Wider part to let top of clip fit
    hull() {
      translate([Width/2,WireDia/2,WireDia/2]) sphere(WireDia/2);
      translate([Width/2,-WireDia,WireDia/2-1]) sphere(WireDia/2);
      // Enlongated to allow for the internal radius
      translate([Width/2,WireDia/2,WireDia/2+1]) sphere(WireDia/2);
    }
  }
  // Bottom cut for the locating pin whish is 30 mm from the top
  translate([Width/2 - WireDia/2, -WireDia/2, 30]) cube([WireDia, WireDia, Height]);
}
