// DSUB 9

TEXT_ONLY = false;
SCREW_CUTOUTS = true;

$fn = 12;

//projection(cut=true) translate([0,0,8])
//projection(cut=true) rotate([0,90,0])

if (!TEXT_ONLY) {
  // Top
  difference () {
    Enclosure();
    // Cut bottom off
    translate([-50,-50,-190]) cube([100,50,200]);
    CableTie();
    translate([0,0,-45]) CableTie();
  }
  Clips();
}

Bottom() {
  translate([5,-7.4,-30]) rotate([90,90,0]) linear_extrude(0.35)
    offset(0.2) text("Serial", size=8, valign="center", halign="center");
  translate([-5,-7.4,-30]) rotate([90,90,0]) linear_extrude(0.35)
    offset(0.2) text("Interceptor", size=8, valign="center", halign="center");
}

module Bottom() {
  translate([50,0,-60])
    rotate([180,0,0])
      if (TEXT_ONLY) {
        children();
      } else {
        difference () {
          Enclosure();
          translate([-50,0,-190]) cube([100,50,200]);
          minkowski() {
            Clips();
            sphere(0.05);
          }
          children();
        }
      }
}
//!DSub9Mask();
//SerialInterceptorMask();
// Clips();

module CableTie() {
  ctw = 3.5;
  translate([-3,4.6,-ctw-5.8]) {
    cube([6,2,ctw]);
    translate([6,0,0]) rotate([0,0,45]) cube([6,2,ctw]);
    rotate([0,0,-45]) translate([-6,0,0]) cube([6,2,ctw]);
  }
}

module Clips() {
  cw = 1.5;
  for (m = [0,1])
    mirror([m,0,0])
      for(z = [-15,-55])
        translate([14+cw,-4,z]) {
          cube([cw,4,10]);
          translate([0.30,0.52,0]) rotate([0,0,0]) cylinder(d=1.2,h=10,$fn=6);
        }
}

module Enclosure() {
  difference() {
    body_t = 12;
    body_w = 30;
    hull() {
      for(z = [-2,-58]) // Ends 
        // for(z = [0.5,-60.5]) // 0.5mm on the outside of the plates
        for(x = [body_w/2,-body_w/2])
          for(y = [body_t/2, -body_t/2])
            translate([x,y,z]) rotate([90,0,0]) sphere(2,$fn=6);
    }
    minkowski() { // Make the mask 0.2 mm larger
      SerialInterceptorMask();
      sphere(0.2);
    }
  }
}

module SerialInterceptorMask() {
  DSub9Mask(60);
  PCB_BELOW = 3;
  PCB_ABOVE = 11;
  PCB_T = 1.6;
  // PCB
  translate([-17/2,-PCB_T/2,-55]) cube([17,PCB_T,50]);
  // Below PCB
  translate([-17/2,-PCB_T/2-PCB_BELOW,-55]) cube([17,PCB_BELOW,50]);
  // Component PCB side
  translate([-17/2,PCB_T/2,-50]) cube([17,PCB_ABOVE,40]);
  // Component PCB side, DB9 pins at end
  translate([-17/2,PCB_T/2,-55]) cube([17,3,50]);
  translate([0,0,-60]) rotate([0,180,0]) DSub9Mask(60);
  
  // Chamfer
  translate([-17/2,PCB_T/2,-50]) rotate([0,0,30]) cube([17,PCB_ABOVE,40]);

}

module DSub9Mask(screw_length=0) {
  // Plate
  plate_w = 31;
  plate_h = 12.6;
  plate_r = 3;
  plate_t = 1;
  screw_centers = 25;
  screw_offset_from_plate_edge = (plate_w-screw_centers)/2;
  
 linear_extrude(plate_t) {
    translate([-plate_w/2, -plate_h/2, 0]) difference() {
      hull() {
        translate([plate_r,plate_r]) circle(r=plate_r);
        translate([plate_w-plate_r,plate_r]) circle(r=plate_r);
        translate([plate_r,plate_h-plate_r]) circle(r=plate_r);
        translate([plate_w-plate_r,plate_h-plate_r]) circle(r=plate_r);
      }
      // Holes
      translate([screw_offset_from_plate_edge,plate_h/2]) circle(d=3);
      translate([plate_w-screw_offset_from_plate_edge,plate_h/2]) circle(d=3);
    }
  }

  // Screws
  if (screw_length > 0) translate([-plate_w/2, -plate_h/2, 0]) {
    translate([screw_offset_from_plate_edge,plate_h/2,-plate_t-screw_length]) cylinder(d=3,h=5+plate_t+screw_length);
    translate([plate_w-screw_offset_from_plate_edge,plate_h/2,-plate_t-screw_length]) cylinder(d=3,h=5+plate_t+screw_length);
  }
//  if (SCREW_CUTOUTS) {
//    translate([plate_w/2-screw_offset_from_plate_edge-3,-plate_h*1.1/2,-30-7.5]) cube([10, plate_h*1.1, 30]);
//  }
  
  // Front
  front_tw = 18.3;
  front_bw = 17;
  front_h = 9.5;
  front_r = 2;
  front_t = 7;
  front_tw_bw_diff = front_tw - front_bw;
  translate([-front_tw/2,-front_h/2, plate_t])
    linear_extrude(front_t)
      offset(front_r) offset(-front_r) polygon([
        [0,front_h], [front_tw,front_h],[front_tw-front_tw_bw_diff,0],[front_tw_bw_diff,0]
      ]);
  
  // Back
  back_tw = 20;
  back_bw = 18;
  back_h = 11;
  back_r = 2;
  back_t = 5;
  back_tw_bw_diff = back_tw - back_bw;
  translate([-back_tw/2,-back_h/2, -back_t])
    linear_extrude(back_t)
      offset(back_r) offset(-back_r) polygon([
        [0,back_h], [back_tw,back_h],[back_tw-back_tw_bw_diff,0],[back_tw_bw_diff,0]
      ]);
  
  // Pins
  pin_l = 4;
  pin_spacing = 11.5/4;
  pin_v_spacing = 2;
  // Top five pins
  for(p = [0:4]) translate([(p-2)*pin_spacing,pin_v_spacing,-back_t-pin_l])  {
    cylinder(d=1.5,h=pin_l+back_t+plate_t+front_t+0.1);
  }
  // Bottom fourpins
  for(p = [0:3]) translate([(p-1.5)*pin_spacing,-pin_v_spacing,-back_t-pin_l])  {
    cylinder(d=1.5,h=pin_l+back_t+plate_t+front_t+0.1);
  }
}



