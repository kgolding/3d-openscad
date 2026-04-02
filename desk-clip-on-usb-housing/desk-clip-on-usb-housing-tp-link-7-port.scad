
wall = 3;

// Hub size
w = 165 + 1;
h = 18 + 0.6;
d = 65 + 1;

// Clip
clipH = 18.3;
clipD = 40;
clipW = w + wall * 2;

tiny = 0.001;

$fn = 30;

difference() {
  body();
}

module body() {
  // Body
  difference() {
    union() {
      // Top of box, bottom of clip
      translate([0,0,0]) cube([clipW,d,wall]);
      // Bottom
      translate([0,0,-h-1]) cube([clipW,d,1]);
      translate([0,d,-h-1]) rotate([180,0,0]) tcube(clipW,d,wall,wall);
      // Left
      translate([0,0,-h]) cube([wall,d,h]);
      // Right
      translate([clipW-wall,0,-h]) cube([wall,d,h]);
      // Rear corners
//      translate([wall+(w/3),d,-h]) cube([w/3,wall,h]);
      rc = 5;
      translate([wall,d-rc,-h]) {
        linear_extrude(h) polygon([
          [0,0], [0,rc], [rc,rc],
        ]);
      }
      translate([w+wall,d,-h]) {
        linear_extrude(h) polygon([
          [0,0], [0,-rc], [-rc,0],
        ]);
      }
      // Top clip
      translate([0,0,wall]) { // Top of body
        // Front
        cube([clipW,wall,clipH+0.1]);
        translate([0,0,clipH+0.1])
          rotate([-3,0,0]) {
            cube([clipW,clipD,1]);
            translate([0,0,1])
              tcube(clipW,clipD,wall,wall);
          }
      }
    }
    // Text
    textSize = clipH/1.6;
    translate([w/2,0.5,(clipH+wall*2)/2])
      rotate([90,0,0])
        linear_extrude(1)
          text("USB 3 HUB", size=textSize, halign="center", valign="center");
  }
  }

// Tapered cube
module tcube(l,w,d,taper) {
  sx=(l-2*taper)/l; sy=(w-2*taper)/w;    // scaling
  translate([l/2,w/2,0])
    linear_extrude(height=d, center=false, convexity=10, scale=[sx,sy])
      translate([-l/2,-w/2,0])
        square([l,w]);
}