// Corner jig (CNC)

Height = 160;
Width = 160;
Thickness = 12;
Lip = 15;
RearLip = 22;
BraceSetBack = 20;
SideRadius = 40;

BraceCutoutOffset = 18;
ClampSize = 12;

ScrewDia = 4.2;

BraceLength = Width - BraceSetBack;
Brace1Y = SideRadius-Thickness;
Brace2Y = Height - SideRadius;

Show = "All"; // ["All", "Brace", "Side 1", "Side 2", "Top"]

$fn = 50;

difference() {
  union() {
    if (Show == "All" || Show == "Brace") {
      translate([0,0,Brace1Y]) Brace();
      translate([0,0,Brace2Y]) Brace();
    }
    if (Show == "All" || Show == "Side 1") {
      Side();
    }
    if (Show == "All" || Show == "Side 2") {
      translate([-Thickness,0,0]) rotate([0,0,90]) Side(long=true);
    }
    if (Show == "All" || Show == "Top") {
      translate([0,0,Height]) Top();
    }
  }
  ClampMasks();
}

module ClampMasks() {
    translate([Width/2,0,-1]) cube([ClampSize, ClampSize, Height+Thickness++2]);
  translate([0,Width/2,-1]) cube([ClampSize, ClampSize, Height+Thickness++2]);
}

module Top() {
  linear_extrude(Thickness) translate([-Thickness-Lip, -Thickness-Lip]) {
    r = Thickness;
    ltl = Lip + Thickness + RearLip;
    lwl = Lip + Width + Lip;
    eye = Lip + r/2;
    difference() {
      offset(r) offset(-r*2) offset(r) polygon([
        [0, eye],
        [eye, eye],
        [eye, 0],
        [lwl, 0], [lwl, ltl],
        [ltl+BraceCutoutOffset, ltl], // Inside corner
        [ltl, ltl+BraceCutoutOffset], // Inside corner
        [ltl, lwl], [0, lwl],
      ]);
      // Screw holes
      lth = Lip+Thickness/2;
      translate([lth,lth]) {
        for (o = [Thickness*2, Width-Thickness]) {
          translate([o,0]) circle(d=ScrewDia);
          translate([0,o]) circle(d=ScrewDia);
        }
      }
    }
  }
}

module Side(long = false) {
  w = long ? Width+Thickness : Width;
  x = long ? -Thickness : 0;
  translate([x,0,0]) rotate([90,0,0]) linear_extrude(Thickness)
    difference() {
      hull() {
        square(1);
        translate([w- SideRadius, SideRadius]) circle(SideRadius);
        translate([w- 1, Height]) square(1);
        translate([0, Height]) square(1);
      }
      // Cutout
      translate([Thickness -x,Brace1Y + 2*Thickness,0]) offset(10) offset(-10) square([Width-BraceSetBack-Thickness, Brace2Y - Brace1Y - 3*Thickness]);
      for (y = [Brace1Y,Brace2Y]) {
        // Brace screw holes
        translate([Thickness-x,y+Thickness/2]) circle(d=ScrewDia);
        translate([BraceLength-Thickness*2-x,y+Thickness/2,-1]) circle(d=ScrewDia);
      }
      // Corner Screw holes
      if (long) {
        for (y = [Thickness/2,Height-(Brace1Y), Height/2])
          translate([Thickness/2,y]) circle(d=ScrewDia);
      }
    }
}

module Brace() {
  linear_extrude(Thickness) difference() {
    polygon([
      [0,0], [BraceLength, 0], [0, BraceLength]
    ]);
    // Corners
    // #translate([BraceLength-20, 0]) square(20);
    // Cutout
    offset(10) offset(-10) polygon([
      [BraceCutoutOffset, BraceCutoutOffset*2],
      [BraceCutoutOffset, BraceLength - BraceCutoutOffset*2],
      [BraceLength - BraceCutoutOffset*2, BraceCutoutOffset],
      [BraceCutoutOffset*2, BraceCutoutOffset],
    ]);
  }
}
