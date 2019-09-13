module Bearing(extra_space=0){
  difference(){
    rotate([-90,0,0])cylinder(d=22+extra_space,h=7);
    translate([0,-1,0])rotate([-90,0,0])cylinder(d=8+extra_space,h=9);
  }
  
}

screw_head_radius =  6.5/2;
screw_radius =  1.6;


$fn = 40;
wall_clearance = 3; // Clearance to the wall
bearing_holder_clearance = 0.5; // distance between handle and bearing holder
handle_wt = 3;// Thickness of handle walls
bearing_holder_wt = 3;
extra_space=0.12;

module BearingCenter(){
difference(){
 translate([0,-extra_space,0])rotate([-90,0,0])cylinder(d=8-extra_space,h=7+2*extra_space);
translate([0,-extra_space-1,0])rotate([-90,0,0])cylinder(r=screw_radius,h=10);
}
}

/*
color([1,1,1])
translate([0,bearing_holder_clearance+wall_clearance+handle_wt,0])Bearing();
*/

box_dimension_x = 151.5;
box_dimension_y = 250; //!!!!!! NOT EXACT !!!!!!
box_dimension_z = 138;



handle_z_center_topd = 25; // Distance from top to handle center
bearing_z_bar_offset = 15; //Distance from bearing to attachement bar
bearing_z_bar_z_dim = 20; //Height of z_bar

/*
translate([-box_dimension_x*0.5,-box_dimension_y,-box_dimension_z+handle_z_center_topd])
cube([box_dimension_x,box_dimension_y,box_dimension_z]);
*/
// Create cylinder which will hold the bearing in place


mkr = 1.5; // Minkowski radius
screw_offset_x = 9;

module PivotJoint(){
color([1,0,0])
translate([0,bearing_holder_clearance+wall_clearance+handle_wt,0]){
  //translate([-box_dimension_x*0.5,-bearing_holder_clearance-wall_clearance-handle_wt,-bearing_z_bar_offset-bearing_z_bar_z_dim])cube([box_dimension_x,3,bearing_z_bar_z_dim]);
  
  translate([0,mkr,0]){
    difference(){
    
      minkowski(){
      hull(){
        union(){
          
    rotate([-90,0,0])cylinder(d=22+extra_space+bearing_holder_wt*2,h=7-mkr*2);
        
        translate([0,-wall_clearance-bearing_holder_clearance,-bearing_z_bar_offset])rotate([-90,0,0])cylinder(d=22+extra_space+bearing_holder_wt*2+5,h=7-mkr*3);
        }
       
        }
         sphere(r=mkr);}
     
         translate([0,-mkr,0])
    rotate([-90,0,0])cylinder(d=22+extra_space,h=7+2*extra_space+8);
          
         screw_offset_z = -21;
         
         screw_offset_y=-2-wall_clearance;
         screw_head_start = 6;
      // Screw holes
         translate([-screw_offset_x,screw_offset_y,screw_offset_z])
      rotate([-90,0,0])cylinder(r=screw_radius,h=100);
         translate([-screw_offset_x,screw_offset_y+screw_head_start,screw_offset_z])
      rotate([-90,0,0])cylinder(r=screw_head_radius,r2=screw_head_radius*1.5,h=10);
            translate([screw_offset_x,screw_offset_y,screw_offset_z])
      rotate([-90,0,0])cylinder(r=screw_radius,h=100);
         translate([screw_offset_x,screw_head_start+screw_offset_y,screw_offset_z])
      rotate([-90,0,0])cylinder(r=screw_head_radius,r2=screw_head_radius*1.5,h=10);
      
         
       
       translate([0,-6-mkr,0])rotate([-90,0,0])cylinder(d=19.5,h=7);
         
       translate([-box_dimension_x*0.5,-6-mkr+extra_space,-8])cube([box_dimension_x,6,100]);
         
    }
    
  
  }
}
}


