WIDTH = 29;

dinD = 7.5;
dinH = 35;
dinLip = 3;
dinT = 1;

dinW = WIDTH;

tiny = 0.01;
$fn=30;

PLATE_HEIGHT = 60;

END_CAP_THICKNESS = 2;

// Rear plate
translate([-WIDTH/2, 0, 0]) cube([WIDTH, 3, PLATE_HEIGHT]);

// Hooks
translate([0, 0, 15]) hook();
translate([0, 0, 55]) hook();

// End caps
translate([-WIDTH/2 - END_CAP_THICKNESS, 0, 0]) EndCap();
translate([WIDTH/2, 0, 0]) EndCap();

// Dinrail
translate([0, 3, PLATE_HEIGHT/2]) rotate([90,0,90]) difference() {
   /*
            7   ──── 8
               /   │  
              /    │  
             /     │  
            /      │  
           /       │  
    5  │──/  6     │  
       │           │  
       │           │  
       │           │  
       │           │  
       │           │  
       │           │  
       │           │  
    4  │───\ 3     │  
            \      │  
             \     │  
              \    │  
               \   │  
             2  ──── 1

  Edit/view: https://cascii.app/ffd9a  
  */
    translate([0, -dinH/2, -dinW/2]) linear_extrude(dinW) polygon([
      [dinD,0],                 // 1
      [dinD-dinT, 0],           // 2
      [dinD-dinT-1, dinLip],    // 3
      [0,dinLip],               // 4
      [0,dinH - dinLip],        // 5
      [dinD-dinT-1,dinH-dinLip],// 6
      [dinD-dinT, dinH],        // 7
      [dinD, dinH],             // 8
    ]);
}

module EndCap() {
/*
  2  ───────    3  
     │      \      
     │       \     
     │        \    
     │         │  4
     │         │   
     │         │   
     │         │   
     │         │   
     │         │   
     │         │   
     │         │   
     │         │   
     │         │   
     │         │   
     │         │   
     │         │   
     │         │   
     │         /  5
     │        /    
     │       /     
  1   ───── /  6   

Edit/view: https://cascii.app/e4aad
*/
  a = 4;
  w = dinD + 3;
  rotate([90,0,90]) linear_extrude(END_CAP_THICKNESS) polygon([
    [0,0],
    [0, PLATE_HEIGHT],
    [w-a, PLATE_HEIGHT],
    [w, PLATE_HEIGHT-a],
    [w, a],
    [w-a, 0],
  ]);

}
module hook() {
  // t is the amount we reduce the width/height by to let it fit ok
  t = 0.1;
  // w = width
  w = 5;
  // wt is the width less the t
  wt = w - t * 2;
  // h is the hight less a bit to make it fit
  h = 15 - 0.3;
  // h2 is the height of the smaller part of the peg
  h2 = h - 5;
  // ht is the height less t
  ht = h - t;
  // d is the depth of the board
  d = 5;
  // 12 gives us enough facets to create a easy to print angle
  $fn = 6;

  translate([0, -d*2, -wt/2]) rotate([270, 90,0]) union() {
    // The larger part of the peg
    hull() {
      cylinder(d=wt, h=d + 0.3);
      // -0.3 is the taper applied to the face that makes contact with the back on the pegboard
      translate([ht-w, 0, 0]) cylinder(d=wt, h=d -0.3);
    }
    // The smaller part of the peg
    translate([0, 0, 0]) hull() {
      cylinder(d=wt, h = d * 2);
      translate([h2 - w - t * 2 ,0 ,0]) cylinder(d=wt, h=d * 2);
      };
  }
}
