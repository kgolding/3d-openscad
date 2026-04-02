// Template using transfer center punch
// https://www.amazon.co.uk/dp/B0D5GTQ5LW

SELECT = "LargeEnclosureRadioBracket"; // ["LargeEnclosureRadioBracket", "LargeEnclosurePSU", "LargeEnclosureDIN", "Test", "DrawerRadioBracket", "DrawerPSU"]
TEXT_ONLY = false;
WALL = 5;

// ****************************************** LargeEnclosureRadioBracket
if (SELECT == "LargeEnclosureRadioBracket") {
  LargeEnclosureRadioBracket(children_only=TEXT_ONLY) {
    color("black") Text(5, $PARENT_H-5, "^ REAR TOP LEFT - ENC-DIN-WPB", size=8, halign="left", valign="top");
  };
// ****************************************** LargeEnclosurePSU
} else if (SELECT == "LargeEnclosurePSU") {
  LargeEnclosurePSU(children_only=TEXT_ONLY) {
    color("black") {
      Text(-5, -5, "REAR TOP RIGHT^", size=8, halign="right", valign="top");
      rotate([0,0,90]) Text(-20, $WIDTH-5, "ENC-DIN-WPB", size=8, halign="right", valign="top");
    }
  };
// ****************************************** LargeEnclosureDIN
} else if (SELECT == "LargeEnclosureDIN") {
  LargeEnclosureDIN(TEXT_ONLY) {
    rotate([0,0,90]) Text($h/2, -5, "ENC-DIN-WPB", size=8, halign="center", valign="top");
    Text($w/2, 5, "< BOTTOM >", size=8, halign="center", valign="bottom");
  };
// ****************************************** DrawerRadioBracket
} else if (SELECT == "DrawerRadioBracket") {
  DrawerRadioBracket(TEXT_ONLY) {
    #rotate([0,0,180]) TextBR(-5, 13, "ENC-DIN-RMB - INSIDE FRONT RIGHT >", size=7);
  }
// ****************************************** DrawerPSU
} else if (SELECT == "DrawerPSU") {
  DrawerPSU(TEXT_ONLY) {
    TextBR(-5, 5, "ENC-DIN-RMB - INSIDE FRONT RIGHT >", size=7);
  }
}

tiny = 0.01;
tiny2 = 2 * tiny;
$fn = 25;

module LargeEnclosureDIN(children_only=false) {
  offset_x = 17.5; // 6 for the 325 mm slotted at ends DIN rail
  offset_y = 110;
  $h = offset_y + 15;
  $w = 80;
  r = 5;
  b = 20;
    if (children_only) {
    children();
  } else {
    difference() {
      linear_extrude(WALL) rounded_rect($w,$h);
      translate([offset_x,offset_y,-tiny]) PunchHole();
      translate([$w-offset_x,offset_y,-tiny]) PunchHole();
      translate([b,b,-tiny]) linear_extrude(WALL+tiny2) rounded_rect($w-2*b,offset_y-2*b);
      children();
    }
  }
}

module DrawerPSU(children_only=false) {
  offset_x = 85; // To top right hole
  offset_y = 85;
  border = 20;
  w = offset_x + 86.5 + border;
  h = offset_y + border;
  if (children_only) {
    children();
  } else {
    difference() {
      translate([-w, 0]) linear_extrude(WALL) rounded_rect(w, h);
      translate([-offset_x-86.5, offset_y-30]) rotate([0,0,90]) AD_PSU_HOLES() PunchHole();
      translate([-offset_y-86.5+border,border,-tiny]) linear_extrude(WALL+tiny2) rounded_rect(86.5-2*border, offset_x-border/2);
      translate([-offset_y+border,border,-tiny]) linear_extrude(WALL+tiny2) rounded_rect(offset_y-2*border, offset_x-border/2);
      children();
    }
  }
}

