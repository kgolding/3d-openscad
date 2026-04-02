// Surface mount TSW010

x = 113;
y = 65;
z = 25;
r = 3;
wall = 2.5;
lip = 4;
a = 2;

extra = 0.3;

plate_thickness = 7;

dia = 4.7;

$fn = 60;

%linear_extrude(y) Model();

difference() {
    linear_extrude(y) offset(-1) offset(2) offset(-1) {
            // Fixed end
            rotate(-a) Clip();

            // Other end
            translate([x+extra,0]) rotate(a) mirror([1,0]) Clip();
            
            // Plate
            translate([-wall, -plate_thickness]) square([wall+ x + extra + wall, plate_thickness]);
    }

    // Fixings
    edge = 10;
    for (mx = [edge, x-edge]) for (my = [edge-4.9/2, y-edge+4.9/2])
        translate([mx,0.001,my]) rotate([90,0,0]) cylinder(d=dia,h=plate_thickness+0.002);}



module Model() {
    offset(r/2) offset(-r/2) square([x,z]);
}

module Clip() {
    offset(-1) offset(2) offset(-1) union() {
        // Lip
        translate([-wall, z + extra]) square([lip+wall, lip]);
        // Side
        translate([-wall, -1]) square([wall, z+extra+1]);
    }
//            translate([-wall,-wall]) square([wall + lip, wall + z + wall]);
}