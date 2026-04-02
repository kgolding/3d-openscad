// Nut driver rack

stems =     [7.1, 7.1, 7.1, 7.1, 9.3, 9.3, 11];
handles =   [32,  32,  32,  36,  36,  40,  40];
sizes = [5, 5.5, 6, 7, 8, 10, 13];

height = 12;
depth = 30;
handleSpacing = 5;
endSpace = 15;
w = endSpace + add(handles) + (len(handles)-1) * handleSpacing + endSpace;

showModels = true;
showText = false;

$fn = 60;

d = max(handles);
yRatio = 1.75;
rows = ceil(len(handles)/2) - 1;

// translate([-w -200,0,0]) LongRack();

translate([0,0,height]) rotate([180,0,0]) {
    if (showText) {
        Labels();
    } else {
        DeepRack();
    }
}

a = d/2;
b = (rows+1)*d/yRatio - d/2.5;
c = (rows)*d;

module DeepRack() {
    /*
2────────────────3
│       b        │
│                │a
1       __       4
 ⟍      |       ⟋ 
  ⟍     |      ⟋
   ⟍    |c    ⟋   
    ⟍   |   ⟋      
     ⟍  |  ⟋      
      ⟍ | ⟋         
        0           
Edit/view: https://cascii.app/3bb01
    */
    
    difference() {
        linear_extrude(height)
        offset(3) offset(-3)
        difference() {
            offset(10) polygon([
                [0,-5], [-b, c], [-b,c+a], [b, c+a], [b, c]
            ]);
            
            // Cutouts
            for (row = [0:rows]) {
                y = row * d/yRatio;
                index = row == 0 ? 0 : row*2-1;
                translate([0,0]) {
                    a = row == 0 ? 0 : 55;
                    translate([-y, row * d, 0]) {
                        rotate(-a) {
                            Slot(stems[index]);
                        }
                        if (showModels) %translate([0,0,15 + height]) Driver(handles[index], stems[index]);
                    }
                    if (row > 0 && index < len(stems)) {                    
                        translate([y, row * d, 0]) {
                            rotate(a) Slot(stems[index+1]);
                            if (showModels) %translate([0,0,15 + height]) Driver(handles[index+1], stems[index+1]);
                        }
                    }
                }
            }
        }
        
        Labels();
        
        // Driver countersinks
        for (row = [0:rows]) {
            y = row * d/yRatio;
            index = row == 0 ? 0 : row*2-1;
            translate([0,0]) {
                a = row == 0 ? 0 : 55;
                translate([-y, row * d, 0]) {
                    translate([0,0,height-stems[index]/2+0.01]) cylinder(r1=stems[index]/2, r2=stems[index], h=stems[index]/2);
                }
                if (row > 0 && index < len(stems)) {                    
                    translate([y, row * d, 0]) {
                        translate([0,0,height-stems[index+1]/2+0.01]) cylinder(r1=stems[index+1]/2, r2=stems[index+1], h=stems[index+1]/2);
                    }
                }
            }
        }
    }
    
    // Back plate
    bph = 60;
    bpt = 12;
    difference() {
        //translate([-b-10, c+a, -bph+height]) cube([b*2+20, bpt, bph]);
        
        translate([-b-10, c+a, height-1]) hull() {
            r = 20;
            cube([b*2+20, bpt, 1]);
            translate([r,0,-bph+height+r/2]) rotate([-90,0,0]) cylinder(r=r,h=bpt);
            translate([2*b-r+20,0,-bph+height+r/2]) rotate([-90,0,0]) cylinder(r=r,h=bpt);
        };
        // Screw holes
        dia = 4.5;
        for(x = [20,60]) for (m = [0:1]) mirror([m,0])
            translate([-b-10+x, c+a-0.01, -12]) rotate([-90,0,0]) {
                cylinder(d=dia,h=bpt+0.02);
                cylinder(r1=dia,r2=dia/2,h=dia/2);
            }
    }
    
    // Support
    translate([0, 20, 0]) rotate([-90,0,90]) linear_extrude(10, center=true) polygon([
        [0,0], [c+a-20, 0], [c+a-20, bph-height-1]
    ]);
    }

module Labels() {
    translate([0,c,height-0.8]) linear_extrude(0.8001) text("Nut drivers", size=12, halign="center");
    
    for (row = [0:rows]) {
        y = row * d/yRatio;
        index = row == 0 ? 0 : row*2-1;
        echo(index, sizes[index]);
        translate([0,0, height-0.8]) {
            a = row == 0 ? 0 : 55;
            translate([-y, row * d, 0]) {
                rotate(-a) {
                    linear_extrude(0.8001) translate([0,stems[index] + 1.5,0]) text(str(sizes[index]), size=10, halign="center");
                }
            }
            if (row > 0 && index < len(stems)) {                    
                translate([y, row * d, 0]) {
                    rotate(a) linear_extrude(0.8001) translate([0,stems[index+1] + 1.5,0]) text(str(sizes[index+1]), size=10, halign="center");
                }
            }
        }
    }
}

module Slot(d) {
    hull() {
        circle(d=d + 0.2);
        translate([0, -20]) circle(d=d + 1 + 0.2);
    }
}

module LongRack() {
    p = [
        [0,0], [0,depth], [w,depth], [w,0]
    ];

    // Drivers
    %for(i = [0:len(handles)-1]) {
        translate([addLeft(handles, i+1) + handleSpacing * i, depth/2, 15+height]) Driver(handles[i], stems[i]);
    }

    linear_extrude(height)
    //offset(2) offset(-2)
    {
        difference() {
            polygon(p);
            for(i = [0:len(handles)-1]) {
                translate([addLeft(handles, i+1) + handleSpacing * i, 0])
                    hull() {
                        translate([0,15,0]) circle(d=stems[i] + 0.2);
                        translate([0,0,0]) circle(d=stems[i] + 0.2);
                    }
            }
        }

    //    translate([0,50,0]) polygon(p);
    }
}

module Driver(handle, stem) {
    translate([0,0,-90-105]) cylinder(d=handle, h=105);
    translate([0,0,-90]) cylinder(d=stem, h=90);
    translate([0,0,-15]) cylinder(d=stem + 4, h=15);
}

function add(v, i = 0, r = 0) = i < len(v) ? add(v, i + 1, r + v[i]) : r;
function addLeft(v, end, i = 0, r = 0) = i < min(end,len(v)) ? addLeft(v, end, i + 1, r + v[i]) : r;