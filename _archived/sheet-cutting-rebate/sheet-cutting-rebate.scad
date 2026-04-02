// Rebate block for cutting sheet with bench shear

THICKNESS = 0.8;
REBATE = 1.5;
LENGHT = 100;
B = 10;
t = 0.01;

difference() {
    cube([B, LENGHT, B]);
    translate([-t,-t,-t]) cube([REBATE+t, LENGHT+2*t, THICKNESS+t]);
    rotate([-90,0,-90]) translate([-LENGHT/2,-B*0.9,B-0.2]) linear_extrude(0.5)
        text(str(REBATE, " x ", THICKNESS, " mm"), size=B*0.8, halign="center");
}