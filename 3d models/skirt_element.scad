wt = 3;
$fn = 30;
top_height = 11;
bottom_height = 7;
x_dim = 29;
difference(){
  
  minkowski(){
    translate([0,-wt,-bottom_height])cube([x_dim+wt,30+wt,top_height+bottom_height]);
     sphere(r=0.5);
  }
  
  union(){
  translate([-1,-1,-bottom_height-1])cube([x_dim+2,32,top_height+bottom_height+2]);

  translate([6,-10,0])rotate([-90,0,0])cylinder(r=1.6,100);
  translate([6+17,-10,0])rotate([-90,0,0])cylinder(r=1.6,100);

  }

}
