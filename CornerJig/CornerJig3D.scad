// Corner jig (CNC)

Height = 120;
Width = 140;
Thickness = 12;
Lip = 8;
LidThickness = 6;
BraceSetBack = 20;
SideRadius = 40;

BraceCutoutOffset = 18;
ClampWidth = 11.7 + 4;
ClampThickness = 7.4 + 2;

ScrewDia = 4.2;

BraceLength = Width - BraceSetBack;
Brace1Y = SideRadius-Thickness;
Brace2Y = Height - SideRadius;

$fn = 50;
difference() {
  union () {
    Body();
    difference() {
      Top();
      translate([Width/2,Width/2,-0.5])
        rotate([0,0,135])
          linear_extrude(1)
            text(str(Width, "x", Height), halign="center");
    }
  }
  ClampMasks();
}

module Body() {
  r = Thickness;
  ltl = Lip + Thickness;
  lwl = Lip + Width;
  eye = Lip + r/2;
  difference() {
    top = [
          [0, eye],
          [eye, eye],
          [eye, 0],
          [lwl, 0], [lwl, ltl],
          [ltl+ClampThickness*2+5,ltl+ClampThickness*2+5],
          [ltl, lwl], [0, lwl],
        ];
    // Top
    translate([-Lip,-Lip,0]) linear_extrude(Height) {
      difference() {
        offset(r) offset(-r*2) offset(r) polygon(top);
      }
    }    
    // Board cutouts
    translate([0,-Lip-1,0]) cube([Width*2, Lip+1, Height+1]);
    translate([0,-Lip-1,0]) rotate([0,0,90]) cube([Width*2, Lip+1, Height+1]);
    // Glue chamfer
    c = 6;
    linear_extrude(Height+1) polygon([
      [-0.1,-0.1], [c,0], [0,c]
    ]);
    // Angles
    a = Width/2 - ClampWidth - 5;
    for (r = [0,1]) rotate([0,0,r*90])
    translate([Width+0.01, -Thickness*3, Height+0.01]) rotate([0,90,90]) linear_extrude(Thickness*6) polygon([
      [0,0], [a,0], [0,a]
    ]);
  }
}


module Top() {
  translate([-Lip,-Lip,-LidThickness]) linear_extrude(LidThickness) {
    r = Thickness;
    ltl = Lip + Thickness;
    lwl = Lip + Width;
    eye = Lip + r/2;
    difference() {
      offset(r) offset(-r*2) offset(r) polygon([
        [0, eye],
        [eye, eye],
        [eye, 0],
        [lwl, 0], [lwl, ltl],
        [ltl, lwl], [0, lwl],
      ]);
    }
  }
}

module ClampMasks() {
    translate([Width/2,Thickness,-Thickness-1]) cube([ClampWidth, ClampThickness, Height+Thickness++2]);
  translate([Thickness,Width/2,-Thickness-1]) cube([ClampThickness, ClampWidth, Height+Thickness++2]);
}
