// Terminal clamp for soldering

TERM_HEIGHT = 10;
TERM_DEPTH = 8.8;
PCB_THICKNESS = 1.6;
FROM_EDGE = 15;
WALL = 1.8;
WIDTH = 35;
H_TERM_GRIP = 7.5;
BUMP = 1;

$fn = 30;

/*
                              <-D        <-E
   ──────────────────────────────────────── 
H  │             3              │          │
   │                            │          │
   │                          4 │        5 │
   │                            │           
   │                            │           
   │ 2                          │           
   │                            │           
   │────────────────────────────            
   │                                        
   │     1                     /              
   ───────────────────────────/─\             
   0                          <-A             

Edit/view: https://cascii.app/3955d
*/

INTERNAL_RADIUS = 0.5;
EXTERNAL_RADIUS = 0.25;

D = WALL + FROM_EDGE + INTERNAL_RADIUS;
A = D + WALL;
H = WALL + BUMP + PCB_THICKNESS + TERM_HEIGHT;
E = D + WALL + TERM_DEPTH - WALL;

echo(D, E);

linear_extrude(WIDTH)
  offset(-INTERNAL_RADIUS) offset(INTERNAL_RADIUS)
    offset(EXTERNAL_RADIUS) offset(-EXTERNAL_RADIUS) {
  // 1
  translate([WALL,0]) rotate(2) {
    square([A - WALL, WALL]);
    // 1 Pressure bump
    translate([A - WALL - 2*BUMP,WALL]) square([2*BUMP, BUMP]);
  }
    
  // 2
  square([WALL, H + WALL]);

  // 3
  translate([0,H]) square([E + WALL, WALL]);

  // 2/3/4 block (2nd WALL = GAP)
  difference() {
    translate([WALL + WALL,H - TERM_HEIGHT]) square([D - WALL, TERM_HEIGHT]);
    translate([WALL + WALL + WALL,H - TERM_HEIGHT + WALL]) square([D - WALL-2*WALL, TERM_HEIGHT-WALL]);
  }

  // 5
  //translate([E,H - H_TERM_GRIP]) square([WALL, H_TERM_GRIP]);  

  // 5 ALT
  q = 2;
  translate([D + WALL + 7,H + WALL - q]) translate([WALL,q]) rotate(180+5) square([WALL, WALL + q]);

}
