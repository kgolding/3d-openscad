// Aston Martin jacking spacer

$fn = 60;

difference() {
  hull() {
    linear_extrude(0.1) plate();
    translate([80-PIN_DIA/2, 24.5-PIN_DIA/2, 40]) linear_extrude(0.1) circle(d=80);
  }
  PIN_DIA = 19 + 1;
  PIN_HEIGHT = 8 + 2;
  translate([80-PIN_DIA/2, 24.5-PIN_DIA/2, -0.01]) cylinder(d=PIN_DIA, h=PIN_HEIGHT);
}

module plate() {
  hull() {
    translate([12.5, 12.5]) circle(12.5);
    translate([0,74.5]) translate([6.5, -6.5]) circle(6.5);
    translate([0,74.5]) translate([6.5, -6.5]) circle(6.5);
    translate([108.8,0]) translate([-6, 6]) circle(6);
    translate([108.8,26.5]) translate([-6, -6]) circle(6);
  }
}