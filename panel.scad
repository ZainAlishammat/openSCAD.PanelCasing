
use <MCAD/boxes.scad>
use<vesaMountStand.scad>
use<standFoot.scad>


// Resolution
$fn =20;  // [20:50]


panel_hight = 217; // [10:1000]
panel_width = 360;  // [10:1000]
display_hight = 195;   // [15:1000]
display_width = 350;  // [15:1000]
panelUnder_hight = 19;  // [10:50]
cableWidth=40; // [1:100]
cableXPos=100; // [1:900]
_holesWanted = true;
_vesaMountWanted = true;
_vesaStandWanted = true;
_frontCoverWanted = true;
_rearCoverWanted = true;
_standWanted = true;


rotate([70, 0,0])union(){
// calling the panel casing module
panelCasing(_holesWanted, _vesaMountWanted);
// calling the vesaStand module
translate([0,0,-(2+4+1.5)]) rotate([0,180,0])vesaMountStand(_vesaStandWanted);
}

rotate([0,0,-90])translate([-40,0,-150])standFoot(_standWanted);
	
	
module panelCasing (_holesWanted,_vesaMountWanted){
	
		// Function  deklerations 
		color("maroon")rearCover_muster(_holesWanted, _rearCoverWanted);
	
		translate([0, 0, (base_thickness+frontCover_thickness)/2])frontCover_muster(_holesWanted, _frontCoverWanted);
	
		color("red") union() {
			vesaMount(_vesaMountWanted);
			rotate([0,0,90]) vesaMount(_vesaMountWanted);
	}
	
	e = (panel_hight - display_hight)/2;	
	overlapRate = 0.001;	
	screwHead_radius = 3;
	screw_radius = 2;	
	roundedEdge = 2;	
	safeSpace = 0;
	base_hight = _holesWanted ? panel_hight + 5*screw_radius : panel_hight + 2;
	base_width = _holesWanted ? panel_width + 5*screw_radius : panel_width + 2;

	base_thickness = 4;
	frontCover_thickness = 2;

	screw_X = base_width /2 - screw_radius - 2;
	screw_Y = base_hight /2 - screw_radius - 2;
	screw_Z = base_thickness/2;	
		

	
/*
rear cover
*/
module rearCover_muster(holesWanted=true, rearCoverWanted=true){
	
	module rearCover (){
		
		difference(){

		roundedBox(size = [base_width, base_hight, base_thickness],radius = roundedEdge ,sidesonly=true);
		translate([0, 0, base_thickness/2])roundedBox(size = [panel_width, panel_hight, base_thickness],radius = roundedEdge ,sidesonly=true);
			translate([-cableXPos,- (base_hight -(base_hight- panel_hight))/2,  base_thickness/4+overlapRate])roundedBox(size=[cableWidth, (base_hight-panel_hight)+1, base_thickness/2+0.2], radius=0.2, sideonly=true);
			}
	}
	if(rearCoverWanted){
				
				if(holesWanted){
		
					difference(){
						rearCover();

		// screw_up_right 
		translate([screw_X ,screw_Y ,screw_Z]) cylinder(h=base_thickness, r = screw_radius, center=true);
		// screw_up_left
		translate([-screw_X ,screw_Y ,screw_Z]) cylinder(h=base_thickness, r = screw_radius, center=true);
		// screw_down_right
		translate([screw_X, -screw_Y, screw_Z]) cylinder(h=base_thickness, r = screw_radius, center=true);
		// screw_down_left
		translate([-screw_X, -screw_Y, screw_Z]) cylinder(h=base_thickness, r = screw_radius, center=true);
		}
	
	}
			else{
				rearCover();
		}
				
	}

}


	
/* 
screw hole
*/
	module screwHole_muster() {
	
	linear_extrude(frontCover_thickness/2) circle(r = screwHead_radius);
	translate([0,0, frontCover_thickness/2 - overlapRate])cylinder(h =frontCover_thickness/2+0.2, r=screw_radius);		
	
	}	


/*
front conver
*/
	module frontCover_muster(screwWanted=true, frontCoverWanted=true){
	
		module frontCover () {
	
			difference(){
			
			roundedBox(size = [base_width, base_hight, frontCover_thickness],radius = roundedEdge ,sidesonly=true);
			translate([0, panelUnder_hight - e, 0])roundedBox(size = [display_width, display_hight , frontCover_thickness + 1],radius = roundedEdge ,sidesonly=true);
	
	}
}
		if(frontCoverWanted){
		//font cover withou holes

		if(screwWanted){
	
			difference(){
				frontCover();
		
				translate([0,0,frontCover_thickness/2+0.1])rotate([0,180, 0])union() {
				// hole_up_right 
				translate([screw_X, screw_Y, 0])screwHole_muster();
				// hole_up_left
				translate([-screw_X, screw_Y, 0])screwHole_muster() ;
				// hole_down_right
				translate([screw_X, -screw_Y, 0])screwHole_muster();
				// hole_down_left
				translate([-screw_X, -screw_Y, 0])screwHole_muster();

				}
			}
		}
		else {
			frontCover();
		}
	}
} 



/*
vesa mount
M4 nut according to DIN 934 -> thickness equal to 3.2 mm. 
Vesa dimensions 100x100
M4 screw from 6 mm length	

*/
	module vesaMount(vesaMountWanted){
	
	vesaDimensionXY=100;
	nutDiameter=7;
	vesaThickness=4;
	if(vesaMountWanted){
		
	for(i=[45:90:359]){
	translate([((vesaDimensionXY/2)/sin(i))*cos(i),((vesaDimensionXY/2)/cos(i))*sin(i),-(base_thickness/2+vesaThickness/2)])
	difference() {
		cylinder (h=vesaThickness, r1=nutDiameter/2+1, r2=nutDiameter/2+3, center=true);
		linear_extrude(height =8+0.1, center=true) circle(r=nutDiameter/2, $fn=6);
			}
		}
	}
}


}

