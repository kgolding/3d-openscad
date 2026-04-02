// Ply lined box
// Export cutlist using https://kgolding.github.io/openscad-bom/

INSIDE_X = 550;
INSIDE_Y = 420;
INSIDE_Z = 220;

PLYWOOD = 5.55;
FRAME_WIDTH = 32.5;
FRAME_DEPTH = 20;

SHOW_INSIDE = false;
LID_ANGLE = 5;

// Shortcuts
FDP = FRAME_DEPTH+PLYWOOD;

// Outside dimensions (exc lid)
OSX = INSIDE_X + 2*FDP;
OSY = INSIDE_Y + 2*FDP;
OSZ = INSIDE_Z + FDP;

// INSIDE
if (SHOW_INSIDE) {
  %translate([FDP,FDP,FDP]) cube([INSIDE_X, INSIDE_Y, INSIDE_Z]);
}
// OUTSIDE
//#color("silver", 0.1) cube([OSX, OSY, OSZ]);

// Lid
translate([0,OSY,OSZ+FDP]) rotate([180-LID_ANGLE,0,0]) Frame(OSX, OSY, colour="silver");

// Bottom
Frame(OSX, OSY, colour="green");
// Front
translate([0,0,OSZ]) rotate([-90,0,0]) Frame(OSX, OSZ-FRAME_DEPTH, colour="purple");
// Rear
translate([0,OSY,FRAME_DEPTH]) rotate([90,0,0]) Frame(OSX, OSZ-FRAME_DEPTH, colour="purple");
// Left
translate([0,FRAME_DEPTH,FRAME_DEPTH]) rotate([90,0,90]) Frame(OSY-2*FRAME_DEPTH, OSZ-FRAME_DEPTH, colour="blue");
// Right
translate([OSX,OSY-FRAME_DEPTH,FRAME_DEPTH]) rotate([90,0,-90]) Frame(OSY-2*FRAME_DEPTH, OSZ-FRAME_DEPTH, colour="blue");

module Frame(l,h, colour="") {
//  if (ply) {
//    translate([0,0,FRAME_DEPTH]) color("pink") cube([l,h,PLYWOOD]);
//  }
  color(colour == "" ? "yellow" : colour) {
    // Bottom
    tcube([l, FRAME_WIDTH, FRAME_DEPTH]);
    // Top
    translate([0, h-FRAME_WIDTH, 0]) tcube([l, FRAME_WIDTH, FRAME_DEPTH]);
    // Left
    translate([0, FRAME_WIDTH, 0]) tcube([FRAME_WIDTH, h - 2*FRAME_WIDTH, FRAME_DEPTH]);
    // Right
    translate([l-FRAME_WIDTH, FRAME_WIDTH, 0]) tcube([FRAME_WIDTH, h - 2*FRAME_WIDTH, FRAME_DEPTH]);
    // Center
    if (l > h && l-2*FRAME_WIDTH > 300) {
      translate([l/2-FRAME_WIDTH/2, FRAME_WIDTH, 0]) tcube([FRAME_WIDTH, h - 2*FRAME_WIDTH, FRAME_DEPTH]);
    } else if (h > l && h-2*FRAME_WIDTH > 300) {
      translate([h/2-FRAME_WIDTH, FRAME_WIDTH,0]) tcube([FRAME_WIDTH, h - 2*FRAME_WIDTH, FRAME_DEPTH]);
    }
  }
}

module tcube(vec) {
  difference() {
    cube(vec);
    echo(str("BOM:Frame ",FRAME_WIDTH, " x ", FRAME_DEPTH," mm:length=", max(vec),"mm"));
    m = max(vec);
    t = vec.z == m ? [0,vec.y/2,vec.z/2] : vec.y == m ? [vec.x/2,vec.y/2,vec.z] : [vec.x/2,0,vec.z/2];
    r = vec.z == m ? [0,-90,0] : vec.y == m ? [0,0,-90] : [90,0,0];
    #translate(t) {
      rotate(r) linear_extrude(0.5,center=true) text(str(max(vec),"mm"), size=10, valign="center", halign="center");
    }
  }  
}

