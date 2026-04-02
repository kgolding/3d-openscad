// PDU Mounting plate

WIDTH = 47.5;
LENGTH = 75;

TAB_WIDTH = 15;
TAB_LENGTH = 19;
TAB_SPACE = 1.5;
TAB_OFFSET = (LENGTH/2)-33;

difference() {
  // Plate
  linear_extrude(3.2) rounded_rectangle(WIDTH, LENGTH, 3);
  
  // Tab hole
  translate([0,-TAB_OFFSET-TAB_LENGTH/2,-1]) linear_extrude(5)
  {
    r = TAB_SPACE/2;
    osr = 2*TAB_SPACE/2;
    translate([TAB_WIDTH/2+r,0,0]) hull() {
      translate([-osr/2,-osr]) circle(osr);
      translate([0,TAB_LENGTH-r]) circle(r);
    }
    translate([-TAB_WIDTH/2-r,0,0]) hull() {
      translate([osr/2,-osr]) circle(osr);
      translate([0,TAB_LENGTH-r]) circle(r);
    }
    translate([TAB_WIDTH/2,0,0]) hull() {
      translate([-TAB_WIDTH+osr/2,-osr]) circle(osr);
      translate([-osr/2,-osr]) circle(osr);
    }
    translate([-TAB_WIDTH/2,-r, 0]) hull() {
      square([TAB_WIDTH, TAB_LENGTH]);
    }
  };
  
  // Screw holes
  translate([-27/2,-LENGTH/2 + 8.5,-1]) {
    cylinder(d=5,h=5);
    translate([27,0,0]) cylinder(d=5,h=5);
  }
}

// translate([0,TAB_OFFSET,0]) cylinder(d=1,h=10);

// Tab
//translate([-TAB_WIDTH/2,-TAB_OFFSET,0])
translate([TAB_WIDTH/2,TAB_OFFSET,0]) rotate([10,0,180]) linear_extrude(3.2) hull() {
  square([TAB_WIDTH, 1]);
  //translate([0,TAB_LENGTH]) square([TAB_WIDTH, 1]);
  r = 1.5;
  translate([r,TAB_LENGTH]) circle(r);
  translate([TAB_WIDTH-r,TAB_LENGTH]) circle(r);
}
  

$fn = 30;


// Rounded rectangle module
// w = width, h = height, r = corner radius
module rounded_rectangle(w, h, r) {
    if (r > min(w, h)/2) {
        r = min(w, h)/2; // Clamp radius so it doesn’t exceed rectangle size
    }
    offset(r) offset(-r)
        square([w, h], center=true);
}