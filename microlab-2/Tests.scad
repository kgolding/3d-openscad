include <microlab-2.scad>

difference() {
    FrontPlate(1) {
        Shelf();
    }
        
    translate([20,0.01,20]) rotate([90,0,0]) cylinder(d=10,h=10);
};
