include <./frame.scad>
include <SwitecX27_168.scad> 


HOLE_K=1.01;

INST_H=13;
INST_D=70;

CARD_H=1;
CARD_D=9/10*INST_D;


      

$fn=50;
font = "Franklin Gothic Heavy";
//font = "Print Bold";
radius = 30.5;
height = 10;
insetDepth = 0.4;

openingRadius=8 - 1.5;

barRadius = radius - 3;
label_radius = barRadius - 6;


arm_lenght=5;
arm_thickness=0.7;
arm_thickness_minor = 0.2;


textSize=8;
textHeight=0.3;
bottom_text_offset = -12;
 grabberH  = 6;
 extra_grabber_height = 4;
 slack=0.15;
wt = 3;
f = (radius+slack+wt)*2.5;


m2_radius = 1.1 ;
m2_head_radius = 2.1;
m2_nut_radius = 4.5/2;

m2_head_depth = 2.2;
m2_nut_depth = 1.5;


increase_glass_pos = 3;
mount_cylinder_height = 18 + increase_glass_pos;

ring_radius = radius+wt-1;
ring_thickness = 3;
        
glass_radius = 6.35/2 *10 + 0.1;
glass_thickness = 0.3175*10;
glass_offset_z = 4 + increase_glass_pos;

face_mount_screw_radius = m2_radius;

module GLASS(){


color([1,1,1,0.1])translate([0,0,glass_offset_z])cylinder(r=glass_radius,h=glass_thickness);

}


module LIGHTRING(bounding_box=false){
    if(bounding_box){

        color([1,1,1,0.1])translate([0,0,0])cylinder(r=     ring_radius,h=ring_thickness);

    }


}


module FACE_RPM(){
  
  label_start = 0;
label_increment = 2;
N= 10;

total_angle = 360-90;
angle_start = 90;


  color([0,0,0])
  translate([0,0, -insetDepth])difference(){
      cylinder(r=radius,h= insetDepth);
      translate([0,0, -insetDepth])cylinder(r=openingRadius,h=99);
      
      
      translate([-13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      translate([13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      
     translate([0,25, -insetDepth])cylinder(r=1.52,h= 99);
  }

  translate([-14,0,0]){
  translate([1,14,0])
  linear_extrude(height=textHeight)text("FAN", size=textSize*0.75, halign="center", valign="center",font="Franklin Gothic");
  }

  translate([0,bottom_text_offset,0])
  linear_extrude(height=textHeight)text("kRPM", size=textSize/2.3, halign="center", valign="center",font=font );
  
  
    translate([0,21,0])
  linear_extrude(height=textHeight)text("stop", size=textSize/2.3, halign="center", valign="center",font=font );
  
  //translate([0,bottom_text_offset-5,0])
  //linear_extrude(height=textHeight)text("x100", size=textSize/2, halign="center", valign="center",font=font,$fn=80 );

  // Draw indication lines


  color([1,1,1])
  for(i=[1:N]){
      angle =  angle_start + 360 - (i * total_angle) / (N);
      
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius, 0, textHeight*0.5])
      cube (size = [arm_lenght,arm_thickness,textHeight], center =true);
      
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
      linear_extrude(height=textHeight)text(str((i*label_increment)+label_start), size=textSize/2, halign="center", valign="center",font=font );
      
   
  }

  for(i=[0:N*5]){
      angle =  angle_start + 360 - (i * total_angle) / (N*5);
        
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5 ])
      cube (size = [arm_lenght*0.5,arm_thickness*0.8,textHeight], center =true);
  }
}



module FACE_RPM_BATT(){
    
  barRadius = radius - 5;
  label_radius = barRadius - 4.9;

  arm_thickness=0.6;
  arm_thickness_minor = 0.2;
  

  label_start = 20;
  label_increment = -4;
  N= 5;

  total_angle = 180-40;
  angle_start = 90-20;
  
