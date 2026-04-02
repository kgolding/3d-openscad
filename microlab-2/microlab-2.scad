/* [Hidden] */
ML2_FRAME_THICKNESS = 4;
ML2_FRAME_RADIUS = 2;
ML2_FRAME_HEIGHT = 44.4;
ML2_FRAME_HEIGHT_GAP = 0.10;
ML2_FRAME_SIDE_WIDTH_INSIDE = 18.5;
ML2_FRAME_WIDTH_INSIDE = 162.8;
ML2_FRAME_HOLE_FROM_EDGE = 10.5;
ML2_FRAME_HOLE2_FROM_BOTTOM = 33.345;
ML2_FRAME_HOLE1_FROM_BOTTOM = 11.095;
ML2_FRAME_HOLE_DIA = 3.3;

function HeightFromNumberUnits(numberUnits) =
    numberUnits * ML2_FRAME_HEIGHT + (numberUnits-1) * ML2_FRAME_HEIGHT_GAP;

//FrontPlate(1, showRear=false, openFace=true, valign="left", halign="bottom") {
//    Shelf();
//}

module FrontPlate(numberUnits = 1, showRear=false, openFace=false, valign="bottom", halign="inside-left") {
    totalWidth = ML2_FRAME_WIDTH_INSIDE + 2 * ML2_FRAME_SIDE_WIDTH_INSIDE;
    height = HeightFromNumberUnits(numberUnits);
    
    x = halign == "center" ? totalWidth/2
        : halign == "inside-left" ? ML2_FRAME_SIDE_WIDTH_INSIDE
        : halign == "inside-right" ? totalWidth - ML2_FRAME_SIDE_WIDTH_INSIDE
        : 0;

    z = valign == "top" ? height
        : valign == "middle" ? height/2
        : 0;
    
    translate([-x,0,-z]) {
        rotate([90,0,0]) {
            linear_extrude(ML2_FRAME_THICKNESS)
                difference() {
                    // Front plate
                    if (openFace) {
                        union() {
                            w = ML2_FRAME_SIDE_WIDTH_INSIDE + 2;
                            // Left
                            offset(ML2_FRAME_RADIUS, $fn=30) offset(-ML2_FRAME_RADIUS)
                                square([w, height]);
                            translate([w- ML2_FRAME_RADIUS,0,0]) square([ML2_FRAME_RADIUS, height]);
                            // Right
                            translate([totalWidth - w,0,0]) {
                            offset(ML2_FRAME_RADIUS, $fn=30) offset(-ML2_FRAME_RADIUS)
                                square([w, height]);
                            square([ML2_FRAME_RADIUS, height]);
                            }
                        }
                    } else {
                        offset(ML2_FRAME_RADIUS, $fn=30) offset(-ML2_FRAME_RADIUS)
                            square([totalWidth, height]);
                    }
                    // Fixing holes
                    for (y = [0:numberUnits-1]) translate([0,y * (ML2_FRAME_HEIGHT + ML2_FRAME_HEIGHT_GAP),0]) {
                        translate([ML2_FRAME_HOLE_FROM_EDGE, ML2_FRAME_HOLE1_FROM_BOTTOM]) circle(d=ML2_FRAME_HOLE_DIA, $fn=30);
                        translate([ML2_FRAME_HOLE_FROM_EDGE, ML2_FRAME_HOLE2_FROM_BOTTOM]) circle(d=ML2_FRAME_HOLE_DIA, $fn=30);
                        translate([totalWidth-ML2_FRAME_HOLE_FROM_EDGE, ML2_FRAME_HOLE1_FROM_BOTTOM]) circle(d=ML2_FRAME_HOLE_DIA, $fn=30);
                        translate([totalWidth-ML2_FRAME_HOLE_FROM_EDGE, ML2_FRAME_HOLE2_FROM_BOTTOM]) circle(d=ML2_FRAME_HOLE_DIA, $fn=30);
                    }
                }
        }
        if (showRear) {
            %translate([ML2_FRAME_SIDE_WIDTH_INSIDE,0,0]) cube([ML2_FRAME_WIDTH_INSIDE, 100, height]);
        }
        children();
    }
}

module Shelf(numberUnits = 1, depth=100, shelfThickness=2.55, supportThickness=2) {
    height = HeightFromNumberUnits(numberUnits);
    translate([ML2_FRAME_SIDE_WIDTH_INSIDE,0,0]) {
        translate([0,-ML2_FRAME_THICKNESS,0]) cube([ML2_FRAME_WIDTH_INSIDE, depth + ML2_FRAME_THICKNESS, shelfThickness]);
        for (x = [0, ML2_FRAME_WIDTH_INSIDE - supportThickness]) {
            translate([x,0,0])
                rotate([90,0,90]) linear_extrude(supportThickness) polygon([
                    [0, shelfThickness],
                    [0, height],
                    [depth, shelfThickness],
                ]);
        }
    }
}
