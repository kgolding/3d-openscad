
// Show part laid down ready for 3D Printing without support
Show_Parts = true;

PCB_Width = 30;

PCB_Height = 70;

PCB_Thickness = 1.6;

PCB_Rear_Gap = 4;

Text = "My PCB";

Text_Size = 8;

// Extra width/height to allow it to fit
PCB_Extra = 0.5;

// Size of lip holding the PCB in place
LIP_Size = 1.8;

Screw_Diameter = 3.2;
Screw_Thread_Diameter = 2.8;

pcbWidth = PCB_Width + PCB_Extra;
pcbHeight = PCB_Height + PCB_Extra;

lip = LIP_Size;

assert(Text_Size < PCB_Width - LIP_Size * 2, "Text size too large");
assert(PCB_Width >= 10, "PCB Width must be at least 10 mm");
assert(PCB_Height > 54, "PCB Height must be at least 55 mm");

$fn = 30;

if (Show_Parts) {
  // We cut the holder in half to let the PCB slide in and to make it easy to print
  // with no support
  cutW = pcbWidth + lip * 2;
  cutH = pcbHeight + lip * 4;
  
  // Left side
  rotate([90,0,0]) difference() {
    pcbHolderWithDinClip();
    translate([-50, cutW/2, -1]) cube([100, cutW, cutH]);
  }

  // Right side
  translate([030, 0, 0]) rotate([-90,0,180]) translate([0,-cutW,0]) difference() {
    pcbHolderWithDinClip();
    translate([-50, -cutW/2, -1]) cube([100, cutW, cutH]);
  }
} else {
  pcbHolderWithDinClip();
}
translate([0,20,0]) pcbHolderWithDinClip();

module pcbHolderWithDinClip() {
  difference() {
    union() {
      dinClipOffset = ((pcbHeight + lip * 2) - 43)/2;
      translate([0, 0, dinClipOffset]) dinclip(pcbWidth + lip * 2);
      pcbHolder(pcbWidth = pcbWidth, pcbHeight = pcbHeight, lip = lip, pcbThickness=PCB_Thickness, backGap=PCB_Rear_Gap);
    };
    // Screw hole
    counterSinkD = Screw_Diameter * 2;
    translate([-5, -1, pcbHeight/2]) rotate([-90,0,0]) cylinder(r=Screw_Diameter/2, h=pcbWidth);
    translate([-5, -1, pcbHeight/2]) rotate([-90,0,0]) cylinder(r=counterSinkD/2, h=pcbWidth/2 - 3);
    translate([-5, pcbWidth/2 - 3 - 1, pcbHeight/2]) rotate([-90,0,0]) cylinder(r2=0, r1=counterSinkD/2, h=counterSinkD/2);
    // Screw thread hole
    translate([-5, 0, pcbHeight/2]) rotate([-90,0,0]) cylinder(d=Screw_Thread_Diameter, h=pcbWidth+lip*2 - 1);
  }
}

module pcbHolder(pcbWidth=30, pcbHeight=72, lip=3, pcbThickness=1.6, backGap=5) {
  w = pcbWidth + lip * 2;
  h = pcbHeight + lip * 2;
  t = lip + backGap + pcbThickness + lip;
  difference() {
    f = lip;
    // Body with chamfered corners
    rotate([90,0,90]) linear_extrude(t) polygon([
        [f, 0], [0, f], [0, h-f], [f, h], [w-f, h], [w, h-f], [w, f], [w-f, 0]
    ]);
    // Cut out
    translate([lip, lip * 2, lip * 2])
      cube([t, pcbWidth - lip * 2, pcbHeight - lip * 2]);
    // PCB slots
    translate([lip + backGap, lip, lip])
      cube([pcbThickness, pcbWidth, pcbHeight]);
    // Text
    translate([lip-0.3,w/2,h/2])
      rotate([90,-90,90])
        linear_extrude(1)
          text(Text, size=Text_Size, halign="center", valign="center");      
  }
}

module dinclip(width) {
  rotate([90,0,180]) {
    // 2D profile
    h = 43;
    d = 20;
    dinD = 7.5;
    dinH = 35;
    dinLip = 4;
    dinT = 1.4;
    dipLipSlantExtra = 0.5;
    clipT = 2;
    clipB = 1.5;
    clipGap = 1;
    clipOverlap = 2;
    overlap = 2;
    
    backGap = 1;
    dinFromTop = h - dinH - clipT - clipGap;
    
    tiny = 0.001;
      
    assert(h > clipT + clipGap + dinH + clipT);
    
    lr = 1.5;       // Large radius
    sr = 0.75;      // Small radius
    xr = lr * 4;    // Extra large radius
      
    difference() {
      linear_extrude(width) union() {
        // Top clip
        hull() {
          translate([d - lr - backGap, h - lr]) intersection() { // Top radius
            circle(lr);
            square(lr);
          }
          translate([d - sr - backGap, h - dinFromTop - overlap]) circle(sr);
          translate([d - dinD + dinT + sr - backGap, h - dinFromTop- overlap]) circle(sr);
          translate([d - dinD + dinT - backGap - dipLipSlantExtra, h - dinFromTop]) square([0.1, dinFromTop]);
        }
        // Top clip to body
        translate([d - dinD - backGap, h - dinFromTop]) square([dinD - lr, dinFromTop]);
        
        // Body (less bottom clip)
        translate([0, clipT + clipGap]) square([d - dinD - backGap, h - clipT - clipGap]);
        
        // Bottom clip body
        difference() {
          square([d - backGap - lr, clipT + clipGap - 0.01]);
          // Gap
          hull() {
            translate([clipB + clipGap/2, clipT + clipGap/2]) circle(d=clipGap);
            translate([d - clipB - backGap, clipT]) square(clipGap);
          }
        }
          
        // Bottom clip gap
        hull() {
          translate([d - backGap - lr / 2, lr /2]) circle(d=lr);
          translate([d - backGap -lr / 2, clipT + clipGap + clipOverlap + lr/2]) circle(d=lr);
          translate([d - backGap - dinD + dinT + dipLipSlantExtra + lr / 2, clipT + clipGap + clipOverlap + lr /2]) circle(d=lr);
          translate([d - backGap - dinD + dinT, 0]) square(clipT);
        }
        
        // Fillets to main body
        translate([xr,-xr]) rotate(90) difference() { // Top radius
          square(xr);
          circle(xr);
        }
        translate([xr,h+xr]) rotate(180) difference() { // Top radius
          square(xr);
          circle(xr);
        }            
      }
      
      // Cut out of bottom clip to allow flex
      cw = 8;
      if (width/2 - cw >= lr) {
        rotate ([90,0,0]) hull() {
          translate([0, cw/2, -clipT - clipGap]) cube([1, width/2 - cw, xr* 2]);
          translate([d - backGap - dinD, cw/2 - lr/2, -clipT - 0.1]) cylinder(d=lr, h=clipT + 0.2);
          translate([d - backGap - dinD, width/2 - cw/2 + lr/2, -clipT - 0.1]) cylinder(d=lr, h=clipT + 0.2);
        }      
        rotate ([90,0,0]) hull() {
          translate([0, width/2 + cw/2, -clipT - clipGap]) cube([0.1, width/2 - cw, xr* 2]);
          translate([d - backGap - dinD, width - cw/2 - lr/2, -clipT - 0.1]) cylinder(d=lr, h=clipT + 0.2);
          translate([d - backGap - dinD, width/2 + cw/2 + lr/2, -clipT - 0.1]) cylinder(d=lr, h=clipT + 0.2);
        }
      }
    }
  }
}

