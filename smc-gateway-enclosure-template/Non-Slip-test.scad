// Rubber tube seal test

tiny = 0.01;

wall = 7;
difference() {
  cube([50,50,7]);
  
  translate([5,5,-tiny]) rounded_mask(40,40);
  
  translate([25,25,0]) PunchHole(7);
   
//  translate([5,-tiny,-tiny]) cube([4.5, 50+2*tiny, 3]);
  
}

module rounded_mask(x,y,r=10,w=4.5, d=3.5) {
  linear_extrude(d) difference() {
    hull() {
      translate([r,r]) circle(r=r);
      translate([x-r,r]) circle(r=r);
      translate([r,y-r]) circle(r=r);
      translate([x-r,y-r]) circle(r=r);
    }
    hull() offset(-w) {
      translate([r,r]) circle(r=r);
      translate([x-r,r]) circle(r=r);
      translate([r,y-r]) circle(r=r);
      translate([x-r,y-r]) circle(r=r);
    }
  }
}

module PunchHole(wall) {
  // Pin diameter is 5 mm and we need the hole a little bigger
  pin_dia = 5;
  r1 = (pin_dia-1) / 2; 
  r2 = r1 + wall;
  // Pin hole
  translate([0,0,-0.01]) cylinder(d=pin_dia+0.1,h=wall+0.02,$fn=30);
  // Countersink
  translate([0,0,1]) cylinder(r1=r1,r2=r2,h=wall,$fn=30);
}