include <microlab-2.scad>

SupportThickness = 2;

PSU_WIDTH = 81.5;
PSU_HEIGHT = 35;
PSU_DEPTH = 100;

$fn = 30;

difference() {
    union() {
        FrontPlate(1, false, halign="inside-left") {
            Shelf(supportThickness=SupportThickness);
        }
        // Power leads shield
        translate([27,-5,ML2_FRAME_HEIGHT/2])
        translate([0, 4, 0])
            rotate([90,0,0]) mirror([0,0,1]) linear_extrude(35) {
                difference() {
                    offset(3) offset(-3) square([27+4, 19.3+4], center=true);
                    offset(3) offset(-3) square([27, 19.3], center=true);
                }
                    
            }
            //cube([27+4, 35, 19.3+4]);
    }
    
    // Text
    translate([ML2_FRAME_WIDTH_INSIDE,-3,22]) rotate([90,0,0]) linear_extrude(4) text("12V / 5V PSU", valign="center", halign="right");
   
    // Move to the inside right corner above the shelf
    translate([ML2_FRAME_WIDTH_INSIDE - 2 - PSU_DEPTH,0,2]) {
        // PSU
        %cube([PSU_DEPTH ,PSU_WIDTH, PSU_HEIGHT]);
        // PSU Screws
        translate([24,41,-2.001]) {
            cylinder(d=3.3, h=10);
            cylinder(r1=3.3, r2=0, h=3.3);
            translate([55,0,0]) {
                cylinder(d=3.3, h=5);
                cylinder(r1=3.3, r2=0, h=3.3);
            }
        }
    }
    translate([27,-5,ML2_FRAME_HEIGHT/2]) {
        rotate([90,0,0]) EuroSocketMask();
    }
    
    for (x = [5:8:65])
        translate([x, 92,-1]) CableTieSlot();
};


module CableTieSlot() {
    hull() {
        translate([0,-3,0]) cylinder(d=3, h=10);
        translate([0,3,0]) cylinder(d=3, h=10);
    }
}

module EuroSocketMask() {
    h=19.3;
    w=27;
    d=50;
    translate([-w/2,-h/2,-d+0.01]) linear_extrude(d) offset(3) offset(-3) square([w, h]);
    translate([-20,0,-14]) cylinder(d=4,h=15);
    translate([20,0,-14]) cylinder(d=4,h=15);
}