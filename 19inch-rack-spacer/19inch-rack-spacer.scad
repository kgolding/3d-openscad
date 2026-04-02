
NUMBER_U_TO_COVER = 1;
HOLE_DIA = 6.5;
DEPTH = 27;
WIDTH = 20;
CAGE_NUT_FLANGE_DEPTH = 1.5;

HOLE_SPACING_1U = 31.75; // 1.25"
HEIGHT_1U = 44.45;

HEIGHT = HEIGHT_1U * NUMBER_U_TO_COVER; // 1U is 44.45 mm

tiny = 0.01;
$fn = 30;
holeOffset = (HEIGHT_1U - HOLE_SPACING_1U) / 2;

difference() {
  cube([HEIGHT, WIDTH, DEPTH]);
  HoleWithRecess(holeOffset);
  HoleWithRecess(HEIGHT - holeOffset);
}

module HoleWithRecess(offset) {
  translate([offset, WIDTH/2, -tiny]) {
    cylinder(d=HOLE_DIA,h=DEPTH+2*tiny);
    if (CAGE_NUT_FLANGE_DEPTH > 0) {
      cube([14,14,CAGE_NUT_FLANGE_DEPTH * 2], center=true);
    }
  }
};