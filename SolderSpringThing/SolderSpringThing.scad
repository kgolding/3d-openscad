// Solder spring thingy

// Width
w = 15;
// Base size
bs = 65;
// Base thickness
bt = 3;
// Arm & spring thickness
t = 1.3;
// Loop radius
r = 2;
// Ring radius
rr = 15;
// Number of loop pairs
loops = 6;

// Arm length
al = bs - 2 * rr;

// Loop arc angle
a = 180;

// astep is the angle each inner/outer loop consumes
astep = arc_angle_from_chord(rr, 2*r*2);

$fn = 50;

linear_extrude(w) {
  difference() {
    union() {
      rotate(-45) translate([-rr,r]) {
        // Spring
        Spring();

        // For debugging
        // SpringPath();
        
        // Arm
        rotate(astep * (loops + 0.75) - arc_angle_from_chord(rr, t/2)) translate([rr,0]) rotate (-10){
          // square(t);
          square([al,t]);
          translate([al,0]) circle(t);
        }
      }
      // Base
      translate([-bs,-t/2]) square([bs+2*r,bt]);
    }
  
    // Mask out any spring overlap on the base
    translate([-r,-t/2+bt]) square([1.5*r,2]);
    translate([-r*3, -t/2-1]) square([10*r,1]);
  }
}

module Spring() {
  // Outer loops
  for (s=[0:loops]) {
    rotate(s * astep)
      translate([rr,0])
        rotate(-90)
          arc(r,t,a);
  }

  // Inner loops
  for (s=[0:loops]) {
    o = 10; // The inner arcs are a little smaller
    rotate(s * astep + astep/2)
      translate([rr,0])
        rotate(90+o)
          arc(r,t,a - 2*o);
  }
}

// Draw a blue circle for the springs radius (debugging)
module SpringPath() {
  color("blue") difference() {
      circle(rr+0.1);
      circle(rr-0.1);
    }
}

// Returns angle (in degrees) given chord length and radius
function arc_angle_from_chord(radius, chord_length) =
    2 * asin(chord_length / (2 * radius));

// Returns lenght of a chord
function arc_chord_length(radius, angle) =
    2 * radius * sin(angle/2);

// arc draws an arc formed of rotates squares
module arc(radius=50, thickness=1, angle=90) {
  q = 360/$fn; // q is the step angle per sqaure
  step = angle < q ? angle : q; // to handle very small angles
  for (a = [step:step:angle]) {
    hull() { // draw a hull between the previous sqaure the the next
      translate([r*cos(a-step), r*sin(a-step)])
        rotate(a-step)
          square(thickness, center=true);
      translate([r*cos(a), r*sin(a)])
        rotate(a)
          square(thickness, center=true);
    }
  }

}
