// Ceiling beacon mount

I3_WIDTH = 46 + 1;
I3_HEIGHT = 25;
I3_LENGTH = 73 + 1;
I3_RADIUS = 2.5;

HOLE_DIA = 4.3;
HEAD_DIA = 8.5 + 1;
HOLE_SPACING = I3_WIDTH + HEAD_DIA + 1.5;

TOP_DIA = sqrt(pow(I3_WIDTH, 2) + pow(I3_LENGTH, 2)) + 1;
HEIGHT = I3_HEIGHT + 2;

$fn = 90;

// 58.5 seems to give the max dia to fit within
// projection(true) rotate([90,58.1,0])
// projection(true) rotate([90,0,0])
difference() {
    // Body
    rotate_extrude() hull() {
        square([0.1,HEIGHT]); // Center
        br = 0.5;
        translate([TOP_DIA/2 + HEIGHT * 0.66 - br, br]) circle(br); // outer rim
        r = 0.5;
        translate([TOP_DIA/2 - r, HEIGHT - r]) circle(r); // top rim
    }
    
    // Fixing holes
    for (m = [0:1]) mirror([m,0]) {
        translate([HOLE_SPACING/2, -0.1, 0]) cylinder(d=HOLE_DIA, h = HEIGHT+1);
        translate([HOLE_SPACING/2, 0, 10 + HEAD_DIA/2]) cylinder(d=HEAD_DIA, h = HEIGHT+1);
        translate([HOLE_SPACING/2, 0, 10]) cylinder(r1=0, r2=HEAD_DIA/2, h=HEAD_DIA/2);
        translate([HOLE_SPACING/2, 0, HEIGHT-HEAD_DIA/2-0.5]) cylinder(r1=0, r2=HEAD_DIA/2+1, h=HEAD_DIA/2+1);
    }
    
    // I3 Beacon mask (-4 to makt bigger so we get a square cut at the bottom)
    translate([-I3_WIDTH/2, -I3_LENGTH / 2, -4]) {
        // #cube([I3_WIDTH, I3_LENGTH, I3_HEIGHT+ 4]);
        translate([I3_RADIUS,I3_RADIUS,I3_RADIUS]) minkowski() {
            cube([I3_WIDTH-2*I3_RADIUS, I3_LENGTH-2*I3_RADIUS, I3_HEIGHT-2*I3_RADIUS + 4]);
            sphere(I3_RADIUS);
        }
    }
    // Screw plates
    for (m = [0:1]) mirror([0,m]) {
//        translate([0, -I3_LENGTH / 2, -0.001]) rotate([0,0,180]) hull() {
//            #translate([-18/2,0,0]) cube([18,1,4]);
//            translate([0,18-12,0]) cylinder(d=18, h=4);
//        }
        translate([0, -I3_LENGTH / 2, -0.001]) rotate([0,0,180]) linear_extrude(4) offset(-1) offset(1){
            hull() {
                translate([-18/2,0]) square([18,1]);
                translate([0,18-12]) circle(d=18);
            }
            translate([-22/2,-1]) square([22,1]);
        }
    }
    
    // Branding
    translate([HOLE_SPACING/2+6,0,0.5]) rotate([180,0,90]) linear_extrude(1) text("www.smc-gateway.com", size=6, halign="center");
    
//    // Logo
//    translate([0,0,HEIGHT])
//        scale(0.6)
//            import("/home/kgolding/SMC/Media/Gateway Logos/SVG/RGB_SMC Gateway - Icon.svg", center=true);

}