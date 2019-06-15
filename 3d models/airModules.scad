
include <./wateringConnectors.scad>

wt = 1.5;
$fn=20;


// 19mm diag observed
// 9.5
nozzleOuterRadius = 6/2 + 1;
nozzleWallThickness =0.5;
nozzleTeethHeight = 0.5;
nozzleLength = 15;
nozzleWallInnerRadius = nozzleOuterRadius-nozzleWallThickness-nozzleTeethHeight;



module FANCON(){
    
    slack=0.075;
    outerYs = 58;
    outerXs = 20;
    outerZs =  33;
    wt = 1;
    
xOff = nozzleWallInnerRadius+wt;        
    outlets = 4;
    tw = (outerYs+nozzleOuterRadius*2)/outlets;
    
    difference(){

            
            
            minkowski(){
            cube([outerXs,outerYs+wt*2,outerZs+wt*2]);
            sphere(r=0.5);
        
        }
        
        translate([wt-0.5*slack+xOff,wt-0.5*slack,wt-0.5*slack])cube([outerXs-xOff,outerYs+slack,outerZs+slack]);
        for(i=[0:outlets-1]){
       translate([nozzleOuterRadius+wt,nozzleOuterRadius+wt+tw*i,wt])rotate([180,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,outerZs+wt*2,inner=1);
        }
    }

    for(i=[0:outlets-1]){
     translate([nozzleOuterRadius+wt,nozzleOuterRadius+wt+tw*i,outerZs+wt+slack])rotate([180,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength);
    }

    
}



module WINDSENCO(){

    nozzleOffset = 7;
    
    height = 18;

    translate([-nozzleOffset,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength);

    translate([nozzleOffset,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength);
    

    difference(){
        union(){
            cylinder(r=12,h=height);
            
            difference(){
                translate([-5,0,height-2])cube([10,19,2]);
                translate([0,15,height-2])cylinder(r=1.51,h=4);
            }
            difference(){
                translate([-5,-19,height-2])cube([10,19,2]);
                translate([0,-15,height-2])cylinder(r=1.51,h=4);
            }
        }

        translate([0,0,wt])cylinder(r=10.15,h=height);
        
     translate([nozzleOffset,0,wt])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength,inner=1);
    translate([-nozzleOffset,0,wt])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength,inner=1);

    }
}

    //WINDSENCO();
//


clampW = 2;
offset = 0.90;
r=2.2;
module CJMCU4541(){
    xS = 22;
    yS= 15.2;
color([1,0,0,0.1]){
    translate([8.5,5,1.5])cube([7,5,3-1.5]);

    //Components and crap
    translate([6.5,10,1.5])cube([10,4.5,0.5]);

    
    
    difference(){
    cube([xS,15.2,1.5]);
    translate([xS-r-offset,yS-r-offset,0])cylinder(r=2,h=3);
    translate([xS-r-offset,offset+r,0])cylinder(r=2,h=3);
        
        
}}}

//Cutout:
/*
color([0,0,1]){
translate([6.5,0,1.5])cube([10,yS,3]);
}*/
module CJMCU4541_TOP(){
    xS = 22;
    yS= 15.2;
  difference(){
    union(){
    difference(){
        xReduction = 2;
        minkowski(){
            union(){
                translate([3+xReduction,-clampW,1.5])cube([xS-3-xReduction,yS+clampW*2,4]);
                translate([3+clampW,yS+2+1,1.5])cylinder(r=3,h=4);
                translate([3+clampW,-3,1.5])cylinder(r=3,h=4);
            }
            sphere(r=0.5);
        }
        translate([3+clampW,yS+2+1,0])cylinder(r=2,h=10);
        translate([3+clampW,-3,0])cylinder(r=2,h=10);
        
        offsetAdditionalY = -0.5;
        translate([xS-r-offset,yS-r-offset-offsetAdditionalY,0])cylinder(r=2,h=10);
        translate([xS-r-offset,offset+r+offsetAdditionalY,0])cylinder(r=2,h=10);
        
        translate([8.5*0.5 + 8,3.5+nozzleOuterRadius,0]){
    
        nozzleOffset = 6;
         translate([0,-nozzleOffset,2])rotate([180,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength,inner=1);

        translate([0,nozzleOffset,2])rotate([180,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength,inner=1);
        }
        
        innerYs = 14.5;
        minkowski(){
            translate([6.5+0.5,(yS-innerYs)/2,1.5])cube([10-0.5-0.5-0.5,innerYs,3]);
            sphere(r=0.5);
        }
    
    }
        
    translate([8.5*0.5 + 8,3.5+nozzleOuterRadius,5.5]){
    
    nozzleOffset = 6;
     translate([0,-nozzleOffset,0])rotate([180,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength);

    translate([0,nozzleOffset,0])rotate([180,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength);
    }
    }
         translate([-200,-200,0])cube([500,500,1.5]);
}}




module CJMCU4541_BOTTOM(){
    xS = 22;
    yS= 15.2;
    difference(){
      translate([0,0,-3.5]){
      difference(){
        union(){
        difference(){
            xReduction = 2;
            minkowski(){
                union(){
                    translate([3+xReduction,-clampW,1.5])cube([xS-3-xReduction,yS+clampW*2,4]);
                    translate([3+clampW,yS+2+1,1.5])cylinder(r=3,h=4);
                    translate([3+clampW,-3,1.5])cylinder(r=3,h=4);
                }
                sphere(r=0.5);
            }
            translate([3+clampW,yS+2+1,0])cylinder(r=2,h=10);
            translate([3+clampW,-3,0])cylinder(r=2,h=10);
            
            offsetAdditionalY = -0.5;
            translate([xS-r-offset,yS-r-offset-offsetAdditionalY,0])cylinder(r=2,h=10);
            translate([xS-r-offset,offset+r+offsetAdditionalY,0])cylinder(r=2,h=10);
            
        }
            

        }
             translate([-200,-200,5])cube([500,500,1.5]);
        }
       
    }
    slack = 0.15;
     translate([-0.15,-slack*0.5,-slack*0.5])cube([xS+slack,yS+slack,1.5+slack]);
    }
}


module SHX_BOTTOM(){
    xS = 22;
    yS= 15.2;
    ySS = 11.6; //Width of the SHTX
    difference(){
      translate([0,0,-3.5]){
      difference(){
        union(){
        difference(){
            xReduction = 2;
            minkowski(){
                union(){
                    translate([3+xReduction,-clampW,1.5])cube([xS-3-xReduction,yS+clampW*2,4]);
                    translate([3+clampW,yS+2+1,1.5])cylinder(r=3,h=4);
                    translate([3+clampW,-3,1.5])cylinder(r=3,h=4);
                }
                sphere(r=0.5);
            }
            translate([3+clampW,yS+2+1,0])cylinder(r=2,h=10);
            translate([3+clampW,-3,0])cylinder(r=2,h=10);
            
            offsetAdditionalY = -0.5;
            translate([xS-r-offset,yS-r-offset-offsetAdditionalY,0])cylinder(r=2,h=10);
            translate([xS-r-offset,offset+r+offsetAdditionalY,0])cylinder(r=2,h=10);
            
        }
            

        }
             translate([-200,-200,5])cube([500,500,1.5]);
        }
       
    }
    slack = 0.15;
    f = (yS - ySS)*0.5;
     translate([-7,-slack*0.5+f,-1+slack])cube([xS+slack,ySS+slack,2.5+slack]);
    }
}



module BME680_BOTTOM(){
    xS = 20;
    yS= 16.75;
    difference(){
      translate([0,0,-3.5]){
      difference(){
        union(){
        difference(){
            xReduction = 2;
            minkowski(){
                union(){
                    translate([3+xReduction,-clampW,1.5])cube([xS-3-xReduction,yS+clampW*2,4]);
                    translate([3+clampW,yS+2+1,1.5])cylinder(r=3,h=4);
                    translate([3+clampW,-3,1.5])cylinder(r=3,h=4);
                }
                sphere(r=0.5);
            }
            
            translate([3+clampW,yS+2+1,0])cylinder(r=2,h=10);
            translate([3+clampW,-3,0])cylinder(r=2,h=10);
            
            offsetAdditionalY = -0.5;
            /*
            translate([xS-r-offset,yS-r-offset-offsetAdditionalY,0])cylinder(r=2,h=10);
            translate([xS-r-offset,offset+r+offsetAdditionalY,0])cylinder(r=2,h=10);
            */
            
        }
            

        }
             translate([-200,-200,5])cube([500,500,1.5]);
        }
       
    }
    slack = 0.15;
     translate([-0.15,-slack*0.5,-slack*0.5])cube([xS+slack,yS+slack,1.5+slack]);
    }
}

module BME_680TOP(){
    xS = 20;
    yS= 16.75;
  difference(){
    union(){
    difference(){
        xReduction = 2;
        minkowski(){
            union(){
                translate([3+xReduction,-clampW,1.5])cube([xS-3-xReduction,yS+clampW*2,4]);
                translate([3+clampW,yS+2+1,1.5])cylinder(r=3,h=4);
                translate([3+clampW,-3,1.5])cylinder(r=3,h=4);
            }
            sphere(r=0.5);
        }
        translate([3+clampW,yS+2+1,0])cylinder(r=2,h=10);
        translate([3+clampW,-3,0])cylinder(r=2,h=10);
        
        offsetAdditionalY = -0.5;
        /*
        translate([xS-r-offset,yS-r-offset-offsetAdditionalY,0])cylinder(r=2,h=10);
        translate([xS-r-offset,offset+r+offsetAdditionalY,0])cylinder(r=2,h=10);
        */
        translate([8.5*0.5 + 8,(yS/2)-0.5*nozzleOuterRadius+wt+0.5,0]){
    
        nozzleOffset = 6;
            
         translate([0,-nozzleOffset,2])rotate([180,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength,inner=1);

        translate([0,nozzleOffset,2])rotate([180,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength,inner=1);
        }
        
        innerYs = 15;
        minkowski(){
            translate([6.5+0.5,(yS-innerYs)/2,1.5])cube([12,innerYs,3]);
            sphere(r=0.5);
        }
    
    }
        
    translate([8.5*0.5 + 8, (yS/2)-0.5*nozzleOuterRadius+wt+0.5,5.5]){
    
    nozzleOffset = 6;
     translate([0,-nozzleOffset,0])rotate([180,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength);

    translate([0,nozzleOffset,0])rotate([180,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength);
    }
    }
         translate([-200,-200,0])cube([500,500,1.5]);
}}





/*
Reqs:
fixed m3 hole distance
4 fixed m3 holes
spacing for generic electric adapter
mounting holes for pcb, distance between pcb pins is cl = 2.54;
module connector height is 2.8mm
m3 screw sinc W

*/
module MICS4514_V2(top=0){
    electrical_connector_height = 8.5; 
    electrical_socket_height = 3;
    generic_x_dimension = 24; //maximum board size of generic adapter plane
    generic_y_dimension = 26;
    generic_wall_thickness = 3.5;// Wall thickness given maximum sized board
    generic_top_height = 3 + generic_wall_thickness;
    generic_first_layer_height = electrical_connector_height + electrical_socket_height;
    
    
    board_thickness = 1.55;
    board_x_dimension = 15.5;
    board_y_dimension = 22.5; 
    board_pin_y_dimension = 2.7;
    board_pin_x_dimension = 13 + 1.5; //Add some slack for connector
    board_pre_pin_y_dim = 2.5; //distance between pins and components on board
    
    screw_hole_radius = 1.6;
    nut_diameter = 5.8 + 1;
    nut_depth = 3;
    screw_top_radius = 3;
    screw_top_depth = 2;
    rounded_radius = 1.5;
    
    //We center everything on the x axis!
    
    
    // draw board for reference:
    //translate([-board_x_dimension*0.5,0,0])color([0,0.5,0])cube([board_x_dimension,board_y_dimension,board_thickness]);
    if(!top){
    difference(){
        union(){
            // Create generic mount box:
            difference(){
                minkowski(){
            translate([-generic_x_dimension*0.5-generic_wall_thickness+rounded_radius,-generic_wall_thickness+rounded_radius,0])cube([generic_x_dimension+2*generic_wall_thickness-2*rounded_radius,generic_y_dimension+2*generic_wall_thickness-rounded_radius*2,board_thickness-rounded_radius]);
                    cylinder(r=rounded_radius);
                }
            
                //remove board
            translate([-board_x_dimension*0.5,-0.5,0])color([0,0.5,0])cube([board_x_dimension,board_y_dimension,board_thickness]);
                
                       // Cut out an opening for the connector:
                 translate([-board_pin_x_dimension *0.5,0,-generic_first_layer_height-10])cube([board_pin_x_dimension,board_pin_y_dimension,generic_first_layer_height*3]);
                
            }
            
            // Create generic mount box below
            difference(){
                // generic mount box:
                   minkowski(){
                        translate([-generic_x_dimension*0.5-generic_wall_thickness+rounded_radius,-generic_wall_thickness+rounded_radius,-generic_first_layer_height])cube([generic_x_dimension+2*generic_wall_thickness-2*rounded_radius,generic_y_dimension+2*generic_wall_thickness-2*rounded_radius,generic_first_layer_height]);
                       cylinder(r=rounded_radius,h=0.01);
                   }
                       
                
                
                // Cut out an opening for the connector:
                 translate([-board_pin_x_dimension *0.5,0,-generic_first_layer_height])cube([board_pin_x_dimension,board_pin_y_dimension,generic_first_layer_height+10]);
            }
                
        }
        // cull pins
        
        translate([-generic_x_dimension*0.5,0,-100])cylinder(r=screw_hole_radius,h=500);
        
        //Cutout for nut:
        translate([-generic_x_dimension*0.5,0,-generic_first_layer_height])cylinder(r=nut_diameter/2,h=nut_depth, $fn=6);
        
        
        translate([generic_x_dimension*0.5,0,-100])cylinder(r=screw_hole_radius,h=500);
        //Cutout for nut:
        translate([generic_x_dimension*0.5,0,-generic_first_layer_height])cylinder(r=nut_diameter/2,h=nut_depth, $fn=6);
        
        
        translate([-generic_x_dimension*0.5,generic_y_dimension,-100])cylinder(r=screw_hole_radius,h=500);
        //Cutout for nut:
        translate([-generic_x_dimension*0.5,generic_y_dimension,-generic_first_layer_height])cylinder(r=nut_diameter/2,h=nut_depth, $fn=6);
        
        
        translate([generic_x_dimension*0.5,generic_y_dimension,-100])cylinder(r=screw_hole_radius,h=500);
        //Cutout for nut:
        translate([generic_x_dimension*0.5,generic_y_dimension,-generic_first_layer_height])cylinder(r=nut_diameter/2,h=nut_depth, $fn=6);
        
        
    }
}
    //Top:
    if(top){
    offset = 8;

    difference(){
        minkowski(){
         translate([-generic_x_dimension*0.5-generic_wall_thickness+rounded_radius,-generic_wall_thickness+rounded_radius,0])cube([generic_x_dimension+2*generic_wall_thickness - 2*rounded_radius,generic_y_dimension+2*generic_wall_thickness-2*rounded_radius,generic_top_height]) ;
            sphere(r=rounded_radius);
        }
         
    translate([-offset,generic_y_dimension*0.5,0])rotate([180,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength,inner=1);
    translate([offset,generic_y_dimension*0.5,0])rotate([180,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength,inner=1);
        
    //PIN holes:
        translate([-generic_x_dimension*0.5,0,-100])cylinder(r=screw_hole_radius,h=500);
        translate([generic_x_dimension*0.5,0,-100])cylinder(r=screw_hole_radius,h=500);
        translate([-generic_x_dimension*0.5,generic_y_dimension,-100])cylinder(r=screw_hole_radius,h=500);
        translate([generic_x_dimension*0.5,generic_y_dimension,-100])cylinder(r=screw_hole_radius,h=500);
    
        
        
        translate([-generic_x_dimension*0.5,0,generic_top_height])cylinder(r=screw_top_radius,h=screw_top_depth);
        translate([generic_x_dimension*0.5,0,generic_top_height])cylinder(r=screw_top_radius,h=screw_top_depth);
        translate([-generic_x_dimension*0.5,generic_y_dimension,generic_top_height])cylinder(r=screw_top_radius,h=screw_top_depth);
        translate([generic_x_dimension*0.5,generic_y_dimension,generic_top_height])cylinder(r=screw_top_radius,h=screw_top_depth);
    
        
        //Remove inside
        translate([-generic_x_dimension*0.5,0,-5])cube([generic_x_dimension+2,generic_y_dimension,generic_first_layer_height]);
        //Remove bottom:
        
        translate([-generic_x_dimension*0.5-generic_wall_thickness,-generic_wall_thickness,-generic_first_layer_height])cube([generic_x_dimension+2*generic_wall_thickness,generic_y_dimension+2*generic_wall_thickness,generic_first_layer_height]);
        
    }
    
    
    
    
    
    
     translate([-offset,generic_y_dimension*0.5,generic_top_height])rotate([180,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength);
    translate([offset,generic_y_dimension*0.5,generic_top_height])rotate([180,0,0])Nozzle(nozzleOuterRadius,nozzleWallThickness,nozzleTeethHeight,nozzleLength);
    


}
    

}

MICS4514_V2(top=0);
//MICS4514_V2(top=1);
//BME680_BOTTOM();
//BME_680TOP();
//CJMCU4541_TOP();
//CJMCU4541_BOTTOM();
/*
difference(){
    translate([-wt,-wt,0])cube([26.5+2*wt, 91+wt*2, 20]);
    cube([26.5, 91, 20]);
}*/
