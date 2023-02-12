use <MCAD/boxes.scad>

$fn =20; 

vesaDimensionXY =100; 
holeRadius=2.5; // [1:50]
hookDistance = 5; // [1:50]
hookThickness = 3.5; // [1:50]
bracketThickness=5; // [1:50]

bracketWidth = 4; // [1:50]
screwRadius=2; // [1:50]

/*
		Building the vesa mount stand 
*/
vesaBracket();

module vesaBracket(vesaBracketWanted=true){
	

bindingValue=0.1; 
	// the hook
	module mkHook(){
				
		translate([-hookDistance-(hookThickness)/2,0,
		bracketThickness-bindingValue])rotate([90,-90,90])difference(){
		hull(){
					
					roundedBox(size=[6,6,hookThickness],radius=1, sidesonly=true);
					translate([6,0,0]) cylinder(r=6,h=hookThickness,center=true);
					
				}
		translate([6,0,0])cylinder(r=holeRadius,h=hookThickness+1,center=true);
		}
	
	}

	// cutting the sides off
	module triangle(side1, side2, corner_radius, triangle_hight){
	
		translate([corner_radius+bracketWidth, corner_radius+bracketWidth,0])
		hull(){
		
			cylinder(r=corner_radius, h=triangle_hight,center=true);
			translate([side1-(2*corner_radius), 0,0]) 
			cylinder(r=corner_radius, h=triangle_hight, center=true);
			translate([0,side2-(2*corner_radius)],0) 
			cylinder(r=corner_radius, h=triangle_hight, center=true);
			}
	}

	// holes
	module mkHole() {
		
		for(i=[45:90:360]){
		
			translate([((vesaDimensionXY/2)/sin(i))*cos(i),
			((vesaDimensionXY/2)/cos(i))*sin(i),0]) 
			cylinder(r=screwRadius,h=bracketThickness+1,center=true);
		}
	}

	if(vesaBracketWanted){
	
		mkHook() ;
		mirror([4,0,0]) mkHook();
		difference(){

			roundedBox(size = [110,110,bracketThickness],
			radius = 3 ,sidesonly=true);
	
		// middle hole
			cylinder(r=screwRadius, h=bracketThickness+1, 
			center=true);
		// sides holes
		mkHole();
			rotate([0,0,90])mkHole();
		
			for(i=[45:90:359]){
				rotate([0,0,i])triangle(70,70,10,7);  
				}
			}
	}
}

