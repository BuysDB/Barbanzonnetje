include <./wateringConnectors.scad>

// PieTest

/**
* @author: Marcel Jira

 * This module generates a pie slice in OpenSCAD. It is inspired by the
 * [dotscad](https://github.com/dotscad/dotscad)
 * project but uses a different approach.
 * I cannot say if this approach is worse or better.

 * @param float radius Radius of the pie
 * @param float angle  Angle (size) of the pie to slice
 * @param float height Height (thickness) of the pie
 * @param float spin   Angle to spin the slice on the Z axis
 */
module pie(radius, angle, height, spin=0) {
	// calculations
	ang = angle % 360;
	absAng = abs(ang);
	halfAng = absAng % 180;
	negAng = min(ang, 0);

	// submodules
	module pieCube() {
		translate([-radius - 1, 0, -1]) {
			cube([2*(radius + 1), radius + 1, height + 2]);
		}
	}

	module rotPieCube() {
		rotate([0, 0, halfAng]) {
			pieCube();
		}
	}

	if (angle != 0) {
		if (ang == 0) {
			cylinder(r=radius, h=height);
		} else {
			rotate([0, 0, spin + negAng]) {
				intersection() {
					cylinder(r=radius, h=height);
					if (absAng < 180) {
						difference() {
							pieCube();
							rotPieCube();
						}
					} else {
						union() {
							pieCube();
							rotPieCube();
						}
					}
				}
			}
		}
	}
}



wt = 1.5;
$fn=80;

wt=2;
valveHeight = 5;
valveRadius = 13;
openingRadius=8;
// 19mm diag observed
// 9.5
nozzleOuterRadius = 6/2 + 1;
nozzleWallThickness =0.5;
nozzleTeethHeight = 0.5;
nozzleLength = 15;
nozzleWallInnerRadius = nozzleOuterRadius-nozzleWallThickness-nozzleTeethHeight;
slack=0.15;
vRad = valveRadius+wt*2;
module TOP(){
nozzles = 3;
for(i=[0:nozzles-1]){
    x = cos( (i/(nozzles-1)) * 180)*openingRadius;
    y = sin( (i/(nozzles-1)) * 180)*openingRadius;
    
    translate([x,y,valveHeight+wt+slack*3])rotate([0,180,0])Nozzle(  nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength);
}


  difference(){
  for(i=[0:3]){
        x = cos( (i/(4)) * 360+ 45)*vRad;
        y = sin( (i/(4)) * 360+ 45)*vRad;
        translate([x,y,valveHeight+wt+2*slack])cylinder(r=1.5+wt,h=wt);
  }

  
  for(i=[0:3]){
        x = cos( (i/(4)) * 360+ 45)*vRad;
        y = sin( (i/(4)) * 360+ 45)*vRad;
        translate([x,y,valveHeight+wt+slack])cylinder(r=1.5,h=valveHeight);
  }
  }
  


difference(){
translate([0,0,wt+slack*2+valveHeight])cylinder(r=valveRadius+slack+wt,h=wt);
        for(i=[0:nozzles-1]){
    x = cos( (i/(nozzles-1)) * 180)*openingRadius;
    y = sin( (i/(nozzles-1)) * 180)*openingRadius;
    
    translate([x,y,valveHeight+wt+slack])rotate([0,180,0])Nozzle(  nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength,inner=1);}}

  
  
    
   

  difference(){
  for(i=[0:3]){
        x = cos( (i/(4)) * 360 + 45)*vRad;
        y = sin( (i/(4)) * 360 + 45)*vRad;
        translate([x,y,valveHeight+wt+2*slack])cylinder(r=1.5+wt,h=wt);
  }

  
  for(i=[0:3]){
        x = cos( (i/(4)) * 360 + 45)*vRad;
        y = sin( (i/(4)) * 360 + 45)*vRad;
        translate([x,y,valveHeight+wt+slack])cylinder(r=1.5,h=valveHeight);
  }
  }
}

module CENTER(){
    
    translate([0,0,wt+slack]){
    difference(){
        cylinder(r=valveRadius,h=valveHeight);
         
        translate([0,0,-0.01])
        minkowski(){

            difference(){
                translate([0,0,0])pie(radius=openingRadius,angle=90, height=wt);
                translate([0,0,0])cylinder(r=openingRadius-0.01,h=wt);
            }
             rotate([0,0,-10])
            
            cylinder(r=nozzleWallInnerRadius,h=wt);
        };
        
        rotate([0,0,45]){
      translate([0,0,wt])cylinder(r=7/2,h=valveHeight+wt);
       color([1,0,0])translate([-16,-2.5,wt])cube([16,5,valveHeight+wt]);
        }

    }
    //cylinder(r=valveRadius,h=wt);
    }
    }
   

module BOTTOM(){
    color([0,0,1])

    translate([0,0,wt])difference(){
        
        cylinder(r=valveRadius+slack+wt,h=valveHeight+wt);
        translate([0,0,-1])cylinder(r=valveRadius+slack,h=valveHeight+3*wt+2);
    }

    grabberH  = 5;
    difference(){
        translate([0,0,wt+slack+valveHeight]){
            cylinder(r=valveRadius+slack+wt,h=grabberH);
        }
        //SG90 circle
        translate([0,0,wt+slack+valveHeight]){
            cylinder(r=6-0.1,h=grabberH);
        }
        
        translate([0,6.5,wt+slack+valveHeight]){
            cylinder(r=3,h=grabberH);
        }
        
        translate([-6.0/2,6.5 -6.0,wt+slack+valveHeight]){
            cube([6.0,6.0,grabberH]);
        }
        
    }


    qh = valveHeight+slack+grabberH;
    translate([0,0,wt]){
      difference(){
      for(i=[0:3]){
            x = cos( (i/(4)) * 360 + 45)*vRad;
            y = sin( (i/(4)) * 360 + 45)*vRad;
            translate([x,y,0])cylinder(r=1.5+wt,h=qh);
      }

      
      for(i=[0:3]){
            x = cos( (i/(4)) * 360 +45)*vRad;
            y = sin( (i/(4)) * 360 + 45)*vRad;
            translate([x,y,0])cylinder(r=1.5,h=qh);
      }
      }
    }
}

//TOP();
//BOTTOM();
CENTER();
