// Microlab-2

SHELF_DEPTH = 100;
SHELF_THICKNESS = 2.55;
SUPPORT_THICKNESS = 2;


/* [Hidden] */
THICKNESS = 4;
RADIUS = 2;
HEIGHT = 44.4;
HEIGHT_GAP = 0.10;
SIDE_WIDTH_INSIDE = 18.5;
WIDTH_INSIDE = 162.8;
HOLE_FROM_EDGE = 10.5;
HOLE2_FROM_BOTTOM = 33.345;
HOLE1_FROM_BOTTOM = 11.095;
HOLE_DIA = 3.3;

difference() {
    FrontPlate();
    // Example cutouts, measured from usable area on face plate, that is offset from the edge
    translate([0,0,-0.01]) {
        translate([20,HEIGHT/2,0]) cylinder(d=20,h=5);
    }
}

translate([0,50,0]) FrontPlate(2, true, true);
translate([0,150,0]) FrontPlate(3, true, true);

module FrontPlate(numberUnits = 1, showRear=false, shelf=true) {
    totalWidth = WIDTH_INSIDE + 2 * SIDE_WIDTH_INSIDE;
    height = numberUnits * HEIGHT + (numberUnits-1) * HEIGHT_GAP;
    
    translate([SIDE_WIDTH_INSIDE+ WIDTH_INSIDE,0,THICKNESS]) rotate([0,180,0]) {
        linear_extrude(THICKNESS)
            difference() {
                // Plate
                offset(RADIUS, $fn=30) offset(-RADIUS)
                    square([totalWidth, height]);
                // Fixing holes
                for (y = [0:numberUnits-1]) translate([0,y * (HEIGHT + HEIGHT_GAP),0]) {
                    translate([HOLE_FROM_EDGE, HOLE1_FROM_BOTTOM]) circle(d=HOLE_DIA, $fn=30);
                    translate([HOLE_FROM_EDGE, HOLE2_FROM_BOTTOM]) circle(d=HOLE_DIA, $fn=30);
                    translate([totalWidth-HOLE_FROM_EDGE, HOLE1_FROM_BOTTOM]) circle(d=HOLE_DIA, $fn=30);
                    translate([totalWidth-HOLE_FROM_EDGE, HOLE2_FROM_BOTTOM]) circle(d=HOLE_DIA, $fn=30);
                }
            }
        if (showRear) {
            %translate([SIDE_WIDTH_INSIDE,0,THICKNESS]) cube([WIDTH_INSIDE, height, 100]);
        }
        if (shelf) {
            translate([SIDE_WIDTH_INSIDE,0,THICKNESS]) cube([WIDTH_INSIDE, SHELF_THICKNESS, SHELF_DEPTH]);
            for (x = [ + SUPPORT_THICKNESS, WIDTH_INSIDE]) {
                translate([SIDE_WIDTH_INSIDE + x,0,THICKNESS])
                    rotate([0,-90,0]) linear_extrude(SUPPORT_THICKNESS) polygon([
                        [0,SHELF_THICKNESS],
                        [SHELF_DEPTH, SHELF_THICKNESS],
                        [0,height]
                    ]);
            }
        }
        children();
    }
}