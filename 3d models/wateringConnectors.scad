wateringRingOuterRadius = 80/2;

nozzleOuterRadius = 2.53;
nozzleWallThickness =0.5;
nozzleTeethHeight = 0.5;
nozzleLength = 15;
nozzleWallInnerRadius = nozzleOuterRadius-nozzleWallThickness-nozzleTeethHeight;
nozzleRotation = 45;

module Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength, inner=0){
    
    nozzleWallInnerRadius = nozzleOuterRadius-nozzleWallThickness-nozzleTeethHeight;
    xC = [0:0.5:5];
    
    if(inner){
        translate([0,0,-nozzleLength])cylinder(h=nozzleLength,r=nozzleWallInnerRadius, $fn=80);
    } else {
    points = [
        for( x = xC )
        [(x/5)*nozzleLength,( (round(x)%2)*nozzleTeethHeight)]

    ];
    pointsI = concat(
        
        [[points[0][0]-0.5, -nozzleWallThickness]],
        points,
        [[points[len(points)-nozzleWallThickness][0], -nozzleWallThickness]]
        );

    echo(pointsI);
    points2 = [ for(c=pointsI) [c[1],c[0]]];

    translate([0,0,-nozzleLength])
    rotate_extrude(angle = 360, convexity = 2,$fn=80) {
         translate([nozzleWallInnerRadius+nozzleWallThickness,0,0])polygon( points=points2 );
        
        }
    }
}

if(0){
rotate([0,nozzleRotation,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength);
 // Watering Ring
    FNRING = 80;
    

translate([wateringRingOuterRadius,0,0])difference(){
  
     rotate([0,0,30])rotate_extrude(angle=300, convexity = 1,$fn=FNRING)
    translate([wateringRingOuterRadius, 0, 0])
    circle(r = nozzleOuterRadius);

      rotate([0,0,30])rotate([0,0,1])rotate_extrude(angle=298, convexity = 1,$fn=FNRING)
    translate([wateringRingOuterRadius, 0, 0])
    circle(r = nozzleWallInnerRadius);
    
    translate([-wateringRingOuterRadius,0,0])
    rotate([0,nozzleRotation,0])translate([0,0,-nozzleLength])cylinder(h=nozzleLength,r=nozzleWallInnerRadius, $fn=80);
    
    for(alpha=[40:9:320]){
        translate([
            cos(alpha)*(wateringRingOuterRadius - nozzleWallThickness-nozzleOuterRadius),
            sin(alpha)*(wateringRingOuterRadius - nozzleWallThickness- nozzleOuterRadius),
        0])rotate([0,90,alpha])cylinder(h=nozzleOuterRadius+nozzleWallThickness,r=0.5);
    }
    
}
    
 // Center cylinder:
//translate([0,0,-nozzleLength])cylinder(h=nozzleLength,r=nozzleWallInnerRadius, $fn=80);
}    

/*
degAng = 110;
difference(){
    union(){    
        translate([-nozzleOuterRadius,-nozzleOuterRadius,-nozzleOuterRadius])cube([nozzleOuterRadius*2,nozzleOuterRadius*2,nozzleOuterRadius*2] );
    rotate([0,90,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength);
        
      rotate([0,90,degAng])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength);
        
          rotate([0,90,360-degAng])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength);
        
    };
    
            sphere(r=nozzleWallInnerRadius, $fn=80);

    rotate([0,90,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength, inner=1);
        
      rotate([0,90,degAng])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength,inner=1);
        
          rotate([0,90,360-degAng])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength,inner=1);

}*/