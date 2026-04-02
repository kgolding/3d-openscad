SCREW_CENTERS = 35;
PCB_W = 43 + 0.5;
TERM_H = 10;
MIC_H = 4.5;
BASE = 10;

$fn = 30;


// Base
difference() {
  translate([-PCB_W/2,-PCB_W/2,-BASE]) linear_extrude(BASE) offset(5) offset(-5) square([PCB_W, PCB_W]);
  
  // Gasket
  translate([0,0,-BASE-0.01]) difference() {
    G1 = PCB_W - 5;
    G2 = G1 - 2*4.5;
    translate([-G1/2, -G1/2, 0]) linear_extrude(3.5) offset(5) offset(-5) square(G1);
    translate([-G2/2, -G2/2, 0]) linear_extrude(3.5) offset(5) offset(-5) square(G2);
  }
  
  // Magnetic
  translate([0,0,-BASE-0.01]) cylinder(d=15.2,h=2);
}

// Mic stand
cylinder(r1=7.5, r2=5, h= TERM_H -MIC_H);

// Stands
SH = SCREW_CENTERS/2;
for (x=[-SH,SH]) for (y=[-SH,SH]) {
  translate([x,y,0]) cylinder(r=4,h=TERM_H);
  translate([x,y,TERM_H]) cylinder(r1=3/2, r2=(3/2)-0.5,h=2);
}
