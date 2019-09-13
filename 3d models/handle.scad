
extra_z = 25; // Increase Z-axis height by this amount
z_increase_len = 15; //Amount of y axis distance used to increase height to extra_z
screw_head_radius =  6.5/2;
screw_radius =  1.6;
nut_radius = 6/2;
handle_length = 275/2;
handle_diameter = 20;
structural_z_offset = 12;
structural_z_offset_small = 15;
structural_y_offset_max = 120;

hit_box_z_dim =10;
/*
color([1,0,0])
translate([-20,9,-18-hit_box_z_dim])cube([40,255,hit_box_z_dim]);*/

$fn = 40;
/*
difference(){
  union(){
         rotate([-90,0,0])cylinder(d=handle_diameter,h=z_increase_len/2);
    
            translate([0,z_increase_len,extra_z]) rotate([-90,0,0])cylinder(d=handle_diameter,h=handle_length-z_increase_len);
    
    hull(){
        
             translate([0,0,0])
      rotate([-90,0,0])cylinder(d=handle_diameter,h=12);
      
       translate([0,z_increase_len,extra_z])
      rotate([-90,0,0])cylinder(d=handle_diameter,h=1);
      
      translate([0,0,-structural_z_offset])
          rotate([-90,0,0])cylinder(d=handle_diameter,h=7.5);
      
    }
    
    // Structural piece, big diameter

      hull(){
        
            translate([0,z_increase_len,extra_z]) rotate([-90,0,0])cylinder(d=handle_diameter/2,h=handle_length-z_increase_len);
         translate([0,structural_y_offset_max*0.5,extra_z])rotate([-90,0,0])cylinder(d=handle_diameter/2,h=1);
        
        translate([0,z_increase_len-2,extra_z-structural_z_offset_small])
            rotate([-90,0,0])cylinder(d=handle_diameter/1.5,h=7.5);
        
      }
      hull(){
        
         translate([0,structural_y_offset_max,extra_z])rotate([-90,0,0])cylinder(d=handle_diameter/3,h=1);
        
        translate([0,z_increase_len,extra_z-structural_z_offset_small])
            rotate([-90,0,0])cylinder(d=handle_diameter/3,h=7.5);
        
      }
      
    }
    rotate([-90,0,0])cylinder(r=screw_radius,h=20);
  
  // Hole for nut
  translate([0,13.1,0]){
    hull(){
      rotate([-90,0,0])cylinder(r=nut_radius,h=2.5);
      translate([0,0,-100])rotate([-90,0,0])cylinder(r=nut_radius*2,h=6);
    }
  }
  
  //Holes for vertical mount
   translate([0,handle_length - 8,0])cylinder(r=1.6,h=100);
   translate([0,handle_length - 18,0])cylinder(r=1.6,h=100);
   translate([0,handle_length - 28,0])cylinder(r=1.6,h=100);
  
  //Holes for reinforcement
  rein_len = 79;
  translate([-5,handle_length-rein_len,extra_z]) rotate([-90,0,0])cylinder(d=2.17,h=rein_len);
    translate([5,handle_length-rein_len,extra_z]) rotate([-90,0,0])cylinder(d=2.17,h=rein_len);
  
  translate([0,-0.1,0]){
    hull(){
      rotate([-90,0,0])cylinder(d=13.5,h=5);
      translate([0,0,-100])rotate([-90,0,0])cylinder(d=13.5,h=5);
    }
  }
}
*/
// Sleeve
sleeve_len = 34*2;
difference(){
  
  minkowski(){
  translate([0,handle_length-sleeve_len*0.5,extra_z])rotate([-90,0,0])cylinder(d=handle_diameter+2,h=sleeve_len);
    sphere(r=1.5);
  }
  translate([0,handle_length-sleeve_len*0.5 - 2,extra_z])rotate([-90,0,0])cylinder(d=handle_diameter+0.505,h=sleeve_len*2);
   
  translate([0,handle_length - 8,0])cylinder(r=1.6,h=100);
   translate([0,handle_length - 18,0])cylinder(r=1.6,h=100);
   translate([0,handle_length - 28,0])cylinder(r=1.6,h=100);
  
     translate([0,28+8+0.1,0]){
  translate([0,handle_length - 8,0])cylinder(r=1.6,h=100);
   translate([0,handle_length - 18,0])cylinder(r=1.6,h=100);
   translate([0,handle_length - 28,0])cylinder(r=1.6,h=100);
     }
     
     r = (6.5 + 0.1) / 2;
     translate([0,0,-86]){
       translate([0,handle_length - 8,0])cylinder(r=r,h=100);
   translate([0,handle_length - 18,0])cylinder(r=r,h=100);
   translate([0,handle_length - 28,0])cylinder(r=r,h=100);
  
     translate([0,28+8+0.1,0]){
  translate([0,handle_length - 8,0])cylinder(r=r,h=100);
   translate([0,handle_length - 18,0])cylinder(r=r,h=100);
   translate([0,handle_length - 28,0])cylinder(r=r,h=100);
     }
   }
   
   translate([0,0,36]){
       translate([0,handle_length - 8,0])cylinder(r=r,h=100);
   translate([0,handle_length - 18,0])cylinder(r=r,h=100);
   translate([0,handle_length - 28,0])cylinder(r=r,h=100);
  
     translate([0,28+8+0.1,0]){
  translate([0,handle_length - 8,0])cylinder(r=r,h=100);
   translate([0,handle_length - 18,0])cylinder(r=r,h=100);
   translate([0,handle_length - 28,0])cylinder(r=r,h=100);
     }
   }
   
     
  
}

