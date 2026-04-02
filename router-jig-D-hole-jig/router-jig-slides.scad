// Router jig slides

Width = 100;
SlotSize = 9.4;
Depth = 6.7 - 0.4;
CenterHoleDia = 8;
ScrewDia = 4.2;
BoltHeadWidth = 23 + 1;
LipThickness = 2.3 - 0.5;

$fn=50;

difference() {
  // Body
  translate([0,0,-Depth]) hull() {
    translate([SlotSize/2, SlotSize/2, 0]) cylinder(d=SlotSize, h=Depth);
    translate([SlotSize/2, Width-SlotSize/2, 0]) cylinder(d=SlotSize, h=Depth);
  }
  // Center hole
  translate([SlotSize/2, Width/2, -Depth-1]) cylinder(d=CenterHoleDia, h = Depth+2);

  // Bolt head
  translate([-1, Width/2-BoltHeadWidth/2, -Depth+LipThickness]) cube([SlotSize+2, BoltHeadWidth, Depth]);
  // Bolt head countersink for weld seam
  translate([SlotSize/2, Width/2, -Depth+LipThickness/2+0.01])
    cylinder(r1=CenterHoleDia/2, r2=CenterHoleDia/2+(SlotSize-CenterHoleDia)/2-0.2, h=LipThickness/2);

  // Screw holes
  translate([SlotSize/2, ScrewDia*2, -1]) ScrewHole(ScrewDia, Depth);
  translate([SlotSize/2, Width-ScrewDia*2, -1]) ScrewHole(ScrewDia, Depth);
}

module ScrewHole(d, h, rebate=0.5) {
  // Screw hole
  translate([0,0,-h]) cylinder(d=d, h=h, $fn=50);
  hull() {
    // Countersink
    translate([0,0,rebate-d/2]) cylinder(r1=d/2, r2=d, h=d/2, $fn=50);
    // Top clearance
    translate([0,0,rebate]) cylinder(r=d, h=rebate+.01, $fn=50);
  }
}