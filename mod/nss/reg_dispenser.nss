#include "inc_cs_dispreg"

void main() {
	Register_Dispenser("TINDER", "BMI5;BMA10;MAX-1;REStms_tinder");
	Register_Dispenser("Egg", "BMI1;BMA2;MAX100;RESfood_raw_996");

	/*Register_Dispenser("MINECOPPER","BMI900;BMA1800;MAX-1;RESCS_OR00;TSKM;DIF5;LOS50;OB1PickAxe;US11;TO1Sie brauchen eine Spitzhacke.;MISSie schlagen auf taubes Gestein.;EXHIm Moment sehen Sie keine Erzadern.");
	 * Register_Dispenser("MINEBRONZE","BMI900;BMA1800;MAX-1;RESCS_OR01;TSKM;DIF10;LOS50;OB1PickAxe;US11;TO1Sie brauchen eine Spitzhacke.;MISSie schlagen auf taubes Gestein.;EXHIm Moment sehen Sie keine Erzadern.");
	 * Register_Dispenser("MINEIRON","BMI900;BMA1800;MAX-1;RESCS_OR02;TSKM;DIF40;LOS50;OB1PickAxe;US11;TO1Sie brauchen eine Spitzhacke.;MISSie schlagen auf taubes Gestein.;EXHIm Moment sehen Sie keine Erzadern.");
	 * Register_Dispenser("MINESILVER","BMI900;BMA1800;MAX-1;RESCS_OR03;TSKM;DIF80;LOS50;OB1PickAxe;US11;TO1Sie brauchen eine Spitzhacke.;MISSie schlagen auf taubes Gestein.;EXHIm Moment sehen Sie keine Erzadern.");
	 * Register_Dispenser("MINEGOLD","BMI900;BMA1800;MAX-1;RESCS_OR04;TSKM;DIF120;LOS50;OB1PickAxe;US11;TO1Sie brauchen eine Spitzhacke.;MISSie schlagen auf taubes Gestein.;EXHIm Moment sehen Sie keine Erzadern.");
	 * Register_Dispenser("MINEMITHRIL","BMI900;BMA1800;MAX-1;RESCS_OR05;TSKM;DIF160;LOS50;OB1PickAxe;US11;TO1Sie brauchen eine Spitzhacke.;MISSie schlagen auf taubes Gestein.;EXHIm Moment sehen Sie keine Erzadern.");
	 * Register_Dispenser("MINEADAMANT","BMI900;BMA1800;MAX-1;RESCS_OR06;TSKM;DIF200;LOS50;OB1PickAxe;US11;TO1Sie brauchen eine Spitzhacke.;MISSie schlagen auf taubes Gestein.;EXHIm Moment sehen Sie keine Erzadern.");
	 *
	 * Register_Dispenser("MINEROCK","BMI900;BMA1800;MAX-1;RESbm_felsbrocken;TSKM;DIF5;LOS50;OB1PickAxe;US11;TO1Sie brauchen eine Spitzhacke.;MISSie schlagen die Brocken zu Kies.");
	 */

	Register_Dispenser("TREEOAK",
		"PRE20;BMI6;BMA10;MAX-1;RESCS_MA20;TSKW;DIF10;LOS80;OB1WoodAxe;US11;TO1Eine Holzfaelleraxt waere hilfreich.;MISDer Schlag war falsch angesetzt.");
	Register_Dispenser("TREEELM",
		"PRE30;BMI4;BMA6;MAX-1;RESCS_MA22;TSKW;DIF40;LOS80;OB1WoodAxe;US11;TO1Eine Holzfaelleraxt waere hilfreich.;MISDer Schlag war falsch angesetzt.");
	Register_Dispenser("TREEASH",
		"PRE40;BMI2;BMA4;MAX-1;RESCS_MA24;TSKW;DIF80;LOS80;OB1WoodAxe;US11;TO1Eine Holzfaelleraxt waere hilfreich.;MISDer Schlag war falsch angesetzt.");

	Register_Dispenser("herb001", "BMI1;BMA1;MAX-1;RESherb001");
	Register_Dispenser("herb002", "BMI1;BMA1;MAX-1;RESherb002");
	Register_Dispenser("herb003", "BMI1;BMA1;MAX-1;RESherb003");
	Register_Dispenser("herb004", "BMI2;BMA3;MAX-1;RESherb004");
	Register_Dispenser("herb005", "BMI1;BMA1;MAX-1;RESherb005");
	Register_Dispenser("herb006", "BMI1;BMA1;MAX-1;RESherb006");
	Register_Dispenser("herb007", "BMI2;BMA5;MAX-1;RESherb007");
	Register_Dispenser("herb008", "BMI1;BMA3;MAX-1;RESherb008");
	Register_Dispenser("herb009", "BMI1;BMA1;MAX-1;RESherb009");
	Register_Dispenser("herb010", "BMI2;BMA2;MAX-1;RESherb010");
	Register_Dispenser("herb011", "BMI1;BMA1;MAX-1;RESherb011");
	Register_Dispenser("herb012", "BMI1;BMA2;MAX-1;RESherb012");
	Register_Dispenser("herb013", "BMI1;BMA1;MAX-1;RESherb013");
	Register_Dispenser("herb014", "BMI1;BMA1;MAX-1;RESherb014");
	Register_Dispenser("herb015", "BMI1;BMA1;MAX-1;RESherb015");
	Register_Dispenser("herb016", "BMI1;BMA1;MAX-1;RESherb016");

	Register_Dispenser("herb019", "BMI1;BMA1;MAX-1;RESherb019");

	Register_Dispenser("gem057", "BMI1;BMA1;MAX-1;RESgem057");

	Register_ObjGrp("Mine_VeryPoor");
	Register_GrpMember("disp_mine0", 100);
	Register_GrpMember("disp_mine1", 10);

	Register_ObjGrp("Mine_Poor");
	Register_GrpMember("disp_mine0", 50);
	Register_GrpMember("disp_mine1", 100);
	Register_GrpMember("disp_mine2", 10);

	Register_ObjGrp("Mine_SubAvg");
	Register_GrpMember("disp_mine0", 20);
	Register_GrpMember("disp_mine1", 50);
	Register_GrpMember("disp_mine2", 100);
	Register_GrpMember("disp_mine3", 20);

	Register_ObjGrp("Mine_Average");
	Register_GrpMember("disp_mine1", 20);
	Register_GrpMember("disp_mine2", 50);
	Register_GrpMember("disp_mine3", 100);
	Register_GrpMember("disp_mine4", 10);

	Register_ObjGrp("Mine_Rich");
	Register_GrpMember("disp_mine2", 20);
	Register_GrpMember("disp_mine3", 50);
	Register_GrpMember("disp_mine4", 100);
	Register_GrpMember("disp_mine5", 10);

	Register_ObjGrp("Mine_VeryRich");
	Register_GrpMember("disp_mine3", 20);
	Register_GrpMember("disp_mine4", 50);
	Register_GrpMember("disp_mine5", 70);
	Register_GrpMember("disp_mine6", 20);

	Register_ObjGrp("Herb_Forest");
	Register_GrpMember("disp_herb003", 50);
	Register_GrpMember("disp_herb011", 50);
	Register_GrpMember("disp_herb014", 30);
	Register_GrpMember("disp_herb015", 50);
	Register_GrpMember("disp_herb016", 20);
	Register_GrpMember("disp_herb019", 20);

	Register_ObjGrp("Herb_Plain");
	Register_GrpMember("disp_herb001", 60);
	Register_GrpMember("disp_herb002", 60);

	Register_ObjGrp("Herb_Jungle");
	Register_GrpMember("disp_herb004", 30);
	Register_GrpMember("disp_herb005", 30);
	Register_GrpMember("disp_herb007", 30);
	Register_GrpMember("disp_herb008", 50);
	Register_GrpMember("disp_herb010", 20);
	Register_GrpMember("disp_herb013", 50);
	Register_GrpMember("disp_herb004", 30);

	Register_ObjGrp("Herb_Mountain");
	Register_GrpMember("disp_herb006", 30);

	Register_ObjGrp("Herb_Desert");
	Register_GrpMember("disp_gem057", 2);
	Register_GrpMember("disp_herb009", 100);
	// Register_GrpMember("disp_herb012", 50);

	Register_ObjGrp("Tree_Forest1");
	Register_GrpMember("disp_treeoak", 60);
	Register_GrpMember("disp_treeelm", 30);
	Register_GrpMember("disp_treeash", 20);

	Register_ObjGrp("Pack_Temperate");
	Register_GrpMember("packox", 50);
	Register_GrpMember("packpferd", 20);
	Register_GrpMember("packpony", 20);

	Register_ObjGrp("Pack_Desert");
	Register_GrpMember("dromedar001", 50);
	Register_GrpMember("kamel001", 50);

}
