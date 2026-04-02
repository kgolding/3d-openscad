// Block for scribing and snapping

THICKNESS = 0.8 + 0.05;
REBATE = 1.5;
WIDTH = 20 + 1;
EXTRA = 5;

EJECT_HOLE_DIA = 1.5 + 0.4;
EJECT_SPRING_LENGTH = 40;
EJECT_SPRING_DIA = 6 + 0.4;
EJECT_TRAVEL = REBATE * 2;
EJECT_OVERLAP = 10;

c = 2;
H = EJECT_SPRING_DIA + 2*3;
L = 60;
t = 0.01;
r = 2;
W = WIDTH + 2 * EXTRA;

//EJECT_THICKNESS = THICKNESS + 2;
//EJECT_LENGTH = 15;
//EJECT_WIDTH = 10;

EJW = WIDTH*0.6;

$fn = 50;

translate([0, H+10, 4]) Ejector();
%translate([0, -20, 4]) Ejector(true);

difference() {
    linear_extrude(L)
        offset(r) offset(-r) square([W, H]);
    
    // Slot
    translate([EXTRA,(H-THICKNESS)/2, L-REBATE+t]) cube([WIDTH, THICKNESS, REBATE+t]);

    // Ejector
    Ejector(true);
    
    // Text
    ts = 6;
    translate([ts+r, 0.2, L/2]) rotate([90,-90,0]) linear_extrude(0.2+t)
        text("Scribe/Snap", size=ts, halign="center", valign="center");
    translate([W - ts, 0.2, L/2]) rotate([90,-90,0]) linear_extrude(0.2+t)
        text(str(WIDTH, " mm"), size=ts, halign="center", valign="center");
    translate([W - 2 * ts - 1, 0.2, L/2]) rotate([90,-90,0]) linear_extrude(0.2+t)
        text(str(REBATE, " x ", THICKNESS), size=ts, halign="center", valign="center");
}

module Ejector(isMask=false) {
    gap = isMask ? 0.2 : 0;
    w = EJW + EJECT_SPRING_DIA + 2;
    h = EJECT_SPRING_DIA+2;
    ejo = (EJW - EJECT_HOLE_DIA)/2;

    translate([W/2, (H-h)/2, -4 - t]) difference() {
        union() {
            // Main
            translate([-w/2, 0, 0]) linear_extrude(4) offset(2) offset(-2) square([w, h]);
            
            // Catch
            translate([0, 1, 0]) {
                Catch(isMask=isMask);
            };
            
            // Pistons
            translate([0, h/2, 0]) {
                for (o=[-ejo, ejo])
                    translate([o, 0, 0]) {
                        // Piston
                        cylinder(d=EJECT_SPRING_DIA + gap, h=EJECT_TRAVEL + EJECT_OVERLAP);
                        if (isMask) {
                            // Rods
                            cylinder(d=EJECT_HOLE_DIA + gap, h=L+4+1);
                            // Spring
                            cylinder(d=EJECT_SPRING_DIA + gap, h=EJECT_TRAVEL + EJECT_OVERLAP + EJECT_SPRING_LENGTH);
                            // Cone top to be print friendly
                            cone = (EJECT_SPRING_DIA + gap)/2;
                            translate([0,0,EJECT_TRAVEL + EJECT_OVERLAP + EJECT_SPRING_LENGTH]) cylinder(r1=cone, r2=0, h=cone);
                        }
                    }
            }
        }

        if (!isMask) {
            // Holes for rods
            translate([0, h/2, 0]) {
                for (o=[-ejo, ejo])
                    translate([o, 0, 4]) {
                        cylinder(d=EJECT_HOLE_DIA, h=L*2);
                    }
            }
        }
    }
}

//translate([-20,0,0]) Catch();
//translate([-30,0,0]) Catch(isMask=true);

module Catch(cw=6, cl=20, step=0.6, travel=10, isMask=false) {
    bw = cw - step;
    wall = 1.6;
    gap = 0.3;
    width = 2 + (isMask ? 2*gap : 0);

    translate([-width/2, bw/2, 0]) rotate([90, 0, 90])
        union() {
            linear_extrude(width)
            if (isMask) {
                // Body (with just a littel gap)
                translate([-(bw+2*gap)/2, 0]) square([bw + gap/2, cl + 1]);
                // Print friendly top
                top = bw+gap+step;
                translate([-bw/2-gap, cl + 1])
                    polygon([
                        [0,0], [top,0], [top/2, top/2]
                    ]);
                // Catch
                translate([-(bw+2*gap)/2, cl-travel]) square([bw + step + gap, travel + 1]);
            } else {
                // Body
                ctx = 4;
                translate([-bw/2, 0]) //square([bw,cl]);                        
                polygon([
                    [0,0], [0,cl], [bw/2,cl+bw/2],
                    [bw,cl],
                    [bw+step,cl-6],
                    [bw-0.25,cl-6],
                    [ctx,cl-1],
                    [ctx,0],
                
                ]);
//                ctx = 0.5;
//                polygon([
//                    [0,0], [0,cl], [bw/2,cl+bw/2], [bw,cl], [bw,0], // 0 - 4
//                    [bw-wall,0], // 5
////                    [bw-wall/2,cl-6], // x
//                    [bw-wall,cl-ctx], [bw/2,cl+bw/2-wall-ctx], [wall, cl-ctx], // 6 - 8
//                    [wall,0], // 9
//                ]);
/*
                          2         
                         //\\        
                       //   \\      
                     //       \\    
                1  //     //    \\ 3
                   │    //  \\   │  
                   │  //  7  \\  │  
                   │  │       │  │  
                   │  │ 8   6 \x │  
                   │  │       /  │  
                   │  │       │  │  
                   │  │       │  │  
                   │  │       │  │  
                0  ──── 9   5 ──── 4

                Edit/view: https://cascii.app/b9bf2 */
                
                // Catch
//                translate([bw/2, cl-6]) polygon([
//                    [0,0], [0,6], [step,0]
//                ]);
            }
//            if (isMask) {
//                // Release
//                translate([bw/2-gap, cl-travel+0.5, width/2]) rotate([0,90,0]) rotate([0,0,45]) cube([1.2,1.2,H]);
//            }
        }
}