module LargeEnclosurePSU(children_only=false) {
  w = 120;
  h = 180;
  offset_x = 60;
  offset_y = 80;
  border = 20;
  // For the children
  $WIDTH = w;
  $HEIGHT = h;
  if (children_only) {
    children();
  } else {
    difference() {
      translate([-w, -h]) linear_extrude(WALL) rounded_rect(w, h);
      translate([-offset_x, -offset_y]) AD_PSU_HOLES() PunchHole();
      translate([-w+border,-offset_y+border/2,-tiny]) linear_extrude(WALL+tiny2) rounded_rect(w-2*border, offset_x-border/2);
      translate([-w+border,-offset_y-86.5+border/2,-tiny]) linear_extrude(WALL+tiny2) rounded_rect(w-2*border, 86.5-border);
      children();
    }
  }
}

module AD_PSU_HOLES() {
  holesRelative = [[0,0], [-86.5, -30], [-86.5, 30]];
  for (p = holesRelative) {
    translate([p.y,p.x,0]) children();
  }
}

module LargeEnclosureRadioBracket(children_only=false) {
  w = 200;
  h = 150;
  border = 25;
  $PARENT_W = w;
  $PARENT_H= h;
  if (children_only) {
    children();
  } else {
    difference() {
      linear_extrude(WALL) rounded_rect(w,h);
      translate([border,border,-tiny]) linear_extrude(WALL+tiny2) rounded_rect(w-2*border,h-2*border);
      // Bracket is 140mm from top
      translate([w/2,h-140,0]) RadioBracketFromCenter();
      children();
    }
  }
}

module DrawerRadioBracket(children_only=false) {
  side_offset = 62+(14+92+14)/2; // To center of bracket holes
  top_offset = 154;
  border = 25;
  h = top_offset + border/2;
  w = side_offset + (14+92+14)/2 + border;
  if (children_only) {
    children();
  } else {
    difference() {
      translate([0,-h,0]) linear_extrude(WALL) rounded_rect(w-13,h);
      translate([side_offset,-top_offset,0]) RadioBracketFromCenter();
      // Hole inside
      translate([border,-top_offset+border/2,-tiny]) linear_extrude(WALL+tiny2) rounded_rect(w-2*border-13,top_offset-1.5*border);
      // Screws
      sd = 10;
      sw = 8;
  //    translate([49-sw/2,-sd,-tiny]) cube([sw,sd+tiny,WALL+tiny2]); // @TODO
  //    *translate([199-sw/2,-sd,-tiny]) cube([sw,sd+tiny,WALL+tiny2]);// @TODO
      for (so = [49,199]) {
        translate([so-sw/2,-sd,-tiny]) {
          // T Shape for panel screw cut out
          linear_extrude(WALL+tiny2) offset(3) offset(-3) offset(-3) offset(3) {
            square([sw,sd]);
            translate([-sw,sd]) square([3*sw,sd]);
            
          }
        }
      }
      children();
    }
  }
}

module RadioBracketFromCenter() {
  // Spaced at 14, 92, 14
  translate([-(14+92+14)/2,0,0]) {
    // From far left hole
    PunchHole();
    translate([14,0,0]) PunchHole();
    translate([14+92,0,0]) PunchHole();
    translate([14+92+14,0,0]) PunchHole();
  }
}

module PunchHole() {
  // Pin diameter is 5 mm and we need the hole a little bigger
  pin_dia = 5;
  r1 = (pin_dia-1) / 2; 
  r2 = r1 + WALL;
  // Pin hole
  translate([0,0,-0.01]) cylinder(d=pin_dia+0.1,h=WALL+0.02,$fn=30);
  // Countersink
  translate([0,0,1]) cylinder(r1=r1,r2=r2,h=WALL,$fn=30);
}

module TextTL(x, y, text, size=8) {
  Text(x, y, text, size=size, halign="left", valign="top");
}

module TextTR(x, y, text, size=8) {
  Text(x, y, text, size=size, halign="right", valign="top");
}

module TextBR(x, y, text, size=8) {
  Text(x, y, text, size=size, halign="right", valign="bottom");
}

module Text(x, y, text, size=8, halign="center", valign="center") {
  depth = 0.4;
  color("white") translate([x,y,WALL-depth]) linear_extrude(depth+tiny)
    text(text, size=size, halign=halign, valign=valign);
}

module rounded_rect(x,y,r=5) {
  hull() {
    translate([r,r,0]) circle(r=r);
    translate([x-r,r,0]) circle(r=r);
    translate([x-r,y-r,0]) circle(r=r);
    translate([r,y-r,0]) circle(r=r);
  }
}