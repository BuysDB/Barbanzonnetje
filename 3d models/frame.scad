$fn = 20;
minkradius = 1.5;

x_dim = 101-1;
z_dim = 15;
y_dim=10;

    
side_dim = 2.5 - minkradius;

l = 225 -minkradius*2;
hole_y_offset  = 5;
hole_x_offset  = 5;
front_x_offset = 10;
h_dist = 35;

module Frame(){

    difference(){
        translate([-x_dim*0.5,-l*0.5,-z_dim*0.5]){ //
            difference(){
            minkowski(){
                difference(){
                    union(){
                        cube([x_dim, y_dim, z_dim]);
                        cube([side_dim, l, z_dim]);
                        
                        translate([0,l-y_dim,0])cube([x_dim, y_dim, z_dim]);
                        translate([x_dim-side_dim,0,0])cube([side_dim, l, z_dim]);
                       }
                        
                    translate([front_x_offset,side_dim,0])cube([x_dim-front_x_offset*2, y_dim, z_dim]);
                    
                     translate([front_x_offset,l-(y_dim),0])cube([x_dim-front_x_offset*2, y_dim-side_dim, z_dim]);
                    
                   }
                   cylinder(h=0.0001,r=minkradius);
                   
               }
                   
                  translate([hole_x_offset,hole_y_offset,-1])cylinder(r=2.2,h=100);
                  translate([x_dim-hole_x_offset,hole_y_offset,-1])cylinder(r=2.2,h=100);
                  translate([hole_x_offset,l-hole_y_offset,-1])cylinder(r=2.2,h=100);
                  translate([x_dim-hole_x_offset,l-hole_y_offset,-1])cylinder(r=2.2,h=100);
                
                
                
            }
        }
        
        translate([0,-l,0])rotate([-90,0,0])cylinder(h=900,r=1.6);
        translate([h_dist,-l,0])rotate([-90,0,0])cylinder(h=900,r=1.6);
        translate([-h_dist,-l,0])rotate([-90,0,0])cylinder(h=900,r=1.6);
        
        //translate([0,-l,0])rotate([-90,0,90])cylinder(h=900,r=1.6);
        //translate([h_dist,-l,0])rotate([-90,0,90])cylinder(h=900,r=1.6);
        translate([x_dim,0,0])rotate([0,-90,0])cylinder(h=900,r=1.6);
        translate([x_dim,h_dist,0])rotate([0,-90,0])cylinder(h=900,r=1.6);
        translate([x_dim,-h_dist,0])rotate([0,-90,0])cylinder(h=900,r=1.6);
        translate([x_dim,2*h_dist,0])rotate([0,-90,0])cylinder(h=900,r=1.6);
        translate([x_dim,-2*h_dist,0])rotate([0,-90,0])cylinder(h=900,r=1.6);
        
    }
}

module Plate3(){
slack=0.15;
x_slack = 1.5;
ww = 50;
bar_width = ww+h_dist;
bar_th = 3;
bar_wt = ww/2;
x_off = -x_dim*0.5+(side_dim+minkradius);
y_off = -8; //-bar_width*0.5;
difference(){
    union(){
 translate([x_off,y_off,-z_dim*0.5]){
cube([x_dim-(side_dim+minkradius)*2 - x_slack,bar_width,bar_th]);
 }
 translate([x_off,y_off,-z_dim*0.5]){
cube([bar_th-x_slack,bar_width,z_dim]);
translate([x_dim-(side_dim+minkradius)*2-bar_th,0,0])cube([bar_th-x_slack,bar_width,z_dim]);
 }}
     translate([x_dim,0,0])rotate([0,-90,0])cylinder(h=900,r=1.6);
    translate([x_dim,h_dist,0])rotate([0,-90,0])cylinder(h=900,r=1.6);
    translate([x_dim,-h_dist,0])rotate([0,-90,0])cylinder(h=900,r=1.6);
    translate([x_dim,2*h_dist,0])rotate([0,-90,0])cylinder(h=900,r=1.6);
    translate([x_dim,-2*h_dist,0])rotate([0,-90,0])cylinder(h=900,r=1.6);
   
 translate([x_off+bar_wt,y_off+bar_wt,-z_dim*0.5]){
 cube([
     x_dim-(side_dim+minkradius)*2-2*bar_wt - x_slack,
     bar_width-bar_wt*2,
     bar_th]);
 }
 
 }}
 
 
 module Plate5(){
slack=0.15;
x_slack = 1.0;
ww = 160;
bar_width = ww+h_dist;
bar_th = 3;
bar_wt = ww/2;
x_off = -x_dim*0.5+(side_dim+minkradius);
y_off = -bar_width*0.5; //-bar_width*0.5;

cutout_x_dim = 35;
cutout_y_dim = 20;

translate([0.5*x_slack,0,0]){
difference(){
    union(){
 translate([x_off,y_off,-z_dim*0.5]){
cube([x_dim-(side_dim+minkradius)*2 - x_slack,bar_width,bar_th]);
 }
 translate([x_off,y_off,-z_dim*0.5]){
cube([bar_th-x_slack,bar_width,z_dim]);
translate([x_dim-(side_dim+minkradius)*2-bar_th,0,0])cube([bar_th-x_slack,bar_width,z_dim]);
 }}
     translate([x_dim,0,0])rotate([0,-90,0])cylinder(h=900,r=1.6);
    translate([x_dim,h_dist,0])rotate([0,-90,0])cylinder(h=900,r=1.6);
    translate([x_dim,-h_dist,0])rotate([0,-90,0])cylinder(h=900,r=1.6);
    translate([x_dim,2*h_dist,0])rotate([0,-90,0])cylinder(h=900,r=1.6);
    translate([x_dim,-2*h_dist,0])rotate([0,-90,0])cylinder(h=900,r=1.6);
   
 for(h = [-h_dist*2: h_dist : h_dist*2]){
 translate([-cutout_x_dim*0.5 ,-cutout_y_dim*0.5 + h,-bar_th*3]){
 cube([
     cutout_x_dim,
     cutout_y_dim,
     bar_th*3]);
 }
 }
 }}
}


