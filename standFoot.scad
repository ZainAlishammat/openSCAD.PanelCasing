


columnThickness_X = 15;
columnThickness_Y =10;
columnHight=150;
footLength=100;
footWidth=8;

footHight_1=7;
footHight_2=5;

holeRadius=2.5;
	
	
	
standFoot();

module standFoot(standWanted = true){
	$fn =50; 
	
	polygonP =20+columnThickness_X;
	polygonP2=25;
	
	// columnolumnThickness_X x columnThickness_Y
	module e(){

		translate([-columnThickness_X/2,0,0])minkowski() {
			rotate([90,0,0])linear_extrude(columnThickness_Y,center=true){
			polygon([[0,0],[columnThickness_X,0],[polygonP,columnHight],[polygonP2,columnHight],[0,0]]);
			}
			cylinder(r=0.2,h=0.001);
		}
	}

		// foot
	module r(){


		minkowski() {
			rotate([90,0,-45])linear_extrude(footWidth,center=true){
			polygon([[0,0],[footLength,0],[footLength,footHight_2],[0,footHight_1],[0,0]]);
			}
			cylinder(r=1,h=0.001);
		}
	}



		
	if(standWanted){
			difference(){
			e();
			translate([(polygonP-5-(columnThickness_X/2)),0,columnHight-2.5-2])rotate([90,0,0])cylinder(r=holeRadius,h=columnThickness_Y+1,center=true);
	}
		
			r();
			rotate([0,0,90])r();
		}
}

