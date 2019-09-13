

v_dist = 17;
h_dist = 35;




wt = 2;
$fn = 30;

edge_margin = 7.5-0.5;


screw_top_radius =  6.5/2;

module 2X(){
  
  x_dim = v_dist + edge_margin*2 ;
  y_dim = h_dist + edge_margin*2;
  
  difference(){
    
    minkowski(){
      translate([-edge_margin,-edge_margin,0])cube([x_dim,y_dim,wt]);
       sphere(r=0.5);
    }
    
    
    translate([0,0,-1])cylinder(r=1.6,100);
    translate([v_dist,0,-1])cylinder(r=1.6,100);
    
      translate([v_dist,h_dist,-1])cylinder(r=1.6,100);
    
      translate([0,h_dist,-1])cylinder(r=1.6,100);
    
    q = screw_top_radius;
    z_offset = 1.5;
      translate([0,0,z_offset])cylinder(r=q,100);
    translate([v_dist,0,z_offset])cylinder(r=q,100);
    
      translate([v_dist,h_dist,z_offset])cylinder(r=q,100);
    
      translate([0,h_dist,z_offset])cylinder(r=q,100);

  }
}

module 3X(){
  
  x_dim = v_dist + edge_margin*2 ;
  y_dim = h_dist*2 + edge_margin*2;

  difference(){
    
    minkowski(){
      translate([-edge_margin,-edge_margin,0])cube([x_dim,y_dim,wt]);
       sphere(r=0.5);
    }
    
    
    translate([0,0,-1])cylinder(r=1.6,100);
    translate([v_dist,0,-1])cylinder(r=1.6,100);
    
      translate([v_dist,h_dist,-1])cylinder(r=1.6,100);
    
      translate([0,h_dist,-1])cylinder(r=1.6,100);
    
        translate([v_dist,h_dist*2,-1])cylinder(r=1.6,100);
    
      translate([0,h_dist*2,-1])cylinder(r=1.6,100);
    
    q = screw_top_radius;
    z_offset = 1.5;
      translate([0,0,z_offset])cylinder(r=q,100);
    translate([v_dist,0,z_offset])cylinder(r=q,100);
    
      translate([v_dist,h_dist,z_offset])cylinder(r=q,100);
    
      translate([0,h_dist,z_offset])cylinder(r=q,100);
    
          translate([v_dist,h_dist*2,z_offset])cylinder(r=q,100);
    
      translate([0,h_dist*2,z_offset])cylinder(r=q,100);



  }
}

module 7W(){
  /*
  textSize=8;
   font = "Franklin Gothic Heavy";
    textHeight= 1;
  translate([edge_margin+v_dist*2.5,h_dist*0.5,wt])
   linear_extrude(height=textHeight)text("BuysDB 2019", size=textSize, halign="center", valign="center",font="Franklin Gothic");*/
  
  
  
  x_dim = v_dist*6 + edge_margin*2 ;
  y_dim = h_dist + edge_margin*2;

  difference(){
    
    minkowski(){
      translate([-edge_margin,-edge_margin,0])cube([x_dim,y_dim,wt]);
       sphere(r=0.5);
    }
    
    
    translate([0,0,-1])cylinder(r=1.6,100);
    translate([v_dist,0,-1])cylinder(r=1.6,100);
    
      translate([v_dist,h_dist,-1])cylinder(r=1.6,100);
    
      translate([0,h_dist,-1])cylinder(r=1.6,100);
    
    for(i=[0:6]){
        translate([v_dist*i,0,-1])cylinder(r=1.6,100);
          translate([v_dist*i,h_dist*1,-1])cylinder(r=1.6,100);

    
    q = screw_top_radius;
    z_offset = 1.5;
      translate([0,0,z_offset])cylinder(r=q,100);
    translate([v_dist*i,0,z_offset])cylinder(r=q,100);
    
      translate([v_dist*i,h_dist,z_offset])cylinder(r=q,100);
    
      translate([0,h_dist,z_offset])cylinder(r=q,100);
    
          translate([v_dist*i,h_dist*2,z_offset])cylinder(r=q,100);
    
      translate([0,h_dist*2,z_offset])cylinder(r=q,100);
    }


  }
}

7W();