  difference(){
  union(){
  color([0,0,0])
  translate([0,0, -insetDepth])difference(){
      cylinder(r=radius,h= insetDepth);
      translate([0,0, -insetDepth])cylinder(r=openingRadius,h=99);
      
      
      translate([-13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      translate([13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      translate([0,-25, -insetDepth])cylinder(r=1.52,h= 99);
      
  }

  
  translate([-2,9,0])
  linear_extrude(height=textHeight)text("BAT", size=textSize*0.65, halign="right", valign="center",font="Franklin Gothic");
  
   translate([2,9,0])
  linear_extrude(height=textHeight)text("FAN", size=textSize*0.65, halign="left", valign="center",font="Franklin Gothic");
  
  

  translate([5,bottom_text_offset+2,0])
  linear_extrude(height=textHeight)text("kRPM", size=textSize/2.5, halign="left", valign="center",font=font );
  translate([-6,bottom_text_offset+2,0])
  linear_extrude(height=textHeight)text("%", size=textSize*0.75, halign="right", valign="center",font=font );

  //translate([0,bottom_text_offset-5,0])
  //linear_extrude(height=textHeight)text("x100", size=textSize/2, halign="center", valign="center",font=font,$fn=80 );

  // Draw indication lines


  color([1,1,1])
  for(i=[0:N]){
      angle =  angle_start - (i * total_angle) / (N);
      
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius+1.5, 0, textHeight*0.5])
      cube (size = [arm_lenght,arm_thickness,textHeight], center =true);
      
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
      linear_extrude(height=textHeight)text(str((i*label_increment)+label_start), size=textSize/2, halign="center", valign="center",font=font );
      
       
  }
  
  minor_ticks = (N*10*2*2) / 5;
  for(i=[0:minor_ticks]){
      angle =  angle_start - (i * total_angle) / (minor_ticks);;
        
    if(i%2==0){
            rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
      cube (size = [arm_lenght*0.7,arm_thickness*0.8,textHeight], center =true);
    } else{
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
      cube (size = [arm_lenght*0.5,arm_thickness*0.8,textHeight], center =true);
    }
  }


  // Battery face:
  N_bat = 5;
  angle_start_bat = -90-20;
  total_angle_bat=180-40;
  label_increment_bat = 20;
  label_start_bat = 0;
  bat_alert_angle = -140;
  warn_height=0.4;
  color([1,1,1])
  for(i=[0:N_bat]){
 
    
      angle =  angle_start_bat - (i * (total_angle_bat / (N_bat)));
      echo(angle);
     
      
    
       if( (angle<bat_alert_angle)){

          rotate( angle, [0, 0, 1])
       translate(v = [barRadius+1.5, 0, textHeight*0.5])
      cube (size = [arm_lenght,arm_thickness,textHeight], center =true);
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
        linear_extrude(height=textHeight)text(str((i*label_increment_bat)+label_start_bat), size=textSize/2, halign="center", valign="center",font=font );
       } else {

          rotate( angle, [0, 0, 1])
       translate(v = [barRadius+1.5, 0, (warn_height+textHeight)*0.5])
      cube (size = [arm_lenght,arm_thickness,textHeight+warn_height], center =true);
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
         linear_extrude(height=textHeight+warn_height)text(str((i*label_increment_bat)+label_start_bat), size=textSize/2, halign="center", valign="center",font=font );
       }
      
       
  }
  
  minor_ticks_bat = ((N_bat*8));
  for(i=[0:minor_ticks_bat]){
      angle =  angle_start_bat - (i * ( total_angle_bat / (minor_ticks_bat)));;
        
    if( (angle<bat_alert_angle)){
      if(i%4==0){
              rotate( angle, [0, 0, 1])
         translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
        cube (size = [arm_lenght,arm_thickness*0.8,textHeight], center =true);
      } else{
        rotate( angle, [0, 0, 1])
         translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
        cube (size = [arm_lenght*0.7,arm_thickness*0.8,textHeight], center =true);
      }}else{
        if(i%4==0){
              rotate( angle, [0, 0, 1])
         translate(v = [barRadius+arm_lenght*0.2, 0, (textHeight+warn_height)*0.5])
        cube (size = [arm_lenght*0.7,arm_thickness*0.8,textHeight+warn_height], center =true);
      } else{
        rotate( angle, [0, 0, 1])
         translate(v = [barRadius+arm_lenght*0.2, 0, (textHeight+warn_height)*0.5])
        cube (size = [arm_lenght*0.4,arm_thickness*0.8,textHeight+warn_height], center =true);
      
      }
      }
  }
  

  
    translate([0,-21,0])
  linear_extrude(height=textHeight+warn_height)text("stop", size=textSize/2.3, halign="center", valign="center",font=font );
}
}
}




module FACE_HYGRO(){
    
  label_start = 0;
  label_increment = 10;
  N= 10;

  total_angle = 360;
  angle_start = 90;
  
  barRadius = radius - 5;
  label_radius = barRadius - 4.9;


  arm_lenght=8;
  arm_thickness=0.6;
  arm_thickness_minor = 0.2;
  
  
  difference(){
  union(){
  color([0,0,0])
  translate([0,0, -insetDepth])difference(){
      cylinder(r=radius,h= insetDepth);
      translate([0,0, -insetDepth])cylinder(r=openingRadius,h=99);
      
      
      translate([-13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      translate([13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);

      
  }

  
  translate([0,11,0])
  linear_extrude(height=textHeight)text("HYGRO", size=textSize*0.65, halign="center", valign="center",font="Franklin Gothic");
  
  translate([-10,bottom_text_offset+2,0])
  linear_extrude(height=textHeight)text("RH", size=textSize*0.4, halign="center", valign="center",font=font );
  
     translate([-6,bottom_text_offset+2,0])
linear_extrude(height=textHeight)text("x1", size=textSize*0.4, halign="left", valign="center",font=font );
  
   translate([1,bottom_text_offset+2,0])
linear_extrude(height=textHeight+0.4)text("x0.01", size=textSize*0.4, halign="left", valign="center",font=font );


  //translate([0,bottom_text_offset-5,0])
  //linear_extrude(height=textHeight)text("x100", size=textSize/2, halign="center", valign="center",font=font,$fn=80 );

  // Draw indication lines


  color([1,1,1])
  for(i=[0:N]){
      angle =  angle_start - (i * total_angle) / (N);
      

      
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
      linear_extrude(height=textHeight)text(str((i*label_increment)+label_start), size=textSize/2, halign="center", valign="center",font=font );
      
       
  }
  
  minor_ticks = (N*10);
  for(i=[0:minor_ticks]){
      angle =  angle_start - (i * total_angle) / (minor_ticks);;
        
    if(i%5==0){
            rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
      cube (size = [arm_lenght*0.7,arm_thickness*0.8,textHeight], center =true);
    } else{
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
      cube (size = [arm_lenght*0.5,arm_thickness*0.8,textHeight], center =true);
    }
  }


  // Battery face:
  /*
  N_bat = 5;
  angle_start_bat = -90-20;
  total_angle_bat=180-40;
  label_increment_bat = 20;
  label_start_bat = 0;
  bat_alert_angle = -140;
  warn_height=0.1;
  color([1,1,1])
  for(i=[0:N_bat]){
 
    
      angle =  angle_start_bat - (i * (total_angle_bat / (N_bat)));
      echo(angle);
     
      
    
       if( true){

          rotate( angle, [0, 0, 1])
       translate(v = [barRadius, 0, textHeight*0.5])
      cube (size = [arm_lenght,arm_thickness,textHeight], center =true);
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
        linear_extrude(height=textHeight)text(str((i*label_increment_bat)+label_start_bat), size=textSize/2, halign="center", valign="center",font=font );
       } else {

          rotate( angle, [0, 0, 1])
       translate(v = [barRadius, 0, (warn_height+textHeight)*0.5])
      cube (size = [arm_lenght,arm_thickness,textHeight+warn_height], center =true);
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
         linear_extrude(height=textHeight+warn_height)text(str((i*label_increment_bat)+label_start_bat), size=textSize/2, halign="center", valign="center",font=font );
       }
      
       
  }
  
  minor_ticks_bat = ((N_bat*8));
  for(i=[0:minor_ticks_bat]){
      angle =  angle_start_bat - (i * ( total_angle_bat / (minor_ticks_bat)));;
        
    if( (angle<bat_alert_angle)){
      if(i%4==0){
              rotate( angle, [0, 0, 1])
         translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
        cube (size = [arm_lenght*0.7,arm_thickness*0.8,textHeight], center =true);
      } else{
        rotate( angle, [0, 0, 1])
         translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
        cube (size = [arm_lenght*0.5,arm_thickness*0.8,textHeight], center =true);
      }}else{
        if(i%4==0){
              rotate( angle, [0, 0, 1])
         translate(v = [barRadius+arm_lenght*0.2, 0, (textHeight+warn_height)*0.5])
        cube (size = [arm_lenght*0.7,arm_thickness*0.8,textHeight+warn_height], center =true);
      } else{
        rotate( angle, [0, 0, 1])
         translate(v = [barRadius+arm_lenght*0.2, 0, (textHeight+warn_height)*0.5])
        cube (size = [arm_lenght*0.5,arm_thickness*0.8,textHeight+warn_height], center =true);
      
      }
      }
  }
  
  */

}
}
}




module ADC(){
    
  label_start = 0;
  label_increment = 10;
  N= 10;

  total_angle = 360;
  angle_start = 90;
  
  barRadius = radius - 5;
  label_radius = barRadius - 4.5;


  arm_lenght=8;
  arm_thickness=0.7;
  arm_thickness_minor = 0.2;
  
  
  difference(){
  union(){
  color([0,0,0])
  translate([0,0, -insetDepth])difference(){
      cylinder(r=radius,h= insetDepth);
      translate([0,0, -insetDepth])cylinder(r=openingRadius,h=99);
      
      
      translate([-13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      translate([13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);

      
  }

  
  translate([0,11,0])
  linear_extrude(height=textHeight)text("ADC 1", size=textSize*0.65, halign="center", valign="center",font="Franklin Gothic");
  
  translate([0,bottom_text_offset+2,0])
  linear_extrude(height=textHeight)text("bits", size=textSize*0.4, halign="center", valign="center",font=font );
  
   translate([0,bottom_text_offset-3,0])
linear_extrude(height=textHeight+0.1)text("1", size=textSize*0.4, halign="center", valign="center",font=font );


  //translate([0,bottom_text_offset-5,0])
  //linear_extrude(height=textHeight)text("x100", size=textSize/2, halign="center", valign="center",font=font,$fn=80 );

  // Draw indication lines


  color([1,1,1])
  for(i=[0:N]){
      angle =  angle_start - (i * total_angle) / (N);
      

      
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
      linear_extrude(height=textHeight)text(str((i*label_increment)+label_start), size=textSize/2, halign="center", valign="center",font=font );
      
       
  }
  
  minor_ticks = (N*10);
  for(i=[0:minor_ticks]){
      angle =  angle_start - (i * total_angle) / (minor_ticks);;
        
    if(i%5==0){
            rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
      cube (size = [arm_lenght*0.7,arm_thickness*0.8,textHeight], center =true);
    } else{
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
      cube (size = [arm_lenght*0.5,arm_thickness*0.8,textHeight], center =true);
    }
  }


  // Battery face:
  /*
  N_bat = 5;
  angle_start_bat = -90-20;
  total_angle_bat=180-40;
  label_increment_bat = 20;
  label_start_bat = 0;
  bat_alert_angle = -140;
  warn_height=0.1;
  color([1,1,1])
  for(i=[0:N_bat]){
 
    
      angle =  angle_start_bat - (i * (total_angle_bat / (N_bat)));
      echo(angle);
     
      
    
       if( true){

          rotate( angle, [0, 0, 1])
       translate(v = [barRadius, 0, textHeight*0.5])
      cube (size = [arm_lenght,arm_thickness,textHeight], center =true);
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
        linear_extrude(height=textHeight)text(str((i*label_increment_bat)+label_start_bat), size=textSize/2, halign="center", valign="center",font=font );
       } else {

          rotate( angle, [0, 0, 1])
       translate(v = [barRadius, 0, (warn_height+textHeight)*0.5])
      cube (size = [arm_lenght,arm_thickness,textHeight+warn_height], center =true);
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
         linear_extrude(height=textHeight+warn_height)text(str((i*label_increment_bat)+label_start_bat), size=textSize/2, halign="center", valign="center",font=font );
       }
      
       
  }
  
  minor_ticks_bat = ((N_bat*8));
  for(i=[0:minor_ticks_bat]){
      angle =  angle_start_bat - (i * ( total_angle_bat / (minor_ticks_bat)));;
        
    if( (angle<bat_alert_angle)){
      if(i%4==0){
              rotate( angle, [0, 0, 1])
         translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
        cube (size = [arm_lenght*0.7,arm_thickness*0.8,textHeight], center =true);
      } else{
        rotate( angle, [0, 0, 1])
         translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
        cube (size = [arm_lenght*0.5,arm_thickness*0.8,textHeight], center =true);
      }}else{
        if(i%4==0){
              rotate( angle, [0, 0, 1])
         translate(v = [barRadius+arm_lenght*0.2, 0, (textHeight+warn_height)*0.5])
        cube (size = [arm_lenght*0.7,arm_thickness*0.8,textHeight+warn_height], center =true);
      } else{
        rotate( angle, [0, 0, 1])
         translate(v = [barRadius+arm_lenght*0.2, 0, (textHeight+warn_height)*0.5])
        cube (size = [arm_lenght*0.5,arm_thickness*0.8,textHeight+warn_height], center =true);
      
      }
      }
  }
  
  */

}
}
}



 hole_radius = 63.5/2;
module WINDOWFRAME(){
window_h = 0.5;
 difference(){
   minkowski(){
 hull(){

   cylinder(r=hole_radius,h=window_h);

    
    cylinder_radius = 5;
    cylinder_offset = radius+slack+wt+0.5*cylinder_radius;
    h=mount_cylinder_height;
      
    r = cylinder_offset;
  
    total_cylinders = 4;
    
    angle_offset = 45;
    x = [ for (a = [0 : total_cylinders-1]) r * sin(angle_offset + a * 360 / total_cylinders) ];
    y = [for (a = [0 : total_cylinders-1])  r * cos(angle_offset + a * 360 / total_cylinders) ];  
      
    //x = [-cylinder_offset*0.75,cylinder_offset,0,0];
    //y = [cylinder_offset*0.75,cylinder_offset,-cylinder_offset,cylinder_offset];
    
  

       for(i=[0:3]){
            translate([x[i],y[i],0])cylinder(r=3.5,h=window_h);

         
       }
        
     }
       rotate([0,-90,0]){
    difference(){
    sphere(r=1.5);
    translate([0,-1.5,-1.5])cube(3,4,4);
    }
  }}
        translate([0,0,-4])cylinder(r=hole_radius-2,h=10);
      translate([0,0,-2.5])MountCylinders(inner=1);
   }
 }

 
 


module FACE_TEMP(){
  
  label_start = -5;
label_increment = 5;
N= 10;

total_angle = 360-90;
angle_start = 90;


  color([0,0,0])
  translate([0,0, -insetDepth])difference(){
      cylinder(r=radius,h= insetDepth);
      translate([0,0, -insetDepth])cylinder(r=openingRadius,h=99);
      
      
      translate([-13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      translate([13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      
  }

  translate([-14,0,0]){
  translate([1,14,0])
  linear_extrude(height=textHeight)text("TEMP", size=textSize*0.75, halign="center", valign="center",font="Franklin Gothic");
  }

  translate([0,bottom_text_offset,0])
  linear_extrude(height=textHeight)text("°C", size=textSize/2, halign="center", valign="center",font=font );

  //translate([0,bottom_text_offset-5,0])
  //linear_extrude(height=textHeight)text("x100", size=textSize/2, halign="center", valign="center",font=font,$fn=80 );

  // Draw indication lines


  color([1,1,1])
  for(i=[0:N]){
      
      angle =  angle_start + 360 - (i * total_angle) / (N);
      
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius, 0, textHeight*0.5])
      cube (size = [arm_lenght,arm_thickness,textHeight], center =true);
      
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
      linear_extrude(height=textHeight)text(str((i*label_increment)+label_start), size=textSize/2, halign="center", valign="center",font=font );
      
       
  }

  for(i=[0:N*5]){
      angle =  angle_start + 360 - (i * total_angle) / (N*5);
        
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
      cube (size = [arm_lenght*0.5,arm_thickness*0.8,textHeight], center =true);
  }
}


module FACE_CO2(){
label_start = 4;
label_increment = 2;
N= 10;

total_angle = 360-90;
angle_start = 90;

  color([0,0,0])
  translate([0,0, -insetDepth])difference(){
      cylinder(r=radius,h= insetDepth);
      translate([0,0, -insetDepth])cylinder(r=openingRadius,h=99);

      
      translate([-13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      translate([13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      
  }

  translate([-14,0,0]){
  translate([0,15,0])
  linear_extrude(height=textHeight)text("CO", size=textSize, halign="center", valign="center",font="Franklin Gothic");
  translate([9,12,0])
  linear_extrude(height=textHeight)text("2", size=textSize/2, halign="center", valign="center",font="Franklin Gothic");
  }


  translate([0,bottom_text_offset,0])
  linear_extrude(height=textHeight)text("PPM x100", size=textSize/3, halign="center", valign="center",font=font );

  //translate([0,bottom_text_offset-5,0])
  //linear_extrude(height=textHeight)text("x100", size=textSize/2, halign="center", valign="center",font=font,$fn=80 );

  // Draw indication lines


  color([1,1,1])
  for(i=[0:N]){
      angle =  angle_start + 360 - (i * total_angle) / (N);
      
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius, 0, textHeight*0.5])
      cube (size = [arm_lenght,arm_thickness,textHeight], center =true);
      
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
      linear_extrude(height=textHeight)text(str((i*label_increment)+label_start), size=textSize/2, halign="center", valign="center",font=font );
      
       
  }
  
  minor_ticks = N*6;
  for(i=[0:minor_ticks]){
      angle =  angle_start + 360 - (i * total_angle) / (minor_ticks);
        
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
      cube (size = [arm_lenght*0.5,arm_thickness*0.8,textHeight], center =true);
  }
}



module FACE_GEN(){
label_start = 0;
label_increment = 1;
N= 10;

total_angle = 360-90;
angle_start = 90;
difference(){
union(){
  color([0,0,0])
  translate([0,0, -insetDepth])difference(){
      cylinder(r=radius,h= insetDepth);
      translate([0,0, -insetDepth])cylinder(r=openingRadius,h=99);

      
  }

  translate([-14,0,0]){
  translate([0,15,0])
  linear_extrude(height=textHeight)text("ADC", size=textSize*0.8, halign="center", valign="center",font="Franklin Gothic");


  }


  translate([0,bottom_text_offset,0])
  linear_extrude(height=textHeight)text("NORM", size=textSize/3, halign="center", valign="center",font=font );

  //translate([0,bottom_text_offset-5,0])
  //linear_extrude(height=textHeight)text("x100", size=textSize/2, halign="center", valign="center",font=font,$fn=80 );

  // Draw indication lines


  color([1,1,1])
  for(i=[0:N]){
      angle =  angle_start + 360 - (i * total_angle) / (N);
      
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius, 0, textHeight*0.5])
      cube (size = [arm_lenght,arm_thickness,textHeight], center =true);
      
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
      linear_extrude(height=textHeight)text(str((i*label_increment)+label_start), size=textSize/2, halign="center", valign="center",font=font );
      
       
  }
  
  minor_ticks = N*6;
  for(i=[0:minor_ticks]){
      angle =  angle_start + 360 - (i * total_angle) / (minor_ticks);
        
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
      cube (size = [arm_lenght*0.5,arm_thickness*0.8,textHeight], center =true);
  }
  
}
            wx = 35;
      wy = 32;
      wt = 2;
      xs = -wx*0.5-wt;
      ys = -6.5-wt-wy*0.5;
      xw = wx+2*wt;
      yw = wy+2*wt;
      side_offset = 3;
      cut_r = 1.3;
       
    translate([xs+side_offset,-ys-side_offset,-500])cylinder(r=cut_r,h=1000);
    translate([xs+side_offset,-(ys+yw-side_offset),-500])cylinder(r=cut_r,h=1000);
    translate([xs+xw-side_offset,-(ys+yw-side_offset),-500])cylinder(r=cut_r,h=1000);
    translate([xs+xw-side_offset,-ys-side_offset,-500])cylinder(r=cut_r,h=1000);
}
}
FACE_GEN();


module MountCylinders(inner=false){
    
    cylinder_radius = 5;
    cylinder_offset = radius+slack+wt+0.5*cylinder_radius;
    h=mount_cylinder_height;
      
    r = cylinder_offset;
  
    total_cylinders = 4;
    
    angle_offset = 45;
    x = [ for (a = [0 : total_cylinders-1]) r * sin(angle_offset + a * 360 / total_cylinders) ];
    y = [for (a = [0 : total_cylinders-1])  r * cos(angle_offset + a * 360 / total_cylinders) ];  
      
    //x = [-cylinder_offset*0.75,cylinder_offset,0,0];
    //y = [cylinder_offset*0.75,cylinder_offset,-cylinder_offset,cylinder_offset];
    
  
    if(inner){
       for(i=[0:3]){
            translate([x[i],y[i],-1])cylinder(r=m2_radius,h=h+2);
          translate([x[i],y[i],h-m2_head_depth])cylinder(r=m2_head_radius,h=h+2);
         
           translate([x[i],y[i],-1])cylinder(r=m2_nut_radius,h=m2_nut_depth+1);
         
       }
        
    }else{
      for(i=[0:3]){
        translate([x[i],y[i],0])cylinder(r=cylinder_radius,h=h);
      }
    }
    
    
}


module FACE_NOX(){
label_start = -2;
label_increment = 10;
N= 3;

barRadius = radius - 4;
  label_radius = barRadius - 8;


  arm_lenght=8;
  arm_thickness=1.2;
  arm_thickness_minor = 0.7;
  
  
total_angle = 360-90;
angle_start = 225;
          wx = 35;
      wy = 32;
      wt = 2;
      xs = -wx*0.5-wt;
      ys = -6.5-wt-wy*0.5;
      xw = wx+2*wt;
      yw = wy+2*wt;
      side_offset = 3;
      cut_r = 1.3;
       
  difference(){
    union(){
  color([0,0,0])
  translate([0,0, -insetDepth])difference(){
      cylinder(r=radius,h= insetDepth);
      translate([0,0, -insetDepth])cylinder(r=openingRadius,h=99);
      
      
      translate([-13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      translate([13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      
  }
  
  
  
  translate([0,-35,0]){
  translate([0,15,0])
  linear_extrude(height=textHeight)text("NO", size=textSize, halign="center", valign="center",font="Franklin Gothic");
  translate([9,12,0])
  linear_extrude(height=textHeight)text("X", size=textSize/2, halign="center", valign="center",font="Franklin Gothic Heavy");
  


  translate([0,8,0])
  linear_extrude(height=textHeight)text("PPM", size=textSize/3, halign="center", valign="center",font=font );
  }

  //translate([0,bottom_text_offset-5,0])
  //linear_extrude(height=textHeight)text("x100", size=textSize/2, halign="center", valign="center",font=font,$fn=80 );

  // Draw indication lines


  color([1,1,1])
  for(i=[0:N]){
      angle =  angle_start + 360 - (i * total_angle) / (N);
      
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius, 0, textHeight*0.5])
      cube (size = [arm_lenght,arm_thickness,textHeight], center =true);
      
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
      linear_extrude(height=textHeight)text(str((pow(label_increment,i+label_start))), size=textSize/2, halign="center", valign="center",font=font );
      
       
  }
  
  minor_ticks = N*9;
  
  //Log axis ticks
  for(mayor=[2:4]){
    mayor_angle_start =  angle_start + 360 - ((mayor-1) * total_angle) / (N);
    mayor_angle_end =  angle_start + 360 - (mayor * total_angle) / (N);
    for(minor=[0:9]){
      echo((mayor_angle_start-mayor_angle_end));
      angle = mayor_angle_start - (mayor_angle_start-mayor_angle_end)*(log((minor/10)));
      echo(angle);
       rotate( angle, [0, 0, 1])
       translate(v = [barRadius+(arm_lenght*0.1), 0, textHeight*0.5])
      cube (size = [arm_lenght*0.7,arm_thickness_minor,textHeight], center =true);
    }
   }
  
  /*
  for(i=[0:minor_ticks]){
    
      angle =  angle_start + 360 - (i * total_angle) / (minor_ticks);
       log()
    if(i%2==0){
            rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
      cube (size = [arm_lenght*0.7,arm_thickness*0.8,textHeight], center =true);
    } else{
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
      cube (size = [arm_lenght*0.5,arm_thickness*0.8,textHeight], center =true);
    }
  }*/
}

rotate([0,0,180])union(){
    translate([xs+side_offset,ys+side_offset,-500])cylinder(r=cut_r,h=1000);
    translate([xs+side_offset,ys+yw-side_offset,-500])cylinder(r=cut_r,h=1000);
    translate([xs+xw-side_offset,ys+yw-side_offset,-500])cylinder(r=cut_r,h=1000);
    translate([xs+xw-side_offset,ys+side_offset,-500])cylinder(r=cut_r,h=1000);
}
}
}


module FACE_DUST_LINEAR(){
label_start = 20;
label_increment = -2;
N= 10;

total_angle = 360-90;
angle_start = 180;
  difference(){
  rotate([0,0,180])
  difference(){
  union(){
  color([0,0,0])
  translate([0,0, -insetDepth])difference(){
      cylinder(r=radius,h= insetDepth);
      translate([0,0, -insetDepth])cylinder(r=openingRadius,h=99);
      
      
      translate([-13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      translate([13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      
  }

  translate([-15,0,0]){
  translate([0,15,0])
  linear_extrude(height=textHeight)text("PM", size=textSize, halign="center", valign="center",font="Franklin Gothic");
  translate([-6,8,0])
  linear_extrude(height=textHeight)text("2", size=textSize/2, halign="center", valign="center",font="Franklin Gothic Heavy");
    
    translate([4.5,8,0])
  linear_extrude(height=textHeight+0.2)text("10", size=textSize/2, halign="center", valign="center",font="Franklin Gothic Heavy");
    
  }


  translate([0,bottom_text_offset,0])
  linear_extrude(height=textHeight)text("µg/m3 x10", size=textSize/2.5, halign="center", valign="center",font=font );

  //translate([0,bottom_text_offset-5,0])
  //linear_extrude(height=textHeight)text("x100", size=textSize/2, halign="center", valign="center",font=font,$fn=80 );

  // Draw indication lines


  color([1,1,1])
  for(i=[0:N]){
      angle =  angle_start + (i * total_angle) / (N);
      
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius, 0, textHeight*0.5])
      cube (size = [arm_lenght,arm_thickness,textHeight], center =true);
      
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
      linear_extrude(height=textHeight)text(str((i*label_increment)+label_start), size=textSize/2, halign="center", valign="center",font=font );
      
       
  }
  
  minor_ticks = N*10;
  for(i=[0:minor_ticks]){
      angle =  angle_start + (i * total_angle) / (minor_ticks);;
        
    if(i%5==0){
            rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
      cube (size = [arm_lenght*0.7,arm_thickness*0.8,textHeight], center =true);
    } else{
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
      cube (size = [arm_lenght*0.5,arm_thickness*0.8,textHeight], center =true);
    }
  }
  
}
}
        wx = 35;
      wy = 32;
      wt = 2;
      xs = -wx*0.5-wt;
      ys = -6.5-wt-wy*0.5;
      xw = wx+2*wt;
      yw = wy+2*wt;
      side_offset = 3;
      cut_r = 1.3;
       
    translate([xs+side_offset,ys+side_offset,-500])cylinder(r=cut_r,h=1000);
    translate([xs+side_offset,ys+yw-side_offset,-500])cylinder(r=cut_r,h=1000);
    translate([xs+xw-side_offset,ys+yw-side_offset,-500])cylinder(r=cut_r,h=1000);
    translate([xs+xw-side_offset,ys+side_offset,-500])cylinder(r=cut_r,h=1000);
}
}



module FACE_DUST_LOG(){
label_start = 100;
label_increment = 10;
N= 10;

total_angle = 360-90;
angle_start = 270;
  difference(){
  union(){
  color([0,0,0])
  translate([0,0, -insetDepth])difference(){
      cylinder(r=radius,h= insetDepth);
      translate([0,0, -insetDepth])cylinder(r=openingRadius,h=99);
      
      
      translate([-13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      translate([13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      
  }

  translate([-15,0,0]){
  translate([0,15,0])
  linear_extrude(height=textHeight)text("PM", size=textSize, halign="center", valign="center",font="Franklin Gothic");
  translate([-9,8,0])
  linear_extrude(height=textHeight)text("2", size=textSize/2, halign="center", valign="center",font="Franklin Gothic Heavy");
    
    translate([0,8,0])
  linear_extrude(height=textHeight)text("10", size=textSize/2, halign="center", valign="center",font="Franklin Gothic Heavy");
    
  }


  translate([0,bottom_text_offset,0])
  linear_extrude(height=textHeight)text("µg/m3 x10", size=textSize/3, halign="center", valign="center",font=font );

  //translate([0,bottom_text_offset-5,0])
  //linear_extrude(height=textHeight)text("x100", size=textSize/2, halign="center", valign="center",font=font,$fn=80 );

  // Draw indication lines


  color([1,1,1])
  for(i=[0:N]){
      angle =  angle_start - (i * total_angle) / (N);
      
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius, 0, textHeight*0.5])
      cube (size = [arm_lenght,arm_thickness,textHeight], center =true);
      
      translate([cos(angle)*label_radius,sin(angle)*label_radius,0])
      linear_extrude(height=textHeight)text(str((i*label_increment)+label_start), size=textSize/2, halign="center", valign="center",font=font );
      
       
  }
  
  minor_ticks = N*10;
  for(i=[0:minor_ticks]){
      angle =  angle_start - (i * total_angle) / (minor_ticks);;
        
    if(i%5==0){
            rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
      cube (size = [arm_lenght*0.7,arm_thickness*0.8,textHeight], center =true);
    } else{
      rotate( angle, [0, 0, 1])
       translate(v = [barRadius+arm_lenght*0.2, 0, textHeight*0.5])
      cube (size = [arm_lenght*0.5,arm_thickness*0.8,textHeight], center =true);
    }
  }
  
}
     x40offset = -12.5;
      translate([0,0,-0.1]){
   translate([-13,x40offset, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
    translate([13,x40offset, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      
       translate([0,0,4-8]){
      translate([-13,x40offset, -insetDepth])cylinder(r=m2_nut_radius,h=10);
    translate([13,x40offset, -insetDepth])cylinder(r=m2_nut_radius,h=10);
       }}
}
}



module MountCylinders(inner=false){
    
    cylinder_radius = 5;
    cylinder_offset = radius+slack+wt+0.5*cylinder_radius;
    h=mount_cylinder_height;
      
    r = cylinder_offset;
  
    total_cylinders = 4;
    
    angle_offset = 45;
    x = [ for (a = [0 : total_cylinders-1]) r * sin(angle_offset + a * 360 / total_cylinders) ];
    y = [for (a = [0 : total_cylinders-1])  r * cos(angle_offset + a * 360 / total_cylinders) ];  
      
    //x = [-cylinder_offset*0.75,cylinder_offset,0,0];
    //y = [cylinder_offset*0.75,cylinder_offset,-cylinder_offset,cylinder_offset];
    
  
    if(inner){
       for(i=[0:3]){
            translate([x[i],y[i],-1])cylinder(r=m2_radius,h=h+2);
          translate([x[i],y[i],h-m2_head_depth])cylinder(r=m2_head_radius,h=h+2);
         
           translate([x[i],y[i],-1])cylinder(r=m2_nut_radius,h=m2_nut_depth+1);
         
       }
        
    }else{
      for(i=[0:3]){
        translate([x[i],y[i],0])cylinder(r=cylinder_radius,h=h);
      }
    }
    
    
}


module BASE(cut40=false){
  difference(){
union(){
difference(){
    translate([0,0,0]){
        cylinder(r=radius+slack+wt,h=grabberH);
    }
   
  
    translate([0,0,0])
     
          SwitecX25_168_CUT(enableScrews=0,screw_diam=m2_radius);
      
       translate([0,0,15])
       
          SwitecX25_168_CUT(enableScrews=0,screw_diam=m2_head_radius*2);
    translate([0,0,4.5])
      scale([HOLE_K, HOLE_K, HOLE_K]) {
          SwitecX25_168();
      }
    
    
  
      
            
//Extra holes for X40
      x40offset = -12.5;
      translate([0,0,-0.1]){
   translate([-13,x40offset, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
    translate([13,x40offset, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      
       translate([0,0,4-8]){
      translate([-13,x40offset, -insetDepth])cylinder(r=m2_nut_radius,h=10);
    translate([13,x40offset, -insetDepth])cylinder(r=m2_nut_radius,h=10);
       }
       


      
    // Hole for engine mount  
   translate([-13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
    translate([13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
      
       translate([0,0,4-8]){
      translate([-13,0, -insetDepth])cylinder(r=m2_nut_radius,h=10);
    translate([13,0, -insetDepth])cylinder(r=m2_nut_radius,h=10);
    }}
    
    
    }
    

m_rad = 1;
difference(){
    translate([0,0,m_rad])
    minkowski(){
        difference(){
          
            union(){
                // Mounting cylinders:
              hull(){
                MountCylinders();
              }
    
                
                
            cylinder(r=radius+slack+wt-m_rad,h=20+increase_glass_pos);
            }
    rotate([10,0,0])
    translate([-0.5*f,-0.5*f,20+ increase_glass_pos])cube([ f,f,50]);        
        }
        sphere(r=m_rad);
    }
    
    cylinder(r=radius+slack,h=40);
    
    translate([0,0,8.5])
    //rotate([90,0,0])cylinder(r=1,h=90);
    
    
    MountCylinders(inner=1);
}

}
    MountCylinders(inner=1);
translate([-500,32.5,-500])cube([1000,1000,500+11.5]);
//rotate([-10,0,0])translate([-20,32.5-1.6,16])cube([40,100,6]);
// translate([0,0,0]){MountCylinders(inner=1);};
  // Cut away all smooth sides:
wx = 35;
if(cut40){
  translate([-wx*0.5,-16.5,-500])cube([wx,20,500+4.5]);
}
SERVO_CLAMP(cut=1);
translate([0,0,500+grabberH-0.3])SERVO_CLAMP(cut=1,cut_r=3);
}



}


module SERVO_CLAMP(cut=false,cut_r=1.2){
        wx = 35;
      wy = 32;
      wt = 2;
      xs = -wx*0.5-wt;
      ys = -6.5-wt-wy*0.5;
      xw = wx+2*wt;
      yw = wy+2*wt;
      side_offset = 3;
  if(cut){
        
    translate([xs+side_offset,ys+side_offset,-500])cylinder(r=cut_r,h=1000);
    translate([xs+side_offset,ys+yw-side_offset,-500])cylinder(r=cut_r,h=1000);
    translate([xs+xw-side_offset,ys+yw-side_offset,-500])cylinder(r=cut_r,h=1000);
    translate([xs+xw-side_offset,ys+side_offset,-500])cylinder(r=cut_r,h=1000);
    
  } else {
  difference(){
    intersection(){
      BASE();

      translate([xs,ys,-500])cube([xw,yw,500+4.5]);
    }
    
    translate([xs+side_offset,ys+side_offset,-20])cylinder(r=cut_r,h=1000);
    translate([xs+side_offset,ys+yw-side_offset,-20])cylinder(r=cut_r,h=1000);
    translate([xs+xw-side_offset,ys+yw-side_offset,-20])cylinder(r=cut_r,h=1000);
    translate([xs+xw-side_offset,ys+side_offset,-20])cylinder(r=cut_r,h=1000);
}
  
  clamp_h = 19+wt; // Distance from top to botoom of stepper
  m_clamp_xs = 10;
  translate([-m_clamp_xs*0.5,ys,-clamp_h+4.5])cube([m_clamp_xs,wt,clamp_h]);
  translate([-m_clamp_xs*0.5,ys+yw-wt,-clamp_h+4.5])cube([m_clamp_xs,wt,clamp_h]);
  translate([-m_clamp_xs*0.5,ys,-clamp_h+4.5])cube([m_clamp_xs,wy+2*wt,wt]);
  }
}



module BASE_SERVO(){

difference(){
union(){
difference(){
    translate([0,0,0]){
        cylinder(r=radius+slack+wt,h=grabberH);
    }
    //SG90 circle
    translate([0,0,0]){
        cylinder(r=6-0.1,h=grabberH);
    }
    
    offset_sg = 6.5;
    translate([0,offset_sg,0]){
        cylinder(r=3,h=grabberH);
    }
    translate([-6.0/2,offset_sg -6.0,0]){
        cube([6.0,6.0,grabberH]);
    }
    
    offset_sg2 = -6.5;
    translate([0,offset_sg2,0]){
        cylinder(r=3,h=grabberH);
    }
    translate([-6.0/2,offset_sg2,0]){
        cube([6.0,6.0,grabberH+1]);
    }
    
    
   translate([-13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
    translate([13,0, -insetDepth])cylinder(r=face_mount_screw_radius,h=99);
    

    
}




m_rad = 1;
difference(){
    translate([0,0,m_rad])
    minkowski(){
        difference(){
          
            union(){
                // Mounting cylinders:
              hull(){
                MountCylinders();
              }
    
                
                
            cylinder(r=radius+slack+wt-m_rad,h=20);
            }
    rotate([10,0,0])
    translate([-0.5*f,-0.5*f,20])cube([ f,f,50]);        
        }
        sphere(r=m_rad);
    }
    
    cylinder(r=radius+slack,h=40);
    
    translate([0,0,8.5])
    rotate([90,0,0])cylinder(r=1,h=90);
    
    

}
 }   
}
}

    
module GAUGE(){

    hole_cover=0.5;
  gauge_height = 2;
  hole_radius = 0.55;
  knob_h = 5;
  needle_z_offset = 6-3;
  small_width = 0.4;
  mink_rad = 1;
  difference(){
  union(){
 color([1,1,1])
    difference(){
      
        minkowski(){
          cylinder(r=6-mink_rad,h=knob_h-mink_rad);
          sphere(r=mink_rad);
        }
        //cylinder(r=6,h=knob_h);
        translate([0,0,-knob_h])cylinder(r=20,h=knob_h);
        cylinder(r=hole_radius,h=knob_h-hole_cover);
        }
    
    
        difference(){
    translate([-1,0,needle_z_offset]){
    difference(){
        cube([2,radius-1,gauge_height]);
        translate([-1,0,2])rotate([-2,0,0])cube([4,radius,gauge_height]);
        
        translate([1.5,radius-5,-1])cube([2,radius-1,5]);
        translate([-1.5,radius-5,-1])cube([2,radius-1,5]);
        
    }}
    
   
    
    //cylinder(r=hole_radius,h=knob_h-hole_cover);
    
}

}
cylinder(r=hole_radius,h=knob_h+10);
}
 color([0,0,0])
difference(){
  
  translate([-small_width*0.5,0,needle_z_offset]){
    difference(){
        cube([small_width,radius-9,gauge_height-0.4]);
        translate([-1,0,2.2])rotate([0,0,0])cube([4,radius,gauge_height]);

       
    }}
    // cylinder(r=hole_radius,h=knob_h-hole_cover);
     cylinder(r=hole_radius,h=knob_h+1.5);
    
    }
    
}


module GAUGE(){

    hole_cover=0.5;
  gauge_height = 2;
  hole_radius = 0.55;
  knob_h = 5;
  needle_z_offset = 6-3;
  small_width = 0.4;
  mink_rad = 1;
  difference(){
  union(){
 color([1,1,1])
    difference(){
      
        minkowski(){
          cylinder(r=6-mink_rad,h=knob_h-mink_rad);
          sphere(r=mink_rad);
        }
        //cylinder(r=6,h=knob_h);
        translate([0,0,-knob_h])cylinder(r=20,h=knob_h);
        cylinder(r=hole_radius,h=knob_h-hole_cover);
        }
    
    
        difference(){
    translate([-1,0,needle_z_offset]){
    difference(){
        cube([2,radius-1,gauge_height]);
        translate([-1,0,2])rotate([-2,0,0])cube([4,radius,gauge_height]);
        
        translate([1.5,radius-5,-1])cube([2,radius-1,5]);
        translate([-1.5,radius-5,-1])cube([2,radius-1,5]);
        
    }}
    
   
    
    //cylinder(r=hole_radius,h=knob_h-hole_cover);
    
}

}
cylinder(r=hole_radius,h=knob_h+10);
}
 color([0,0,0])
difference(){
  
  translate([-small_width*0.5,0,needle_z_offset]){
    difference(){
        cube([small_width,radius-9,gauge_height-0.4]);
        translate([-1,0,2.2])rotate([0,0,0])cube([4,radius,gauge_height]);

       
    }}
    // cylinder(r=hole_radius,h=knob_h-hole_cover);
     cylinder(r=hole_radius,h=knob_h+1.5);
    
    }
    
}


module GAUGE_TOP(){

    hole_cover=0.5;
  gauge_height = 2;
  hole_radius = 0.55;
  knob_h = 2;
  needle_z_offset = 0;
  small_width = 0.4;
  mink_rad = 1;
  difference(){
  union(){
    translate([0,0,-4])cylinder(r=1.8,h=4);
 color([1,1,1])
    difference(){
      
        minkowski(){
          cylinder(r=6-mink_rad,h=knob_h-mink_rad);
          sphere(r=mink_rad);
        }
        //cylinder(r=6,h=knob_h);
        translate([0,0,-knob_h])cylinder(r=20,h=knob_h);
        cylinder(r=hole_radius,h=knob_h-hole_cover);
        }
    
    
        difference(){
    translate([-1,0,needle_z_offset]){
    difference(){
        cube([2,radius-1,gauge_height]);
        translate([-1,0,2])rotate([-2,0,0])cube([4,radius,gauge_height]);
        
        translate([1.5,radius-5,-1])cube([2,radius-1,5]);
        translate([-1.5,radius-5,-1])cube([2,radius-1,5]);
        
    }}
    
   
    
    
    
}

}
translate([0,0,-50])
cylinder(r=hole_radius,h=100);
}
 color([0,0,0])
difference(){
  
  translate([-small_width*0.5,0,needle_z_offset]){
    difference(){
        cube([small_width,radius-9,gauge_height-0.4]);
        translate([-1,0,2.2])rotate([0,0,0])cube([4,radius,gauge_height]);

       
    }}
    // cylinder(r=hole_radius,h=knob_h-hole_cover);
     cylinder(r=hole_radius,h=knob_h+1.5);
    
    }
    
}



module GAUGE_TOP_WIDE(){

    hole_cover=0.5;
  gauge_height = 2;
  hole_radius = 0.55;
  knob_h = 2;
  needle_z_offset = 0;

  mink_rad = 1;
  difference(){
  union(){
    translate([0,0,-4])cylinder(r=1.8,h=4);
 color([1,1,1])
    difference(){
      
        minkowski(){
          cylinder(r=6-mink_rad,h=knob_h-mink_rad);
          sphere(r=mink_rad);
        }
        //cylinder(r=6,h=knob_h);
        translate([0,0,-knob_h])cylinder(r=20,h=knob_h);
        cylinder(r=hole_radius,h=knob_h-hole_cover);
        }
    
    
        difference(){
    translate([-2,0,needle_z_offset]){
    difference(){
        cube([4,radius-1,gauge_height]);
        translate([-1,0,2])rotate([-2,0,0])cube([8,radius,gauge_height]);
        
 
        
    }}
    
}

}
translate([0,0,-50])
cylinder(r=hole_radius,h=100);
}

}


module GAUGE_TOP_WIDE_SINGLE(){

    hole_cover=0.5;
  gauge_height = 2;
  hole_radius = 0.55;
  knob_h = 6;
  needle_z_offset = 2.5;

  mink_rad = 1;
  difference(){
  union(){
    
 color([1,1,1])
    difference(){
      
        minkowski(){
          cylinder(r=6-mink_rad,h=knob_h-mink_rad);
          sphere(r=mink_rad);
        }
        //cylinder(r=6,h=knob_h);
        translate([0,0,-knob_h])cylinder(r=20,h=knob_h);
        cylinder(r=hole_radius,h=knob_h-hole_cover);
        }
    
    
        difference(){
    translate([-2,0,needle_z_offset]){
    difference(){
        cube([4,radius-1,gauge_height]);
        translate([-1,0,2])rotate([-2,0,0])cube([8,radius,gauge_height]);
        
 
        
    }}
    
}

}
translate([0,0,-50])
cylinder(r=hole_radius,h=100);
}

}



module GAUGE_WIDE(){

    hole_cover=0.5;
  gauge_height = 1;
  hole_radius = 3.015/2;
  hole_radius_top =  2.95/2;
  knob_h = 6;
  extra_height= 2;
  needle_z_offset = knob_h-gauge_height;
  small_width = 0.1;
  mink_rad = 1;
  a_off = 4;
  a_angle=5;
  a_y_off = -30;
  
  w = 3.2;
  difference(){
  union(){
 color([1,1,1])
    difference(){
      

          cylinder(r1=3.5,r2=4,h=knob_h);
 
        //cylinder(r=6,h=knob_h);
        translate([0,0,-knob_h])cylinder(r=20,h=knob_h);
        cylinder(r=hole_radius,r2=hole_radius_top,h=knob_h+0.01);
        }
    
    
        difference(){
   
    difference(){
       translate([-w*0.5,0,needle_z_offset+extra_height]){
        cube([w,radius-1,gauge_height]);
       }
       translate([-1,0,needle_z_offset+extra_height]){
        translate([-0.5*w,0,w])rotate([-w,0,0])cube([w*2,radius,gauge_height]);
        
        rotate([0,0,a_angle])translate([a_off,radius+a_y_off,-1])cube([2,radius-1,5]);
        rotate([0,0,-a_angle])translate([-a_off,radius+a_y_off,-1])cube([2,radius-1,5]);
       }
       
       translate([0,0,knob_h])
         cylinder(r=3,h=extra_height+1);
       
    }
    
   
    
    //cylinder(r=hole_radius,h=knob_h-hole_cover);
    
}

}
cylinder(r=hole_radius,r2=hole_radius_top,h=knob_h+0.01);
}

    difference(){
        translate([0,0,knob_h])
         cylinder(r=4,h=extra_height);
      translate([0,0,knob_h])
         cylinder(r=3,h=extra_height+1);
    }
}



module BODY(){
  difference(){
    translate([0,0,-7])BASE();
    GLASS();
    LIGHTRING(bounding_box=1);
}
}

module TOP(){
  difference(){
    BODY();

    //glass_offset_z + glass_thickness
    
    translate([-500,-500,-1000])cube([1000,1000,1000+glass_offset_z+glass_thickness]);
  }
}

module GLASS_HOLDER(){
  difference(){
    BODY();
    //Everything above:
      translate([-500,-500,glass_offset_z+glass_thickness])cube([1000,1000,1000]);
    
    translate([-500,-500,-1000])cube([1000,1000,1000+glass_offset_z-(glass_offset_z-ring_thickness)]);
  }
}

module BOTTOM(){
  difference(){
    BODY();
    //Everything above:
      translate([-500,-500,ring_thickness])cube([1000,1000,1000]);

  }
}




module SingleContainer(){
  containment_width = 70;
  bottom_wall_thickness = 2;
  difference(){

      translate([-containment_width*0.5,-containment_width*0.5,0])
    
      minkowski(){
        sphere(r=0.5);
        cube([containment_width,containment_width,10]);
      }
       translate([0,0, -50])cylinder(r=radius,h=99);
    
    minkowski(){
      sphere(r=0.05);
      hull(){
      translate([0,0,7+bottom_wall_thickness])BOTTOM();
      }
      }
    MountCylinders(inner=1);
  }
}

module DoubleContainer(){
  containment_width = 145;
  containment_height=70;
  bottom_wall_thickness = 2;
  x_off = 35;
  z_space = 5; //Distance between frame and meters
  translate([0,0,8+z_space]){
    difference(){

        translate([-containment_width*0.5,-containment_height*0.5,0])
      
        minkowski(){
          sphere(r=1.5);
          cube([containment_width,containment_height,6]);
        }
         translate([-x_off,0, -50])cylinder(r=radius,h=99);
        translate([x_off,0, -50])cylinder(r=radius,h=99);
      
      minkowski(){
        sphere(r=0.05);
        hull(){
        translate([-x_off,0,6+bottom_wall_thickness])BOTTOM();
        }
        }
       minkowski(){
        sphere(r=0.05);
        hull(){
        translate([x_off,0,6+bottom_wall_thickness])BOTTOM();
        }
        }
      translate([-x_off,0,-bottom_wall_thickness])MountCylinders(inner=1);
        translate([x_off,0,-bottom_wall_thickness])MountCylinders(inner=1);
    }
  }
  
}

module Encaps(){
add_z = -10.5; 
add_y = 35; // Extra instrument spacing
add_y_z = 2;//(35-28) + add_z; // Height of extra space
init_y = -57 ;
increment = 69;
M=3;

containment_height=70;
containment_angle = 4;
// Calculate box len:
MINKFN = 10;
blen = cos(containment_angle)*(containment_height);

difference(){
union(){
difference(){
  
     minkowski(){
            sphere(r=1.5, $fn=MINKFN);
       union(){
          translate([-145*0.5, init_y-0.5*containment_height-1.5,-add_z])cube([145, (blen-0.3)*3,16+add_z]);
         
         translate([-145*0.5, init_y-0.5*containment_height-1.5-add_y,-add_z])cube([145, (blen-0.3)*3,add_y_z]);
         
       }
   }
   
   
   
   inset = 4;
   minkowski(){
            sphere(r=1.5, $fn=MINKFN);
     union(){
          translate([-145*0.5+0.5*inset, init_y-0.5*containment_height-1.5+0.5*inset,-100])cube([145-inset,3*blen-inset ,1000]);
          
     translate([-145*0.5+0.5*inset, init_y-0.5*containment_height-1.5+0.5*inset-add_y,-inset-add_z])cube([145-inset,3*blen-inset ,add_y_z]);
     
     }
   }
   }

for(i=[0:M-1]){
  translate([0,init_y+i*increment,0])rotate([containment_angle,0,0])DoubleContainer();
}
}

translate([-20,-112,-500])cylinder(r=12/2,h=1000);
translate([20,-112,-500])cylinder(r=12/2,h=1000);
translate([-500,-500,-1000])cube([1000,1000,1010]);

translate([0,-5,0])FrameCutter();
translate([0,-15,0])FrameCutter();
translate([0,5,0])FrameCutter();

}
}

module EncapsHull(){
  minkowski(){


  hull() {
    Encaps();
  }
  cylinder(r=0.12);
}
}


module Encaps_MIDDLE(){
  MINKFN = 10;
   frame_y_offset = -8;
add_z = -10.5; 
add_y = 35; // Extra instrument spacing
add_y_z = 2;//(35-28) + add_z; // Height of extra space
init_y = -57 ;
increment = 69;
M=3;

containment_height=70;
containment_angle = 4;
// Calculate box len:

blen = cos(containment_angle)*(containment_height);
h = 130;
z_offset = 9;
difference(){
union(){
difference(){
  
     minkowski(){
            sphere(r=2.5, $fn=MINKFN);
          translate([-145*0.5, init_y-0.5*containment_height-1.5-add_y,-h+z_offset])cube([145, add_y+(blen-0.3)*3,h]);

   }
   
   
   
   inset = 4;
   minkowski(){
            sphere(r=2, $fn=MINKFN);

    /* This includes a bottom:*/
          translate([-145*0.5+inset*0.5, init_y-0.5*containment_height-1.5-add_y+inset*0.5,-h+9])cube([145-inset, add_y+(blen-0.3)*3-inset,h]);
     /*
     translate([-145*0.5+inset*0.5, init_y-0.5*containment_height-1.5-add_y+inset*0.5,-h-10])cube([145-inset, add_y+(blen-0.3)*3-inset,h*2]);*/
          
     
   }
   }

 }
  

 EncapsHull();
 for(i=[-3:3]){
 translate([i*17,frame_y_offset,init_offset_frame_z-40])rotate([0,90,0])FrameHoleCutter();
   
 }
  for(i=[-4:4]){

    translate([i*17,frame_y_offset+50,init_offset_frame_z-40])rotate([90,0,90])FrameHoleCutter();
   
 }
 
 
 translate([0,-500,-10])rotate([0,90,90])cylinder(r=1.5,h=1000);
 
 // Create three holes for the glass covers
 hole_radius = 63.5/2;
 for(hole_index=[-1:1]){
 translate([-500,hole_index*(hole_radius*2+10)-6,-h*0.5+z_offset])rotate([90,0,90])cylinder(r=hole_radius,h=1000);
   
   translate([40,hole_index*(hole_radius*2+10)-6,-h*0.5+z_offset])rotate([90,0,90])
   MountCylinders(inner=true);
   translate([-110,hole_index*(hole_radius*2+10)-6,-h*0.5+z_offset])rotate([90,0,90])
   MountCylinders(inner=true);
   
 }
 
 
}

init_offset_frame_z = -15/2-20;

translate([52,frame_y_offset,init_offset_frame_z-40])rotate([0,90,0])Frame();
  

}
module EncapsMiddleHalve(){
  // Bracket for bottom:
  frame_y_offset = -8;
  init_offset_frame_z = -15/2-20;

  x_size = 117;
  cw = 28;
  yoff = 2.5;
  cl = 245.5;
  ch= 30;
  inset_wt = 2; 
  difference(){
    translate([45-x_size,-130.7+yoff,-122.8])cube([cw+x_size,cl-yoff,ch]);
    translate([45-1-x_size,-130.7+yoff+inset_wt,-122.8+inset_wt])    cube([cw+1+x_size,cl-yoff-inset_wt*2,ch]);
        for(i=[-4:4]){

          translate([i*17,frame_y_offset+50,init_offset_frame_z-40])rotate([90,0,90])FrameHoleCutter();
         
       }
            for(i=[-3:3]){
     translate([i*17,frame_y_offset,init_offset_frame_z-40])rotate([0,90,0])FrameHoleCutter();
       
   }
   
    Encaps_MIDDLE();

  }



difference(){
  Encaps_MIDDLE();
   //translate([-45,-500,-500])cube([1000,1000,1000]);
  translate([-45,-500,-500])cube([90,1000,1000]);
}
 }
//Encaps();

module SLICE(top=10, bottom=-10){
   difference(){
    BODY();
     translate([-500,-500,top])cube([1000,1000,1000]);
     translate([-500,-500,-1000])cube([1000,1000,1000+bottom]);
   }
}

module BOTTOM_SECOND(){
  difference(){
    BODY();
    //Everything above:
      translate([-500,-500,glass_offset_z])cube([1000,1000,1000]);
    
          translate([-500,-500,ring_thickness])cube([1000,1000,1000]);

  }
}

module BOTTOM_FIRST(){
    SLICE(-2.5,-20);
}

s = -1.5;
module BOTTOM_SECOND(){
    SLICE(s,-2.5);
}

module BOTTOM_THIRD(){
    SLICE(ring_thickness,s);
}

//BASE();
//GLASS();

//translate([0,0,10.5])GAUGE_TOP();


//TOP();
//GLASS_HOLDER();
//BOTTOM_THIRD();
//BOTTOM_SECOND();
//BOTTOM_FIRST();

