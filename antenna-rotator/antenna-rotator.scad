
x = 50;
y = 55;
h = 250;
wall = 5;

tiny = 0.01;

//NemaBracket(42,100,true);

shaftDistanceCenters = 51;

difference() {
  translate([x/2,0,0]) PoleBracket();
  translate([-tiny,0,-50]) NemaBracket(42, shaftDistanceCenters - x/2, true);
}

translate([-2,0,-50]) NemaBracket(42, shaftDistanceCenters - x/2);

module PoleBracket() {
  bearingH = 12;
  bearingDia = 40;
  bearingShelfH = 3;
  bearingLipT = 3;
  
  difference() {
    translate([0,0,-h/2]) cube([x,y,h], center=true);
    // Hollow out
    translate([wall,0,-h/2]) cube([x,y-wall*2,h-bearingH*2-bearingShelfH*2], center=true);
    // Bearings
    for (q=[0:1]) {
      z = q == 0 ? 0 : -h+bearingH+bearingShelfH;
      translate([0,0,z]) cylinder(d=bearingDia, h=bearingH*2, center=true);
      translate([0,0,z]) cylinder(d=bearingDia-bearingLipT*2, h=bearingH*4, center=true);
    }
  }
}

module NemaBracket(motorH=40, shaftFromEdge=30, mask=false) {
  pt = 4; // Plate thickness
  px = 42.3/2 + shaftFromEdge;
  py = 42.3 + pt*2 + 1;
  
  echo(shaftFromEdge, px, py);
  assert(shaftFromEdge > 42.3/2+pt, "Shaft from edge must be greate than half the motor size plase the plate thickness");
  
  translate([-px+42.3/2,0,0]) {
    difference() {
      union() {
        // Top plate
        translate([-42.3/2,-py/2,0]) cube([px,py,pt]);
        // Back plate
        translate([px-42.3/2-pt,-py/2,-motorH]) cube([pt,py,motorH]);
        // Sides
        sidePoints = [[0,0], [px-pt,0], [px-pt,motorH]];
        translate([-42.3/2,-py/2,0]) rotate([-90,0,0]) linear_extrude(pt) polygon(sidePoints);
        translate([-42.3/2,py/2-pt,0]) rotate([-90,0,0]) linear_extrude(pt) polygon(sidePoints);
      }
      // Stepper motor
      translate([0,0,-tiny]) NemaStepperMotor(motorH, true);
      // Fixing holes
      translate([px-42.3/2-pt/2,0,-20]) Fixings() cylinder(r1=8.2/2, r2=4.2/2, h=pt+tiny*3, $fn=20,center=true);
    }
    if (mask) {
      translate([px-42.3/2-pt/2,0,-20]) Fixings() cylinder(d=4.2+tiny, h=20, $fn=20,center=true);
      // Belt slot
      translate([42.3/2,0,24/2]) cube([px,py-12,12], center=true);
    }
  }
}

module Fixings() {
  rotate([0,90,0])
    for (m=[0:90:360])
      rotate([0,0,m]) 
        translate([15,15,-tiny])
          children();
}


//translate([50,0,0]) NemaStepperMotor();
//%NemaStepperMotor(40, true);

module NemaStepperMotor(h=40, mask=false) {
  w = 42.3;   // Width of the sides
  pt = 2;     // Round plate thickness
  pd = 22;    // Round plate diameter
  clearance = 0.5; // Clearance gets added to the mask
  boltDistanceCenters = 31;
  
  // Shaft
  translate([0,0,pt]) cylinder(d=5,h=24,$fn=20);
  // Round plate
  cylinder(d=pd,h=pt,$fn=50);
  // Body
  difference() {
    translate([-w/2,-w/2,-h]) cube([w,w,h]);
    // Chamfers
    for(m=[0:90:360])
      rotate([0,0,m])
        translate([-w/2,-w/2,-h/2]) rotate([0,0,45]) cube([5,5,h+pt+10], center=true);
    // Mounting holes
    for(m=[0:90:360])
      rotate([0,0,m])
        translate([31/2,31/2,-4.5-tiny]) rotate([0,0,45]) cylinder(d=3,h=4.5+tiny*2,$fn=20);
  }
  if (mask) {
    // Extend round plate
    cylinder(d=pd+clearance,h=pt*3,$fn=50);
    // Bolts
    for(m=[0:90:360])
      rotate([0,0,m]) {
        // Bolt
        translate([boltDistanceCenters/2,boltDistanceCenters/2,-tiny]) rotate([0,0,45]) cylinder(d=3+clearance,h=5.5+tiny,$fn=20);
        // Bolt head
        translate([boltDistanceCenters/2,boltDistanceCenters/2,5.5]) rotate([0,0,45]) cylinder(d=6,h=3,$fn=20);
      }
  }
}