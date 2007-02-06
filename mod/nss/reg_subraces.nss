#include "inc_subr_regist"

void main() {

	Register_Subrace("Sonnenelf", RACIAL_TYPE_ELF);
	AddAlias("Sun Elf");
	AddAlias("Sun");
	SetSRItem("ELF_SUN", 1);

	Register_Subrace("Waldelf", RACIAL_TYPE_ELF);
	AddAlias("Forest Elf");
	AddAlias("Forest");
	SetSRItem("ELF_FOR", 1);

	Register_Subrace("Wildelf", RACIAL_TYPE_ELF);
	AddAlias("Wild Elf");
	AddAlias("Wild");
	SetSRItem("ELF_WIL", 1);


	Register_Subrace("Lythari", RACIAL_TYPE_ELF);
	SetSPA(13, "WOLF");
	SetSRItem("ELF_LYT", 1);


	Register_Subrace("Dunkelelf", RACIAL_TYPE_ELF, 2, 2);
	AddAlias("Drow");
	AddAlias("Dhaeraow");
	AddAlias("Ilythiiri");
	SetSRItem("ELF_DRO", 1);
	SetSPA(12, "DARK");
	SetFlags(0x00020000); // Lichtempfindlich
	AddEffect("+spr", -1, 11, 0, 0, 1, 0, 0);
	AddEffect("dvis", -1);

	Register_Subrace("Avariel", RACIAL_TYPE_ELF, 3);
	AddAlias("Winged Elf");
	SetSRItem("ELF_AVA", 1);
	SetSPA(2, "FLY");
	// Klaustrophobisch (Mali auf unterirdischem Terrain)
	SetFlags(0x00010000);

	AddEffect("wing", -1, 15, 0, 0, 0, 0, 0);
	//AddEffect("wing",-1, 1, 0, 0, 0, 0, 0);


	Register_Subrace("Tiefengnom", RACIAL_TYPE_GNOME, 3);
	AddAlias("Swirfneblin");
	AddAlias("Deep Gnome");
	AddAlias("Deep");
	SetSRItem("GNM_DEE", 1);
	SetSPA(12, "BLND");
	// Lichtempfindlich, Verstecken-Bonus auf unterirdischem Terrain
	SetFlags(0x00020001);
	AddEffect("+spr", -1, 11, 0, 0, 1, 0, 0);


	Register_Subrace("Goldzwerg", RACIAL_TYPE_DWARF);
	AddAlias("Gold Dwarf");
	AddAlias("Gold");
	SetSRItem("DWA_GOL", 1);

	Register_Subrace("Grauzwerg", RACIAL_TYPE_DWARF, 2, 2);
	AddAlias("Duergar");
	AddAlias("Grey Dwarf");
	AddAlias("Grey");
	AddAlias("Gray Dwarf");
	AddAlias("Gray");
	SetSRItem("DWA_GRE", 1);
	SetSPA(11, "INVS");
	SetFlags(0x00020000); // Lichtempfindlich


	Register_Subrace("Aasimar", RACIAL_TYPE_ALL, 1);
	SetSRItem("ALL_AAS", 1);
	SetSPA(12, "LIGT");
	AddEffect("dvis", -1);
	SetFlags(0x00000002); //Immun gg. Dominate/Enchant Person

	Register_Subrace("Tiefling", RACIAL_TYPE_ALL, 1, 2);
	SetSRItem("ALL_TIE", 1);
	SetSPA(12, "DARK");
	SetFlags(0x00000002); //Immun gg. Dominate/Enchant Person

	Register_Subrace("Erdgenasi", RACIAL_TYPE_ALL, 1);
	SetSRItem("ALL_EAR", 1);
	AddEffect("+sav", -1, SAVING_THROW_ALL, 0, SAVING_THROW_TYPE_POISON, 0, 5, 0);
	SetFlags(0x00000002); //Immun gg. Dominate/Enchant Person

	Register_Subrace("Feuergenasi", RACIAL_TYPE_ALL, 1);
	SetSRItem("ALL_FIR", 1);
	AddEffect("+sav", -1, SAVING_THROW_ALL, 0, SAVING_THROW_TYPE_FIRE, 0, 5, 0);
	SetFlags(0x00000002); //Immun gg. Dominate/Enchant Person

	Register_Subrace("Luftgenasi", RACIAL_TYPE_ALL, 1);
	SetSRItem("ALL_AIR", 1);
	AddEffect("+sav", -1, SAVING_THROW_ALL, 0, SAVING_THROW_TYPE_ELECTRICITY, 0, 5, 0);
	SetFlags(0x00000002); //Immun gg. Dominate/Enchant Person

	Register_Subrace("Wassergenasi", RACIAL_TYPE_ALL, 1);
	SetSRItem("ALL_WAT", 1);
	AddEffect("+sav", -1, SAVING_THROW_ALL, 0, SAVING_THROW_TYPE_COLD, 0, 5, 0);
	SetFlags(0x00000002); //Immun gg. Dominate/Enchant Person
}
