
dia = 30;
spacing = 20;
num = 2;

clipH = 18.3;
clipD = 40;

wall = 3;

w = (dia+spacing) * num;
h = dia+spacing+wall;
d = 60;

tiny = 0.001;

$fn = 30;

module washer() {
  linear_extrude(2)
    difference() {
      circle(d=dia+10);
      circle(d=dia);
    }
}

*washer();

difference() {
  body();
  translate([w/2,0.5,(h-dia)/2+dia/2+spacing+clipH/2])
    rotate([90,0,0])
      linear_extrude(1)
        text("USB", size=clipH, halign="center", valign="center");
}

module body() {
  // Body
  difference() {
    union() {
      r = dia/2;
      // Top
      translate([0,0,h-wall]) cube([w,clipD,wall]);
      // Sides
      difference() {
        translate([0,0,r])
          rotate([90,0,90])
            linear_extrude(w)
               polygon(points=[
                [0,0], [clipD,h-r], [0, h-r]
              ]);
        translate([wall, wall, wall]) cube([w-wall*2,d,h-wall*2]);
      }
      // Front
      hull() {
        translate([0,0,h]) cube([w,wall,tiny]);
        translate([r,0,r]) rotate([-90,0,0]) cylinder(r=r,h=wall);
        translate([w-r,0,r]) rotate([-90,0,0]) cylinder(r=r,h=wall);
      }
    }
    *translate([wall, wall, wall]) cube([w-wall*2,d,h-wall*2]);
    
    // Cutouts
    offset = (h-dia)/2 + dia/2;
    translate([offset,-tiny,offset]) rotate([-90,0,0]) cylinder(d=dia,h=wall+tiny*2);
    translate([offset*2 + spacing,-tiny,offset]) rotate([-90,0,0]) cylinder(d=dia,h=wall+tiny*2);
  }
  // Top clip
  difference() {
    translate([0,0,h]) { // Top of body
      // Front
      cube([w,wall,clipH+0.1]);  
      translate([0,0,clipH+0.1])
        rotate([-3,0,0]) {
          cube([w,clipD,1]);
          translate([0,0,1])
            tcube(w,clipD,wall,wall);
        }
    }
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