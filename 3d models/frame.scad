$fn = 20;
minkradius = 1.5;

x_dim = 101;
z_dim = 15;
y_dim=10;

    
side_dim = 2.5 - minkradius;

l = 225 ;
hole_y_offset  = 5;
hole_x_offset  = 5;
front_x_offset = 10;
h_dist = 35;
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
//cube([x_dim,l,1]);
//Flop in some M3 holes