// GTC Connector holder

/*
1────────────────────────────────────────────────────2
│                         A                          │
│                                                    │
│                                                    │B
│Q          Connector plug outline                   │
│                                                    │
│                                                    │
│   8────────────────────T──────────────────7   4──C─3
│   │                                       │   │     
│   │                                       │   │D     
0─E─9                                       6─E─5     


Edit/view: https://cascii.app/befba
*/

q = 6.5;
a = 12.5;
c = 1.5;
d = 1.3;
e = 1.0;
t = 9;
b = q - d;
conn_depth = 6;

// Top size
space = 2;
x = a + 2 * space;
y = (b+d) + 2 * space;
h = 9;

// Base size
bx = x + 2*h;
by = y + 2*h;
radius = 3;
ty = 2.5;

conn_extra_depth = 3;

$fn = 60;

p = [
    // 0    1       2         3     4
    [0,0], [0,d+b], [a,d+b], [a,d], [a-c,d],
    // 5        6       7           8       9
    [a-c,0], [a-c-e,0], [a-c-e, d], [e,d], [e,0]
];

difference() {
    hull() {
        // Top
        translate([-x/2,-y/2,h]) linear_extrude(0.01) offset(radius) offset(-radius) square([x,y+ty]);
        // Base
        translate([-bx/2,-by/2,0]) linear_extrude(1.5) offset(radius) offset(-radius) square([bx,by+ty]);
    }

    r = 0.15;
    translate([-a/2,-(b+d)/2,h+0.1-conn_depth-conn_extra_depth]) linear_extrude(conn_depth + conn_extra_depth)
        // Round the corners
        offset(r) offset(-2*r) offset(r)
        mirror([1,0]) translate([-a,0,0])
        // Make it a little bigger
        offset(0.15)
        polygon(p);
}

%translate([-a/2,-(b+d)/2,h+0.1-conn_depth]) linear_extrude(conn_depth) mirror([1,0]) translate([-a,0,0]) polygon(p);
