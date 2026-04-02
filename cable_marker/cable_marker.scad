CABLE_DIA = 7;
TEXT = "Cable 1";
WALL = 1.2;

clipThickness = 4;
h = CABLE_DIA + 2 * WALL;
w = CABLE_DIA + 2 * clipThickness;
w2 = w - 3;
w2Offset = (w - w2) / 2;

$fn = 30;

l = 30;

difference() {
  linear_extrude(l) Profile();
  translate([-w/2, -h/2 + 0.5, l/2]) rotate([90,90,0]) linear_extrude(1) text(text=TEXT, size=CABLE_DIA/2, valign="center", halign="center");
  translate([w/2, -h/2 + 0.5, l/2]) rotate([90,90,0]) linear_extrude(1) text(text=TEXT, size=CABLE_DIA/2, valign="center", halign="center");
}

module Profile() {
  rotate([0,0,180]) translate([-w,-h/2]) difference() {
    solid();
    Bottom();
    square([w, h/2]);
  }

  translate([-w, -h/2]) Bottom();

  hinge = 0.4;
  translate([-hinge, -hinge]) square([2*hinge, hinge]);

  *difference() {
    linear_extrude(10) solid();
    translate([0,0,-0.1]) {
      linear_extrude(10 + 1) topMask();
    }
  }
}
points = [
  [w2Offset, 0], [0, h/2], [w2Offset, h],
  [w2Offset + w2, h], [w, h/2], [w2Offset + w2, 0],
  [w2Offset, 0],
];


bottom = [
  [w2Offset, 0],
  [0, h/2], 
  [w2Offset/2, h*0.75],
  [w2Offset/2 + clipThickness/4, h*0.75],
  [w2Offset/2 + clipThickness/2, h*0.65],
  [w2Offset, h*0.55],
  [w2Offset+h*0.61, 0],
  [w/2, h/2],
  [w, h/2],
  [w2Offset + w2, 0],
  [w2Offset, 0],
];

top = [
  [w, h/2],
  [w/2, h/2],
  [w2Offset, h*0.55],
  [w2Offset/2 + clipThickness/2, h*0.65],
  [w2Offset/2 + clipThickness/4, h*0.75],
  [w2Offset,h*0.85],
  [w2Offset,h],
  
  [w2Offset+w2, h],
  [w, h/2],
];

//NumberPoints(bottom);

*union() {
  polygon(top);
}

module Bottom() {
  difference() {
    union() {
      polygon(bottom);
      polygon([
        [w/2, h/2], [w2Offset, 0], [w/2,0]
      ]);
    };
    translate([w/2, h/2]) circle(d = CABLE_DIA);
  }
}

module solid() {
  difference() {
    polygon(points);
    translate([w/2, h/2]) circle(d = CABLE_DIA);
  }
}

module topMask() {
  translate([w/2, h/2]) circle(d = CABLE_DIA);
  *square([w, h/2]);
}

module NumberPoints(points) {
  color("red") for(i = [0:len(points)-1]) {
    translate([points[i].x, points[i].y]) text(text=str(i), size=1);
  }
}