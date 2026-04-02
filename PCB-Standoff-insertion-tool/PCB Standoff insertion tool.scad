// Diameter of the items main body (we add 0.15 mm for clearance)
pillerDia = 4.6 + 0.15;

// Height of the main body (we subtract clearance to ensure the main body sits outside of the tool)
pillerH = 5 / 2;

// Diameter of the stud that goes into the PCB, e.g. for a 2.5mm item the
// catches are actually 3 mm at their maximum (we add 0.1 mm for clearance)
studDia = 3.0 + 0.1;

/// The height of the stud (we add 1 mm for clearance)
studH = 3.7 + 1;

// Wall thickness of the tool
wall = 2;

// Height of the tool
h = 110;

$fn = 60;

StudInsertionTool();

module StudInsertionTool() {
    difference() {
        // Handle body
        union() {
            // Main shaft
            translate([0, 0, h/3]) cylinder(d=(pillerDia+wall)*2, h=h/3*2);
            cylinder(r1=(pillerDia+wall)/2, r2= (pillerDia+wall)*2/2, h=h/3);
            // Top
            translate([0, 0, h]) scale([1, 1, 0.5]) sphere((pillerDia+wall)/2*2);
        }
        
        // Grips
        for (i = [0:11]) {
            translate([0, 0, h - 10 - (i * 5)]) rotate_extrude() translate([(pillerDia+wall+1.7), 0, 0]) circle(r=2);
        }

        // Stud recess
        translate([0, 0, -0.01]) cylinder(d=studDia, h=studH + pillerH);
        translate([0, 0, -0.01]) cylinder(d=pillerDia, h=pillerH);
    }
}