first_layer_height = 35;
second_layer_height = 35;
second_layer_start = first_layer_height;
third_layer_height = 35;
third_layer_start = second_layer_start+second_layer_height;
fourth_layer_height = 35;
fourth_layer_start = third_layer_start+third_layer_height; 
 
 /*
Frame();
 Plate5();
translate([0,0,second_layer_start])Frame();
 translate([0,0,third_layer_start])Frame();
translate([0,0,fourth_layer_start])Frame();
*/



vertical_wall_thickness= 4;
vertical_hole_offset = 7;
vertical_hole_count = 111;
vertical_height = 120;

inset = 10;
outset = 10;
vertical_plate_x_dim = h_dist * 2 + outset;
vertical_plate_inset_x_dim = h_dist * 2 - inset;
vertical_plate_inset_y_dim =vertical_height - 2*inset;

total_y_offset = -l*0.5 - y_dim + 2*minkradius;


difference(){
    
    minkowski(){
    //translate([-vertical_plate_x_dim*0.5,total_y_offset-minkradius,-z_dim*0.5])cube([vertical_plate_x_dim,vertical_wall_thickness,vertical_height]);
        translate([-vertical_plate_x_dim*0.5 + minkradius,total_y_offset+minkradius,-z_dim*0.5+minkradius])cube([vertical_plate_x_dim-minkradius*2,vertical_wall_thickness,vertical_height-minkradius*2]);
        sphere(r=minkradius);
        
    }
    translate([-vertical_plate_x_dim*0.5,total_y_offset+vertical_wall_thickness,-z_dim*0.5])cube([vertical_plate_x_dim,vertical_wall_thickness,vertical_height]);
    
    translate([-vertical_plate_inset_x_dim*0.5,-l*0.5 - y_dim + 2*minkradius,-z_dim*0.5 + inset])cube([vertical_plate_inset_x_dim,vertical_wall_thickness,vertical_plate_inset_y_dim]);
    
 
screw_top_radius =  6.5/2;
for(z_offset=[0:vertical_hole_offset:vertical_hole_count]){


    translate([0,0,z_offset]){
     //                   translate([0,-l,0])rotate([-90,0,0])
cylinder(h=900,r=1.6);
        translate([0,-l,0])rotate([-90,0,0])cylinder(h=900,r=1.6);
        
        translate([h_dist,-l,0])rotate([-90,0,0])cylinder(h=900,r=1.6);
        translate([-h_dist,-l,0])rotate([-90,0,0])cylinder(h=900,r=1.6);
    }
    
        translate([0,0,z_offset]){
        
             translate([0,total_y_offset,0])rotate([-90,0,0])cylinder(h=2,r=screw_top_radius);
            
        translate([h_dist,total_y_offset,0])rotate([-90,0,0])cylinder(h=2,r=screw_top_radius);
        translate([-h_dist,total_y_offset,0])rotate([-90,0,0])cylinder(h=2,r=screw_top_radius);
    }
    
}
}
   