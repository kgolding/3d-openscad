// Arbor accessory for a circular

shape = "square"; // ["square", "round"]

SIZE = 30;
LENGTH = 12;

PISTON_SIZE = 25;
EJECTOR_LENGTH = 3;

PEG_HEIGHT = 15.5;
PEG_SIDE = 10 + 0.1;
PEG_DRAFT = 2.5;

PEG_SIDE_TOP = PEG_SIDE - 2 * PEG_HEIGHT * tan(PEG_DRAFT);
EJECTOR = SIZE < PISTON_SIZE + 3 - 3;

t = 0.01;
$fn = 60;

difference() {
    union() {
        AccPeg();
        if (EJECTOR) {
            EjectPlate();
        }
        translate([0,0, EJECTOR ? -EJECTOR_LENGTH : 0])
            if (shape == "round") {
                RoundPiston();
            } else {
                SqaurePiston();
            }
    }
    // Internal cylinder to provide strenght
    icl = (EJECTOR ? EJECTOR_LENGTH : 0) + LENGTH - 4;
    translate([0,0,-icl-2]) cylinder(d=2, h=PEG_HEIGHT + icl);
}

module AccPeg() {
    // ACCESSORY PEG - DO NOT CHANGE
    rotate([0,0,45])
    hull() {
        translate([-PEG_SIDE/2, -PEG_SIDE/2, 0]) cube([PEG_SIDE, PEG_SIDE, t]);
        translate([-PEG_SIDE_TOP/2, -PEG_SIDE_TOP/2, PEG_HEIGHT]) cube([PEG_SIDE_TOP, PEG_SIDE_TOP, t]);
    }
//    minkowski() {
//        i = 0.5;
//        i2 = i * 2;
//        hull() {
//            translate([-PEG_SIDE/2+i, -PEG_SIDE/2+i, 0]) cube([PEG_SIDE-i2, PEG_SIDE-i2, t]);
//            translate([-PEG_SIDE_TOP/2+i, -PEG_SIDE_TOP/2+i, PEG_HEIGHT]) cube([PEG_SIDE_TOP-i2, PEG_SIDE_TOP-i2, t]);
//        }
//        sphere(0.5);
//    }
}

module EjectPlate() {
    if (shape == "square") {
        x = PISTON_SIZE + 3;
        p = 3;
        translate([-x/2+0.5,-x/2+0.5,-p+0.5]) minkowski() {
           linear_extrude(p-1) offset(1) offset(-1) square([x-1, x-1]);
            sphere(0.5);
        }
    } else {
        rotate([180,0,0]) {
            translate([0,0,0.5]) minkowski(0.5) {
                linear_extrude(EJECTOR_LENGTH - 1) circle(d=PISTON_SIZE + 4 - 1);
                sphere(0.5);
            }
        }        
    }
}



module SqaurePiston() {
        rotate([0,180,0]) translate([-SIZE/2,-SIZE/2,0]) {
           linear_extrude(LENGTH) offset(1) offset(-1) square([SIZE, SIZE]);
            if (EJECTOR) {
                roundedCubeFillet(SIZE, SIZE, 1, 2);
            }
        }
    }
module RoundPiston() {
    rotate([180,0,0]) {
            linear_extrude(LENGTH) circle(d=SIZE);
            if (EJECTOR) {
                cylinderFillet(SIZE/2, min(3, PISTON_SIZE - SIZE + 1));
            }
        }
    }


//translate([50,0,0]) {
//    X = 8;
//    Y = 12;
//    roundedCube(X, Y, 30, 1);
//    roundedCubeFillet(X, Y, 1, 2);
//}

module cylinderFillet(r, f) {
    rotate_extrude(angle=360,convexity=2)
        translate([r+f,f,f])
            rotate([0,180,90])
                 difference() {
                    square([f,f]);
                    circle(r=f);
                }
}

//module cubeFillet(x, y, f) {
//        translate([-f, -f, 0]) {
//            cube([x + 2*f, y +2*f, f]);
//            roundedCubeFillet(x,y,f);
//        };
//}

module roundedCube(x, y, z, r) {
    hull() {
        translate([r,r,0]) cylinder(r=r, h=z);
        translate([x-r,r,0]) cylinder(r=r, h=z);
        translate([x-r,y-r,0]) cylinder(r=r, h=z);
        translate([r,y-r,0]) cylinder(r=r, h=z);
    }
}

module roundedCubeFillet(x, y, f, r) {
    module fillet2D() {
        translate([-r,-r]) difference() {
            square(r);
            circle(r=r);
        }
    }
    
    module longFillet(l) {
        rotate([-90,0,0]) linear_extrude(l) fillet2D();
    }
    
    module cornerFillet(rotateZ) {
        rotate([0,0,rotateZ])
            mirror([0,0,1])
                translate([-f,-f])
                    rotate_extrude(angle=90)
                        translate([-f,0]) fillet2D();
    }

    // Corners and y sides
    translate([x/2, y/2, 0]) for(m=[0:1]) mirror([m, 0]) {
        translate([x/2-r,y/2-r,0]) cornerFillet(180);
        translate([-x/2+r,-y/2+r,0]) cornerFillet(0);
        translate([-x/2,-y/2+f,0]) longFillet(y-2*f);   
    }
    // x sides
    translate([x-f,0,0]) rotate([0,0,90]) longFillet(x-2*f);
    translate([f,y,0]) rotate([0,0,-90]) longFillet(x-2*f);
}
