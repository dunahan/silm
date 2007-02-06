#include "inc_gods"

void Register_Deities() {
	/* HUMAN PANTHEON (Mainstream) */
	/* Lawful good deities */
	SetGodAlignments("Ilmater",       "**");
	SetGodAlignments("Torm",          "*G,LN");
	SetGodAlignments("Tyr",           "LG,NG,LN");

	/* Lawful neutral deities */
	SetGodAlignments("Azuth",         "**");
	SetGodAlignments("Helm",          "*G,*N");
	SetGodAlignments("Kelemvor",      "**");

	/* Lawful evil deities */
	SetGodAlignments("Bane",          "*N,*E");
	SetGodAlignments("Loviatar",      "*E");

	/* Neutral good deities */
	SetGodAlignments("Chauntea",      "*N,*G");
	SetGodAlignments("Deneir",        "*N,*G");
	SetGodAlignments("Eldath",        "*N,*G");
	SetGodAlignments("Lathander",     "*N,*G");
	SetGodAlignments("Mielikki",      "*N,*G");
	SetGodAlignments("Milil",         "**");
	SetGodAlignments("Mystra",        "**");

	/* True neutral deities */
	SetGodAlignments("Akadi",         "**");
	SetGodAlignments("Gond",          "*N,N*");
	SetGodAlignments("Grumbar",       "*N,N*");
	SetGodAlignments("Istishia",      "**");
	SetGodAlignments("Kossuth",       "**");
	SetGodAlignments("Oghma",         "**");
	SetGodAlignments("Silvanus",      "**");
	SetGodAlignments("Ubtao",         "**");
	SetGodAlignments("Waukeen",       "**");

	/* Neutral evil deities */
	SetGodAlignments("Auril",         "*N,*E");
	SetGodAlignments("Mask",          "NG,CG,*N,*E");
	SetGodAlignments("Shar",          "NG,CG,*N,*E"); //All, but mainly evil
	SetGodAlignments("Velsharoon",    "*N,*E");

	/* Chaotic good deities */
	SetGodAlignments("Lliira",        "**");
	SetGodAlignments("Selune",        "*G");
	SetGodAlignments("Sune",          "*G,*N");
	SetGodAlignments("Tymora",        "N,CN,NG,CG");

	/* Chaotic neutral deities */
	SetGodAlignments("Shaundakul",    "*G,*N,*E");
	SetGodAlignments("Schaundakul",   "*G,*N,*E"); //Different spelling
	SetGodAlignments("Tempus",        "**");

	/* Chaotic evil deities */
	SetGodAlignments("Beshaba",       "NG,CG,*N,*E"); //All, but mainly CN and evil
	SetGodAlignments("Cyric",         "*N,*E");
	SetGodAlignments("Malar",         "N,CN,*E");
	SetGodAlignments("Talona",        "*N,*E");
	SetGodAlignments("Talos",         "*N,*E");
	SetGodAlignments("Umberlee",      "*N,*E");

	/* HUMAN PANTHEON (Mulhorand) */
	/* Lawful good deities */
	SetGodAlignments("Horus-Re",      "*G,LN,N,LE");
	SetGodAlignments("Osiris",        "*G,*N");

	/* Lawful neutral deities */
	// -- none known

	/* Lawful evil deities */
	SetGodAlignments("Set",           "*E");

	/* Neutral good deities */
	SetGodAlignments("Hathor",        "*G,*N");
	SetGodAlignments("Isis",          "*G");

	/* True neutral deities */
	SetGodAlignments("Geb",           "**");
	SetGodAlignments("Thoth",         "**");

	/* Neutral evil deities */
	SetGodAlignments("Sebek",         "*E");

	/* Chaotic good deities */
	SetGodAlignments("Anhur",         "*G,*N");
	SetGodAlignments("Nephthys",      "*G,*N");

	/* Chaotic neutral deities */
	// -- none known

	/* Chaotic evil deities */
	// -- none known


	/* ELVEN PANTHEON */
	/* Lawful deities */
	// -- none known

	/* Neutral deities */
	// -- none known

	/* Chaotic good deities */
	SetGodAlignments("Aerdrie Faenya",    "NG,CG,N,CN");
	SetGodAlignments("Angharradh",        "*G,*N");
	SetGodAlignments("Corellon Larethian", "**");
	SetGodAlignments("Corellon",          "**");
	SetGodAlignments("Deep Sashelas",     "*G,*N");
	SetGodAlignments("Hanali Celanil",    "*G,*N");
	SetGodAlignments("Labelas Enoreth",   "*G,*N");
	SetGodAlignments("Rillifane Rallathil", "*G,*N");
	SetGodAlignments("Sehanine Mondbogen", "*G,*N");
	SetGodAlignments("Sehanine Moonbow",  "*G,*N"); //English and german
	SetGodAlignments("Solonor Thelandira", "*G,*N");

	/* Chaotic neutral deities */
	SetGodAlignments("Erevan Ilesere",    "NG,CG,N,CN");
	SetGodAlignments("Fenmarel Mesatarine", "*G,*N");
	SetGodAlignments("Shevarash", "*G,*N");

	/* Chaotic evil deities */
	// -- none known (drow pantheon is noted down separately)


	/* DROW PANTHEON */
	/* Chaotic good deities */
	SetGodAlignments("Eilistraee",        "*G");

	/* Chaotic evil deities */
	SetGodAlignments("Ghaunadaur",        "*E,LN,CN,LG");
	SetGodAlignments("Kiaransalee",       "*E");
	SetGodAlignments("Lolth",             "*E");
	SetGodAlignments("Lloth",             "*E"); // Seen as regional dialect
	SetGodAlignments("Vhaeraun",          "*E");


	/* DWARVEN PANTHEON */
	/* Lawful good deities */
	SetGodAlignments("Berronar Truesilver", "**");
	SetGodAlignments("Berronar Wahrsilber", "**");
	SetGodAlignments("Clangeddin Silverbeard", "*G,LN,CN");
	SetGodAlignments("Clangeddin Silberbart", "*G,LN,CN");
	SetGodAlignments("Clangeddin",        "*G,LN,CN");
	SetGodAlignments("Gorm Gulthyn",      "*G,LN,N");
	SetGodAlignments("Moradin",           "**");

	/* Lawful neutral deities */
	// -- none known

	/* Lawful evil deities (duergar) */
	SetGodAlignments("Deep Duerra",       "LN,LE,NE");
	SetGodAlignments("Laduguer",          "LN,N,LE,NE");

	/* Neutral good deities */
	SetGodAlignments("Mathammor Duin",    "*G,*N");

	/* True neutral deities */
	SetGodAlignments("Dumathoin",         "LG,NG,LN,N");
	SetGodAlignments("Vergadain",         "**");

	/* Neutral evil deities */
	SetGodAlignments("Abbathor",          "*E");

	/* Chaotic good deities */
	SetGodAlignments("Dugmaren Brightmantle", "*G,LN,CN");
	SetGodAlignments("Dugmaren",          "*G,LN,CN");
	SetGodAlignments("Haela Brightaxe",   "**");
	SetGodAlignments("Sharindlar",        "**");
	SetGodAlignments("Thard Harr",        "**");

	/* Chaotic neutral deities */
	// -- none known

	/* Chaotic evil deities */
	// -- none known


	/* GNOME PANTHEON */
	/* Lawful good deities */
	SetGodAlignments("Gaerdal Ironhand",  "*G,*N");
	SetGodAlignments("Gaerdal Eisenhand", "*G,*N");
	SetGodAlignments("Garl Glittergold",  "*G,*N");
	SetGodAlignments("Garl Glitzergold",  "*G,*N");

	/* Neutral good deities */
	SetGodAlignments("Baervan Wildwanderer", "*G,*N");
	SetGodAlignments("Baravar Cloakshadow", "*G,*N");
	SetGodAlignments("Baravar Mantelschatten", "*G,*N");
	SetGodAlignments("Flandar Steelskin", "*G,*N");
	SetGodAlignments("Flandar Stahlhaut", "*G,*N");
	SetGodAlignments("Segojan Earthcaller", "*G,*N");
	SetGodAlignments("Segojan Erdrufer",  "*G,*N");

	/* True neutral deities */
	SetGodAlignments("Callarduran Smoothhands", "NG,N");
	SetGodAlignments("Callarduran",       "NG,N");

	/* Chaotic evil deities */
	SetGodAlignments("Urdlen",            "*E");


	/* HALFLING PANTHEON */
	/* Lawful good deities */
	SetGodAlignments("Arvoreen",          "*G,*N");
	SetGodAlignments("Cyrrollalee",       "*G,*N");
	SetGodAlignments("Yondalla",          "*G,*N");

	/* Lawful neutral deities */
	SetGodAlignments("Urogalan",          "LG,NG,LN,N");

	/* True neutral deities */
	SetGodAlignments("Brandobaris",       "**");
	SetGodAlignments("Sheela Peyroyl",    "*G,*N");


	/* ORC PANTHEON */

}

