// Top hat spacers

ID = 4.3;
OD = 6;
T = 0.9;
TD = OD + 4;
TT = 1.2;

$fn = 80;

translate([0,0,T])
    linear_extrude(TT)
        difference() {
            circle(d=TD);
            circle(d=OD);
        }

linear_extrude(T + TT)
    difference() {
        circle(d=OD);
        circle(d=ID);
    }
