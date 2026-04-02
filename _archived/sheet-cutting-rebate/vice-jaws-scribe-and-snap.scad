// Vice blocks for scribe/snap

REBATE_W = 0.8 - 0.1;
REBATE_H = 1.5;

H = 30;
W = 140;
PIN_DIA = 8;

$fn = 50;
t = 0.01;

difference() {
    union() {
        Block();
        Pins();
    }
    // Rebate
    translate([20 - REBATE_W, H - REBATE_H, -t]) cube([REBATE_W + t, REBATE_H + t, W + 2 * t]);
}

translate([60,0,0]) mirror([1,0,0]) difference() {
    Block();
    Pins();
}

module Pins(isMask=false) {
    gap = (isMask ? 0.2 : 0);
    dia = PIN_DIA + 2*gap;
    for (z = [10, W-10]) {
        translate([10, H/2 + gap, z]) rotate([0, 90, 0]) {
            cylinder(d = dia, h = 10 + 10 - 2);
            translate([0,0,10 + 10 - 2]) cylinder(r1=dia/2, r2=dia/2-1, h = 2);
        }
    }
}

module Block() {
    linear_extrude(W) difference() {
        // Main
        square([20, H]);
        // Vice
        square([7.5, H - 5]);
    }
}