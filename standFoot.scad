


columnThickness_X = 8;
columnThickness_Y =7;
columnHight=150;
footLength=100;
footThickness=2;
	
	
	
standFoot();

module standFoot(standWanted = true){
	$fn =50; 
	
	
	// columnolumnThickness_X x columnThickness_Y
	module e(){

		minkowski() {
		rotate([90,0,0])linear_extrude(columnThickness_Y,center=true){
		polygon([[0,0],[columnThickness_X,0],[20+columnThickness_X,columnHight],[20,columnHight],[0,0]]);
			}
		cylinder(r=0.2,h=0.001);
		}
	}

		// foot
	module r(){


		minkowski() {
		rotate([90,0,-45])linear_extrude(footThickness,center=true){
		polygon([[0,0],[footLength,0],[footLength,3],[3,3],[0,0]]);
			}
		cylinder(r=1,h=0.001);
		}
	}



		
	if(standWanted){
			difference(){
			e();
			translate([(20+columnThickness_X-2.5-2.5),0,columnHight-2.5-2])rotate([90,0,0])cylinder(r=2.5,h=10,center=true);
	}
		
			r();
			rotate([0,0,90])r();
		}
}

