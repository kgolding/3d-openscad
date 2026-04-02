// CAM based hold down for CNC
//
// *** Print with 4 wall loops at 35% infill ***

THICKNESS = 12;
BOLT_SIZE = 8.3;
CAM_MIN = 20;
CAM_MAX = 40;
HANDLE_LENGTH = 100;
HANDLE_WIDTH = 25;
TEXT_ONLY = false;

// Allows for the first 10 degress not being usable due to the handle
cmin = CAM_MIN - CAM_MIN * 10/360;
cmax = CAM_MAX + CAM_MAX * 10/360;
echo(cmin,cmax);

$fn=30;
//rotate([0,0,-10])
hold_down(cmin, TEXT_ONLY) {
  translate([HANDLE_LENGTH/2,0,THICKNESS-0.4+0.01]) linear_extrude(0.4) text(str(CAM_MIN,"-",CAM_MAX," mm"), size = 8, halign="center", valign="center");
//  translate([0,0,THICKNESS-0.4+0.01]) {
//    rotate([0,0,60]) translate([0,-0.5,0]) cube([CAM_MIN+5,1,0.4]);
//    rotate([0,0,300]) translate([0,-0.5,0]) cube([CAM_MAX+5,1,0.4]);
//  }
}

module hold_down(mr=1, children_only=false) {
  if (children_only) {
    children();
  } else {
    difference() {
      linear_extrude(THICKNESS) {
        difference() {
          union() {
            // Handle
            hull() {
              translate([0,-HANDLE_WIDTH/2]) square([1, HANDLE_WIDTH]);
              translate([HANDLE_LENGTH-HANDLE_WIDTH/2,0]) circle(d=HANDLE_WIDTH, $fn=60);
            }
            // Cam
            snail_cam_2d(min_radius=mr, max_radius=cmax,steps=360);
          }
          circle(d=BOLT_SIZE);
        }
      }
      children();
    }
  }
}

module snail_cam_2d(min_radius = 10, max_radius = 40, steps = 360) {
  assert(min_radius < max_radius);
  assert(steps <= 360);
  assert(steps >= 1);
  outer_points = [
      for (i = [0 : steps])
          let (
              r = min_radius + (max_radius - min_radius) * (i / steps),
              angle = i,
              x = r * cos(angle),
              y = r * sin(angle)
          ) [x, y]
  ];

  polygon(points = concat([[0, 0]], outer_points));
}