#include "inc_decay"

void stomachStarvation(object oPC, int iRank) {
	int iRandApp = Random(5) + 1;
	switch ( iRank ) {
		case 1:
			// Kaum Hunger
			switch ( iRandApp ) {
				case  1: FloatingTextStringOnCreature("Ihr habt ein leichtes Hungergef�hl.", oPC, FALSE);
					break;
				case  2: FloatingTextStringOnCreature("Euch d�rstet es ein wenig.", oPC, FALSE); break;
				case  3: FloatingTextStringOnCreature(
						"Kurz schweifen eure Gedanken darum was wohl eure n�chste Mahlzeit sein wird.", oPC,
						FALSE); break;
				case  4: FloatingTextStringOnCreature(
						"Zaghaft meldet sich euer Magen: Eine kleine Knabberei k�me wohl gelegen.", oPC,
						FALSE); break;
				case  5: FloatingTextStringOnCreature(
						"Leicht macht sich Euch ein anschleichender Hunger bemerkbar.", oPC, FALSE); break;
			}

			break;
		case 2:
			// Normal Hunger
			switch ( iRandApp ) {
				case  1: FloatingTextStringOnCreature("Ihr werdet sehr hungrig.", oPC, FALSE); break;
				case  2: FloatingTextStringOnCreature("Hunger und Durst machen stark auf sich aufmerksam.",
						oPC, FALSE); break;
				case  3: FloatingTextStringOnCreature(
						"Immer h�ufiger schweifen Eure Gedanken zum leeren Gef�hl in der Magengegend.", oPC,
						FALSE); break;
				case  4: FloatingTextStringOnCreature("Ihr versp�rt schlicht und einfach Hunger.", oPC, FALSE);
					break;
				case  5: AssignCommand(oPC, SpeakString("*leis knurrend meldet sich der Magen*",
							TALKVOLUME_WHISPER)); break;
			}

			break;
		case 3:
			// Sehr starken Hunger
			switch ( iRandApp ) {
				case  1: FloatingTextStringOnCreature(
						"Ihr solltet schleunigst essen, Ihr droht zu verhungern!", oPC, FALSE); break;
				case  2: FloatingTextStringOnCreature(
						"Langsam zerrt der Hunger euch innerlich auf, Ihr solltet alsbald essen!", oPC, FALSE);
					break;
				case  3: FloatingTextStringOnCreature(
						"Ihr f�hlt Euch recht matt, als es Euren K�rper nach Nahrung verlangt!", oPC, FALSE);
					break;
				case  4: AssignCommand(oPC, SpeakString("*Es rummort h�rbar, offensichtlich vor Hunger*",
							TALKVOLUME_WHISPER)); break;
				case  5: AssignCommand(oPC, SpeakString("*Der Magen grummelt aufgebracht*", TALKVOLUME_TALK));
					break;
			}

			break;
		case 4:
			// Hungerschaden
			switch ( iRandApp ) {
				case  1:
					FloatingTextStringOnCreature(
						"Ihr f�hlt Euch immer schw�cher als Euer K�rper versucht mit dem Nahrungsentzug zurecht zu kommen.",
						oPC, FALSE);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_STRENGTH,
							Random(2) + 1), oPC, 900.0f);
					break;
				case  2:
					FloatingTextStringOnCreature(
						"Unzureichende Ern�hrung l�sst Euch die Hand nicht mehr sicher f�hren und Eure Finger zittern leicht.",
						oPC, FALSE);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_DEXTERITY,
							Random(2) + 1), oPC, 900.0f);
					break;
				case  3:
					FloatingTextStringOnCreature("Der Nahrungsentzug greift Euren K�rper an.", oPC, FALSE);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_CONSTITUTION,
							Random(2) + 1), oPC, 900.0f);
					break;
				case  4:
					FloatingTextStringOnCreature(
						"Durch mangelnde Ern�hrung fehlt Euch die Energie und ihr f�hlt Euch im Ganzen dadurch recht schlaff.",
						oPC, FALSE);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_CONSTITUTION,
							Random(2) + 1), oPC, 900.0f);
					break;
				case  5:
					FloatingTextStringOnCreature(
						"Durch mangelndes Essen, k�nnt ihr Eure Gedanken nun nicht mehr richtig lenken und das Konzentrieren f�llt schwer.",
						oPC, FALSE);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(ABILITY_INTELLIGENCE,
							Random(2) + 1), oPC, 900.0f);
					break;
			}

			break;
	}
}


void main() {
	object oPC = OBJECT_SELF;
	int iFood = GetLocalDecay(oPC, "Resting_Food");

	if ( !iFood ) {
		if ( d10() == 1 ) stomachStarvation(oPC, 4); // Hungerschaden
	} else if ( iFood < 20 ) {
		if ( d20() == 1 ) stomachStarvation(oPC, 3); // Sehr starken Hunger
	} else if ( iFood < 60 ) {
		if ( d20() == 1 ) stomachStarvation(oPC, 2); // Normal Hunger
	} else if ( iFood < 120 ) {
		if ( d20() == 1 ) stomachStarvation(oPC, 1); // Kaum Hunger
	}
}
