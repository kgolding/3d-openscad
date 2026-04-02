t = 0.15;
// Relay board
RB_WIDTH = 52.4 + t;
RB_LENGTH = 134.2 + t; // 134.2
RB_HEIGHT = 30 + t;
RB_THICKNESS = 1.6 + t;

// ESP32
D1_WIDTH = 28.4 + t;
D1_LENGTH = 51.6 + t;
D1_HEIGHT = RB_HEIGHT;
D1_THICKNESS = 1.1 + t;

// Enclosure
WALL = 3;
GAP = 5; // Between boards
PCB_BOTTOM_CLEARENCE = 5; // For wires
PCB_SLOT = 1; // Slot for PCB depth

w = RB_WIDTH + 2 * WALL;
d = WALL + RB_LENGTH + GAP + D1_WIDTH + WALL;
h = WALL + PCB_BOTTOM_CLEARENCE + RB_HEIGHT + 2 + WALL;

echo(d);

$fn = 30;

// projection(true) rotate([90,0,0]) translate([0,-d+30,0])

// Bottom
difference() {
  FULL();
  translate([-20,-20,h - WALL-0.1]) cube([w+40,d+40,WALL+1]);
}

// Lid
translate([100,0,0]) {
  difference() {
    translate([0,0,0]) FULL();
    translate([-20,-20,-0.1]) cube([w+40,d+40,h-WALL+0.1]);
    translate([w/2-8, d/2, h-0.5]) linear_extrude(1) rotate(90)
      text("ESPHOME 8 Relays", halign="center", valign="center", size=12);
    translate([w/2+8, d/2, h-0.5]) linear_extrude(1) rotate(90)
      text("WARNING - 240VAC", halign="center", valign="center", size=12);
  }
  // Relay board
  of = 0.1;
  translate([WALL+of, WALL+of, h-WALL-2+0.001]) {
    cube([RB_WIDTH-2*of, RB_LENGTH-2*of, 2]);
  }
  // ESP
  translate([WALL+of, WALL + RB_LENGTH + GAP+of, h-WALL-2+0.001]) {
    cube([D1_LENGTH-2*of, D1_WIDTH-2*of, 2]);
  }
}

module FULL() {
  difference() {
    
    union() {
      // Main body
      cube([w, d, h]);
      
      // Mountings
      lug_offset = 10;
      translate([0, lug_offset,0]) LUG(0);
      translate([0, 182.5-lug_offset-D1_WIDTH,0]) LUG(0);
      translate([w, lug_offset,0]) LUG(180);
      translate([w, 182.5-lug_offset-D1_WIDTH,0]) LUG(180);
    }
    
    // Relay board
    translate([WALL, WALL, WALL]) {
      PCB_HOLE(RB_WIDTH, RB_LENGTH, RB_HEIGHT, RB_THICKNESS);
      // Mains terminals
      translate([RB_WIDTH-1, 6, PCB_BOTTOM_CLEARENCE + RB_THICKNESS]) cube([WALL + 2, RB_LENGTH - 2 * 6, 7]);
      // Link wires
      translate([6, RB_LENGTH-1, PCB_BOTTOM_CLEARENCE + RB_THICKNESS + RB_HEIGHT/2]) cube([10, GAP + 2, RB_HEIGHT/2+0.2]);
    }
    
    // D1 Mini
    translate([WALL, WALL + RB_LENGTH + GAP, WALL]) {
      PCB_HOLE(D1_LENGTH, D1_WIDTH, D1_HEIGHT, D1_THICKNESS);
      // USB
      USB_W = 14;
      USB_H = 8;
      translate([0, D1_WIDTH/2, PCB_BOTTOM_CLEARENCE + D1_THICKNESS + 1.6]) cube([WALL * 4, USB_W, USB_H], center=true);
    }
    
    // Screw holes
//    translate([WALL + 3, WALL + 3, 0]) SCREWHOLE();
//    translate([WALL + RB_WIDTH - 3, WALL + 3, 0]) SCREWHOLE();
//    translate([WALL + 3, WALL + RB_LENGTH - 3, 0]) SCREWHOLE();
//    translate([WALL + RB_WIDTH - 3, WALL + RB_LENGTH - 3, 0]) SCREWHOLE();
  }
  
  // Relay board pillers
  translate([WALL, WALL, 0]) SCREWPILLER();
  translate([WALL + RB_WIDTH, WALL, 0]) rotate(90) SCREWPILLER();
  translate([WALL + RB_WIDTH, WALL + RB_LENGTH, 0]) rotate(180) SCREWPILLER();
  translate([WALL, WALL + RB_LENGTH, 0]) rotate(270) SCREWPILLER();
  
  translate([WALL, WALL + RB_LENGTH + GAP, 0]) {
    SCREWPILLER();
    translate([D1_LENGTH, 0, 0]) rotate(90) SCREWPILLER();
    translate([D1_LENGTH, D1_WIDTH, 0]) rotate(180) SCREWPILLER();
    translate([0, D1_WIDTH, 0]) rotate(270) SCREWPILLER();
  }
}

module SCREWPILLER() {
  dia = 2.7;
  r = dia/2;
  offset = 3;
  q = offset + dia;
  
  translate([0,0,WALL]) difference() {
    //linear_extrude(PCB_BOTTOM_CLEARENCE) polygon([[0,0], [0,q], [q,0]]);
    hull() {
      cube([q,1,PCB_BOTTOM_CLEARENCE]);
      cube([1,q,PCB_BOTTOM_CLEARENCE]);
      translate([offset,offset,0]) cylinder(d=5.5, h=PCB_BOTTOM_CLEARENCE);
    }
    translate([offset, offset,0]) cylinder(r=r, h=PCB_BOTTOM_CLEARENCE+t);
    // cylinder(r1=r*2, r2 = r, h=r+0.1);
    //translate([0,0,h-r+0.1]) cylinder(r1=r, r2=r*2, h=r+0.1);
  }
}

module SCREWHOLE() {
  dia = 3.3;
  r = dia/2;
  translate([0,0,-0.1]) {
    cylinder(r=r, h=h+0.2);
    cylinder(r1=r*2, r2 = r, h=r+0.1);
    //translate([0,0,h-r+0.1]) cylinder(r1=r, r2=r*2, h=r+0.1);
  }
}

module LUG(rotate = 0) {
  lw = 10;
  ld = 8.8;
  dia = 3.3;
  r = dia / 2;
  translate([0.01,0,0]) rotate([0, 0, rotate + 90]) translate([-lw/2,0,0]){
    difference() {
      hull() {
        cube([lw, 0.11, WALL* 2]);
        translate([lw/2 ,ld-lw/2, 0]) cylinder(d=lw, h = WALL);
      }
      // Screwhole
      translate([lw/2,ld - lw/2, -0.1]) {
        cylinder(d=3.3, h=WALL*2);
        translate([0,0,WALL+0.4]) {
          cylinder(d=3.3*2, h=WALL*2);
          translate([0,0,-r+0.01]) cylinder(r1=r, r2=dia, h=r);
        }
      }
    }
  }
}


module PCB_HOLE(width, length, height, pcb_thickness) {
  // PCB Sized hole
  translate([0,0,PCB_BOTTOM_CLEARENCE]) cube([width, length, height+2]);
  // Bottom clearence
  translate([PCB_SLOT,PCB_SLOT,0]) cube([width- 2 * PCB_SLOT, length - 2 * PCB_SLOT, PCB_BOTTOM_CLEARENCE + 1]);
}



