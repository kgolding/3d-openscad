dinD = 7.5;
dinH = 35;
dinLip = 3;
dinT = 1.4;

dinW = 22.5;

SCREW_DIA = 4.4;
PLATE_THICKNESS = 4;
HOLE_TYPE = "Countersunk"; // ["Countersunk", "Hole"]

PLATE_HEIGHT = 80;
PLATE_WIDTH = 75;

INCLUDE_TOP_LIP = false;
TOP_LIP_THICKNESS = 2;

tiny = 0.01;
$fn=30;

// Backplate
difference() {
  SCREW_OFFSET = SCREW_DIA + 3;
  //translate([0,-PLATE_HEIGHT/2,-PLATE_THICKNESS]) cube([PLATE_WIDTH, PLATE_HEIGHT, PLATE_THICKNESS]);
  translate([0,0,-PLATE_THICKNESS]) hull() {
    r = SCREW_DIA*2;
    translate([r,-PLATE_HEIGHT/2+r,0]) cylinder(r=r,h=PLATE_THICKNESS);
    translate([r,PLATE_HEIGHT/2-r,0]) cylinder(r=r,h=PLATE_THICKNESS);
    translate([PLATE_WIDTH-r,-PLATE_HEIGHT/2+r,0]) cylinder(r=r,h=PLATE_THICKNESS);
    translate([PLATE_WIDTH-r,PLATE_HEIGHT/2-r,0]) cylinder(r=r,h=PLATE_THICKNESS);
  }
  
  // Screwholes
  translate([SCREW_OFFSET, PLATE_HEIGHT/2 - SCREW_OFFSET,0]) ScrewHole(); // Top left
  translate([SCREW_OFFSET, -PLATE_HEIGHT/2 + SCREW_OFFSET,0]) ScrewHole(); // Bottom left
  translate([PLATE_WIDTH-SCREW_OFFSET, PLATE_HEIGHT/2 - SCREW_OFFSET,0]) ScrewHole(); // Top right
  translate([PLATE_WIDTH-SCREW_OFFSET, -PLATE_HEIGHT/2 + SCREW_OFFSET,0]) ScrewHole(); // Bottom right
//  translate([dinD+SCREW_OFFSET, 0,0]) ScrewHole(); // Center near DIN rail
//  translate([PLATE_WIDTH-SCREW_OFFSET, 0,0]) ScrewHole(); // Center right
  
  translate([PLATE_WIDTH/2,dinH/2+6,-0.5]) linear_extrude(0.5+tiny) rotate([0,0,180])
    text("smc-gateway.com", size=6, halign="center", valign="center");
  translate([PLATE_WIDTH/2,PLATE_HEIGHT/2 - SCREW_OFFSET,-0.5]) linear_extrude(0.5+tiny) rotate([0,0,180])
    text("GT3-ACC-DIN-90", size=4.5, halign="center", valign="center");
  translate([PLATE_WIDTH/2,-PLATE_HEIGHT/2+SCREW_OFFSET,-0.5]) linear_extrude(0.5+tiny) rotate([0,0,180])
    text("TOP", size=7, halign="center", valign="center");
}

// Dinrail
difference() {
  linear_extrude(dinW + (INCLUDE_TOP_LIP ? TOP_LIP_THICKNESS : 0)) polygon([
    // Back
    [0,-dinH/2+dinLip], [0,dinH/2-dinLip],
    // Top
    [dinD-dinT,dinH/2-dinLip],[dinD-dinT,dinH/2],
    [dinD,dinH/2],
    // Bottom
    [dinD,-dinH/2],
    [dinD-dinT,-dinH/2],[dinD-dinT,-dinH/2+dinLip]
  ]);

    if (!INCLUDE_TOP_LIP) {
      // Chamfer top edge
      translate([0,0,dinW]) rotate([0,45,0]) cube([3,dinH,3], center=true);
    }
}

// DIN Rail top lip
if (INCLUDE_TOP_LIP) {
 translate([dinD, -dinH/2, dinW]) cube([2, dinH, TOP_LIP_THICKNESS]) ;
}

module ScrewHole() {
    translate([0,0,-PLATE_THICKNESS-tiny]) cylinder(d=SCREW_DIA, h=PLATE_THICKNESS+2*tiny, center=false, $fn=20);
    if (HOLE_TYPE == "Countersunk") {
        translate([0,0,tiny-SCREW_DIA/2]) cylinder(r1=SCREW_DIA/2, r2=SCREW_DIA, h=SCREW_DIA/2, center=false, $fn=20);
    }
}