module HandleVbar(bar_len=100, width=10, thickness=2){
  
  
    //translate([0,-1,0])rotate([-90,0,0])cylinder(d=8-0.12,h=9);
  difference(){
  union(){
  
//Back
    junction_bar_len = 20;
    junction_len = 20;
    
    
    hull(){
      
      translate([0,-thickness-bearing_holder_clearance,3])rotate([-90,0,0])cylinder(d=22,h=2);
      
      translate([0,-thickness-bearing_holder_clearance,3+junction_bar_len])rotate([-90,0,0])cylinder(d=width+3,h=thickness);

    }
    
   hull(){
      
      translate([0,-2-bearing_holder_clearance,3+junction_bar_len])rotate([-90,0,0])cylinder(d=width+3,h=thickness);
    
           translate([0,2,3+junction_len+junction_bar_len])rotate([-90,0,0])cylinder(d=width+3,h=thickness);
    }
    
  
    
    minkowski(){
      union(){
     hull(){
        
        translate([0,7+bearing_holder_clearance,3])rotate([-90,0,0])cylinder(d=22,h=thickness);
        
        translate([0,7+bearing_holder_clearance,3+junction_bar_len])rotate([-90,0,0])cylinder(d=width,h=thickness);

      };
      
     hull(){
        
        translate([0,7+bearing_holder_clearance,3+junction_bar_len])rotate([-90,0,0])cylinder(d=width,h=thickness);
      
             translate([0,3,3+junction_len+junction_bar_len])rotate([-90,0,0])cylinder(d=width,h=thickness);
      }
    
      //Structural:
         hull(){
        
        translate([0,7+bearing_holder_clearance,3+junction_bar_len])rotate([-90,0,0])cylinder(d=width*0.3,h=thickness);
      
             translate([0,3,3+junction_len+junction_bar_len*2])rotate([-90,0,0])cylinder(d=width*0.3,h=thickness);
      }
          hull(){
        
        translate([0,7+bearing_holder_clearance,3+junction_bar_len])rotate([-90,0,0])cylinder(d=width*0.3,h=2);
      
             translate([0,3,3+junction_len+junction_bar_len*3])rotate([-90,0,0])cylinder(d=width*0.3,h=thickness);
      }
      //Joined
      
       hull(){
        
        translate([0,2,3+junction_bar_len+junction_bar_len])rotate([-90,0,0])cylinder(d=width,h=3);
      
             translate([0,2,3+bar_len])rotate([-90,0,0])cylinder(d=width,h=3);
      }
    }
    
  rotate([0,0,-90]){
    difference(){
    sphere(r=1.5);
    translate([0,-1.5,-1.5])cube(3,4,4);
    }
  }
}}
 
 translate([0,-2,3+bar_len])rotate([-90,0,0])cylinder(r=1.6,h=10);
   translate([0,6,3+bar_len])rotate([-90,0,0])cylinder(r=screw_head_radius,h=10);

    // Center axle mount point
   translate([0,-20,3])rotate([-90,0,0])cylinder(r=1.6,h=100);
  //Indents:
   translate([0,8.5+thickness-bearing_holder_clearance,3])rotate([-90,0,0])cylinder(r=screw_head_radius,h=10);
  translate([0,-4,3])rotate([-90,0,0])cylinder(r=screw_head_radius,h=2);
}
}


module CaseHoles(r,r2,h=100,hhole=true){
    // Holes for the attachement bar:
  if(hhole){
    translate([-screw_offset_x,0,0])rotate([-90,0,0])cylinder(r=screw_radius,h=h);
    translate([screw_offset_x,0,0])rotate([-90,0,0])cylinder(r=screw_radius,h=h);
  }
  //
  translate([-101/2,0,0])rotate([-90,0,0])cylinder(r=r,r2=r2,h=h);
  translate([101/2,0,0])rotate([-90,0,0])cylinder(r=r,r2=r2,h=h);

  translate([-135/2,0,0])rotate([-90,0,0])cylinder(r=r,r2=r2,h=h);
  translate([135/2,0,0])rotate([-90,0,0])cylinder(r=r,r2=r2,h=h);
 
}

//Case attachement bar:
case_bar_x_dim = 150;
case_bar_y_dim = 3;
case_bar_z_dim = 87;
case_bar_mink = 1.5;
  
module CASE_ATTACHEMENT_BAR(){

  difference(){
    translate([0,0,-case_bar_z_dim*0.5-21 + 27]){
      union(){
        minkowski(){
          translate([-case_bar_x_dim*0.5+case_bar_mink,case_bar_mink,-case_bar_z_dim*0.5+case_bar_mink])cube([case_bar_x_dim-case_bar_mink*2,case_bar_y_dim-case_bar_mink*2 + 0.1,case_bar_z_dim-2*case_bar_mink]);
           sphere(r=case_bar_mink);
        }
          translate([-case_bar_x_dim*0.5,0,-case_bar_z_dim*0.5])cube([case_bar_x_dim,case_bar_y_dim*0.5,case_bar_z_dim]);
      }
    }
  translate([0,0,-21]){
  //CaseHoles();
  translate([0,0,0]){CaseHoles(r=screw_radius,r2=screw_radius*1.1,h=3.1);}
  translate([0,0,-35]){CaseHoles(r=screw_radius,r2=screw_radius*1.1,h=3.1, hhole=false);}
  
  translate([0,2,0]){CaseHoles(r=screw_head_radius,r2=screw_head_radius*1.1,h=2);}
  translate([0,2,-35]){CaseHoles(r=screw_head_radius,r2=screw_head_radius*1.1,h=2, hhole=false);}
  
  
}
  //INLET 
  inlet_offset = -case_bar_x_dim*0.5+56; //56 from right side..
  translate([inlet_offset,-1,-case_bar_z_dim+6])rotate([-90,0,0])cylinder(d=13,h=50);
translate([inlet_offset,2,-case_bar_z_dim+6])rotate([-90,0,0])cylinder(d=16,h=50);
}
}
CASE_ATTACHEMENT_BAR();
//translate([0,bearing_holder_clearance+wall_clearance+handle_wt,0])HandleVbar();

