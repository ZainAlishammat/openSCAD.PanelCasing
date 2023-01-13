use <MCAD/boxes.scad>


holeRadius=2.5;
hookDistance = 5;


/*
	vesa Mount Stand
*/
vesaMountStand();
module vesaMountStand(vesaStandWanted=true){
	
	vesaDimensionXY =100;
	screwRadius=2;

	// the hook
	module r(){
				
		hookThickness = 3;
		

		translate([-hookDistance,0,3])rotate([90,-90,90])difference(){
		hull(){
					
					roundedBox(size=[6,6,hookThickness],radius=1, sidesonly=true);
				translate([6,0,0]) cylinder(r=6,h=hookThickness,center=true);
					
			}
			translate([6,0,0])cylinder(r=holeRadius,h=hookThickness+1,center=true);
	}
	
}

	// cutting the sides off
	module triangle(side1, side2, corner_radius, triangle_hight){
	
		translate([corner_radius+3, corner_radius+3,0])
		hull(){
		
		cylinder(r=corner_radius, h=triangle_hight,center=true);
		translate([side1-(2*corner_radius), 0,0]) cylinder(r=corner_radius, h=triangle_hight, center=true);
		translate([0,side2-(2*corner_radius)],0) cylinder(r=corner_radius, h=triangle_hight, center=true);
		}
}

	// holes
	module f() {
		for(i=[45:90:359]){
		
			translate([((vesaDimensionXY/2)/sin(i))*cos(i),((vesaDimensionXY/2)/cos(i))*sin(i),0]) cylinder(r=screwRadius,h=5,center=true);
	}
}

	if(vesaStandWanted){
	
		r() ;
		mirror([4,0,0]) r();
		difference(){

		roundedBox(size = [110,110,3],radius = 3 ,sidesonly=true);
	
	// middle hole
		cylinder(r=screwRadius, h=5, center=true);
	// sides holes
		f();
		rotate([0,0,90])f();
		
		for(i=[45:90:359]){
		rotate([0,0,i])triangle(70,70,10,7);  
				}
			}
	}
}

