use<MCAD/boxes.scad>
use<vesaBracket.scad>
use<standFoot.scad>





// Resolution
$fn =20;  // [20:50]

_holesWanted = true;
_vesaMountWanted = true;
_vesaBracketWanted = true;
_frontCoverWanted = true;
_rearCoverWanted = true;
_standWanted = true;

panel_hight = 218; // [10:500]
display_hight = 197;   // [15:450]
panel_width = 359;  // [10:600]
display_width = 347;  // [15:550]
panel_thickness=3.5; // [1:10]


panelUnder_hight = 15;  // [10:50]

panelPlugWidth=23; // [1:100]
panelPlugXPos=223; // [1:900]
_vesaBracketThickness=5; //[1:10]

// threaded insert
vesaThroughhole=3.2; // [2:6]
vesaThrougholesThickness = 4; // [1:10]
vesaDimension=100; // [100:200]

	
rotate([70, 0,0])union(){
// calling the panel casing module
panelCasing();
// calling the vesaStand module
translate([0,0,-(_vesaBracketThickness+3)]) rotate([0,180,0])vesaBracket(_vesaBracketWanted);
}

rotate([0,0,-90])translate([-40,0,-150])standFoot(_standWanted);
	
	
module panelCasing (){
	
	// Function  deklerations 
	color("maroon")rearCover_template();

	translate([0, 0, (base_thickness+frontCover_thickness)/2])frontCover_template();
	
	e = (panel_hight - display_hight)/2;	
	overlapRate = 0.001;	
	screwHead_radius = 3;
	screw_radius = 2;	
	roundedEdge = 2;	
	safeSpace = 0;
		
	frame_thickness = 7;
		
	base_hight = _holesWanted ? panel_hight + frame_thickness *screw_radius : panel_hight + 2;
	base_width = _holesWanted ? panel_width + frame_thickness *screw_radius : panel_width + 2;
	base_thickness = _vesaMountWanted? panel_thickness+vesaThrougholesThickness+2: panel_thickness+2;
		
	frontCover_thickness = 3;

	screw_X = base_width /2 - screw_radius - 2.5;
	screw_Y = base_hight /2 - screw_radius - 2.5;
	screw_Z = base_thickness-(base_thickness-2);	
		

	
/*
 rear cover scew holes template
*/
	module screw_template(){
		
		if(_holesWanted){
			
			// screw_up_right 
		translate([screw_X ,screw_Y ,screw_Z]) 
		cylinder(h=base_thickness, r = screw_radius, center=true);
		// screw_up_left
		translate([-screw_X ,screw_Y ,screw_Z]) 
		cylinder(h=base_thickness, r = screw_radius, center=true);
		// screw_down_right
		translate([screw_X, -screw_Y, screw_Z]) 
		cylinder(h=base_thickness, r = screw_radius, center=true);
		// screw_down_left
		translate([-screw_X, -screw_Y, screw_Z]) 
		cylinder(h=base_thickness, r = screw_radius, center=true);			
				}
		
		}
		
/*
rear cover template 
*/		
	module rearCover_template(){
		
		// rear cover without screw holes
		module rearCover (){
			
			if(_rearCoverWanted){
		
					difference(){

						roundedBox(size = [base_width, base_hight,
						 base_thickness],
						radius = roundedEdge ,sidesonly=true);
						translate([0, 0, panel_thickness])roundedBox
						(size = [panel_width, panel_hight, base_thickness],
						radius = 0.5 ,sidesonly=true);
						translate([0, 0, panel_thickness])roundedBox
						(size=[panel_width+frame_thickness /2,panel_hight-frame_thickness*2,base_thickness]
						,radius=0.5,sidesonly=true);
						translate([0, 0, panel_thickness])roundedBox
						(size=[panel_width-frame_thickness*2,panel_hight+frame_thickness/2,base_thickness]
						,radius=0.5,sidesonly=true);
						translate([-(panelPlugXPos-(panel_width/2)+panelPlugWidth/2),- 
						(base_hight -(base_hight- panel_hight))/2,  base_thickness/4])roundedBox
						(size=[panelPlugWidth, (base_hight-panel_hight)+1, base_thickness/2+0.2], 
						radius=0.2, sidesonly=true);
				}
				
			}		
		}
		
		// building the front cover accourding to			
		difference(){
						
			rearCover();
			screw_template();
			vesaHoles_template ();
				
				}

	}


	
/* 
screw hole  template for the front cover
*/
	module screwHoleTemplateFrontCover() {
		
		linear_extrude(frontCover_thickness/2) circle(r = screwHead_radius);
		translate([0,0, frontCover_thickness/2 - overlapRate])cylinder(h =
		frontCover_thickness/2+0.2, r=screw_radius);		

	}	


/*
front conver
*/
	module frontCover_template(){
	
		module frontCover () {
	
			difference(){
			
				roundedBox(size = [base_width, base_hight, frontCover_thickness],radius = 
				roundedEdge ,sidesonly=true);
				translate([0, panelUnder_hight - e, 0])
				roundedBox(size = [display_width, display_hight , frontCover_thickness + 1]
				,radius = roundedEdge ,sidesonly=true);
	
			}
		}
		if(_frontCoverWanted){
			
			//font cover withou holes?
			if(_holesWanted){
	
					difference(){
						frontCover();
		
						translate([0,0,frontCover_thickness/2+0.1])rotate([0,180, 0])union() {
							
						// hole_up_right 
						translate([screw_X, screw_Y, 0])screwHoleTemplateFrontCover();
						// hole_up_left
						translate([-screw_X, screw_Y, 0])screwHoleTemplateFrontCover() ;
						// hole_down_right
						translate([screw_X, -screw_Y, 0])screwHoleTemplateFrontCover();
						// hole_down_left
						translate([-screw_X, -screw_Y, 0])screwHoleTemplateFrontCover();

				}
			}
		}
		else {
			frontCover();
		}
	}
} 


/* vesa holes in the rear cover */
	module vesaHoles_template  () {
	
		module vesaHoles () {
			
			cylinder(h=base_thickness*2,r=vesaThroughhole/2,center=true);
		
					}
				if(_vesaMountWanted) {
						// hole_up_right 					
					translate([vesaDimension/2,vesaDimension/2,0]) vesaHoles();
						// hole_down_right					
					translate([vesaDimension/2,-vesaDimension/2,0])vesaHoles();
						// hole_down_left					
					translate([-vesaDimension/2,-vesaDimension/2,0])vesaHoles();
						// hole_up_left					
					translate([-vesaDimension/2,vesaDimension/2,0])vesaHoles();
				}
	

		}

}

