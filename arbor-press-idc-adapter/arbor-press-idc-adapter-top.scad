// Arbor accessory for a wider top

PEG_HEIGHT = 15.5;
PEG_SIDE = 10;
PEG_DRAFT = 2.5;
OVAL_X = 50;
OVAL_Y = PEG_SIDE * 1.5;
THICKNESS = 12;

PEG_SIDE_TOP = PEG_SIDE - 2 * PEG_HEIGHT * tan(PEG_DRAFT);
t = 0.01;
$fn = 90;

// PEG
rotate([0,0,45]) hull() {
    translate([-PEG_SIDE/2, -PEG_SIDE/2, 0]) cube([PEG_SIDE, PEG_SIDE, t]);
    translate([-PEG_SIDE_TOP/2, -PEG_SIDE_TOP/2, PEG_HEIGHT]) cube([PEG_SIDE_TOP, PEG_SIDE_TOP, t]);
}

translate([0,0,-THICKNESS]) linear_extrude(THICKNESS) scale([1,OVAL_Y/OVAL_X]) circle(d=OVAL_X);
