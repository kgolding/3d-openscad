// William Box Jig

OD = 94.5;
ID = 66.4;
Wall = 6;
Extra = 50;

difference() {
  union() {
    // Top plate
    translate([0,0,Wall/2]) cube([OD+Extra, OD+Extra, Wall], center=true);
    // Sides
    translate([0,0,-15/2]) cube([OD+Wall*2, OD+Wall*2, 15], center=true);
  }
  // Cutout
  cube([ID, ID, 100], center=true);
  // Sights
  for (m = [[0,0], [0,1], [1,0], [1,1]]) mirror(m)
  translate([OD/2,OD/2,0]) cube([Wall*2+1,Wall*2+1,100], center=true);
//  cylinder(d=20,h=10*Wall,center=true);
  // Block
  #translate([0,0,-100/2]) cube([OD, OD, 100], center=true);
  // Key
  translate([(OD+Extra)/2, (OD+Extra)/2, 0]) rotate([0,0,45]) cube([20,20,Wall*4], center=true);
}
