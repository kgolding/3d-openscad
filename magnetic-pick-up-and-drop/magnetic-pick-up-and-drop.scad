
MAGNET_DIA = 15;
MAGNET_HEIGHT = 2;
WALL = 3;
SCREEN_THICKNESS = 1;
HEIGHT = 40;
PLUNGER_DIA = 5;

$fn=50;
bodyDia = MAGNET_DIA + WALL * 2;

Plunger();
translate([0,MAGNET_DIA+20,0]) Body();

module Body() {
  difference() {
    t2 = SCREEN_THICKNESS/2;
    union() {
      // Body
      translate([0,0,t2]) cylinder(d=MAGNET_DIA + WALL, h=HEIGHT-t2);
      // Bottom chamfer
      cylinder(r1=(MAGNET_DIA + WALL)/2-0.5, r2=(MAGNET_DIA + WALL)/2, h=t2);
    }
    // Inside mask
    translate([0,0,SCREEN_THICKNESS]) cylinder(d=MAGNET_DIA + 0.5, h=HEIGHT);
  }
}

module Plunger() {
  union() {
    difference() {
      union() {
        // Magnet plate
        translate([0,0,0]) cylinder(d=MAGNET_DIA, h=2);
        // Top plate with chamfer
        translate([0,0,HEIGHT]) cylinder(d=MAGNET_DIA + WALL, h=1);
        translate([0,0,HEIGHT+1]) cylinder(r1=(MAGNET_DIA + WALL)/2, r2=(MAGNET_DIA + WALL)/2-0.5, h=0.5);
        // Inner top plate
        translate([0,0,HEIGHT-2]) cylinder(d=MAGNET_DIA + 0.5, h=2);

        // Spring
        springW = (MAGNET_DIA-PLUNGER_DIA)/2;
        linear_extrude(height=HEIGHT-2,twist=360*3,slices=HEIGHT/0.1)
          rotate(15)
            translate([(PLUNGER_DIA+1.6)/2,0])
              square([2,springW]);
      }
      
      // Top plate hole for plunger
      translate([0,0,HEIGHT - 2.001]) cylinder(d=PLUNGER_DIA+.6, h=5);

    }
    // Central shaft
    translate([0,0,2]) cylinder(d=PLUNGER_DIA, h=HEIGHT+5);
    // Central stop
    translate([0,0,2]) cylinder(d=PLUNGER_DIA+1, h=HEIGHT/2);
    // Knob
    translate([0,0,2 + HEIGHT + 4]) sphere(PLUNGER_DIA);
  }
}
