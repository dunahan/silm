#include "inc_nwnx"
#include "inc_persist"
#include "inc_lists"

const int
CREATURE_WING_TYPE_AVARIEL = 15,
CREATURE_PART_WING = 1411,     // not taken :D
CREATURE_PART_TAIL = 1412;

string GetModelsIndex(object oPC) {
	string sInd = ( GetGender(oPC) == GENDER_FEMALE ) ? "f" : "m";
	int iAppearance = StringToInt(
		Get2DAString("racialtypes", "Appearance", GetRacialType(oPC)));

	sInd += GetStringLowerCase(
		Get2DAString("appearance", "RACE", iAppearance)) + "0";

	return sInd;
}

void SwitchSlot(object oPC, int iPart, int iDelta) {
	int iCurrent = GetCreatureBodyPart(iPart, oPC);
	if ( iPart == CREATURE_PART_WING )
		iCurrent = GetCreatureWingType(oPC);
	if ( iPart == CREATURE_PART_TAIL )
		iCurrent = GetCreatureTailType(oPC);

	int iOld = iCurrent;
	int iFieldEntry;

	/*SendMessageToPC(oPC,
	 * 	" - CREATURE_MODEL_TYPE_NONE = " + IntToString(CREATURE_MODEL_TYPE_NONE) +
	 * 	" - CREATURE_MODEL_TYPE_SKIN = " + IntToString(CREATURE_MODEL_TYPE_SKIN) +
	 * 	" - CREATURE_MODEL_TYPE_TATTOO = " + IntToString(CREATURE_MODEL_TYPE_TATTOO) +
	 * 	" - CREATURE_MODEL_TYPE_UNDEAD = " + IntToString(CREATURE_MODEL_TYPE_UNDEAD) +
	 * 	" - current = " + IntToString(iCurrent)
	 * );*/

	switch ( iPart ) {
		case CREATURE_PART_HEAD:
			iCurrent = StringToInt(Get2DAString("headmodels",
							   GetModelsIndex(oPC), iCurrent));
			if ( !iCurrent )
				iCurrent = 1;
			else {
				if ( iDelta < 0 )
					iCurrent = iCurrent / 256;
				else
					iCurrent = iCurrent % 256;
			}
			break;
		case CREATURE_PART_LEFT_FOREARM:
		case CREATURE_PART_RIGHT_FOREARM:
		case CREATURE_PART_LEFT_BICEP:
		case CREATURE_PART_RIGHT_BICEP:
		case CREATURE_PART_LEFT_SHIN:
		case CREATURE_PART_RIGHT_SHIN:
		case CREATURE_PART_LEFT_THIGH:
		case CREATURE_PART_RIGHT_THIGH:
		case CREATURE_PART_TORSO:
			iCurrent = ( iCurrent ==
						CREATURE_MODEL_TYPE_SKIN ? CREATURE_MODEL_TYPE_TATTOO : CREATURE_MODEL_TYPE_SKIN );
			break;

		case CREATURE_PART_WING:
			// 0 = none, 1 demon 2 angel 3 bat 4 dragon 5 butterfly 6 bird
			// 15 avariel
			iCurrent += iDelta;

			if ( iCurrent > 15 )
				iCurrent = 0;
			else if ( iCurrent > 6 )
				iCurrent = 15;
			else if ( iCurrent < 0 )
				iCurrent = 15;
			break;

		case CREATURE_PART_TAIL:
			iCurrent += iDelta;

			if ( iCurrent > 3 )
				iCurrent = 0;
			else if ( iCurrent < 0 )
				iCurrent = 3;
			break;
			/*
			 * case NWNX_BODYPART_COLOR_HAIR:
			 * case NWNX_BODYPART_COLOR_SKIN:
			 * case NWNX_BODYPART_COLOR_TATTOO_1:
			 * case NWNX_BODYPART_COLOR_TATTOO_2:
			 * iCurrent += iDelta;
			 * if(iCurrent < 0) iCurrent=63;
			 * else if(iCurrent > 63) iCurrent=0;
			 * break;
			 */
	}

	if ( iCurrent != iOld ) {
		SendMessageToPC(oPC, "Aktuelles Modell: " + IntToString(iCurrent));
		switch ( iPart ) {
			case CREATURE_PART_WING:
				SetCreatureWingType(iCurrent, oPC);
				break;
			case CREATURE_PART_TAIL:
				SetCreatureTailType(iCurrent, oPC);
				break;
			default:
				SetCreatureBodyPart(iPart, iCurrent, oPC);
				break;
		}

		//SafeSetBodyPart(oPC,iPart,iCurrent,TRUE);
		//Save_BodyPart(oPC,iPart);
	}
}

void MakeDialog(object oPC) {
	int iSelPart = GetLocalInt(oPC, "BODY_SEL_PART");

	if ( !iSelPart ) {
		ClearList(oPC, "body_sel_list");
		AddListItem(oPC, "body_sel_list", "Kopf");
		SetListInt(oPC, "body_sel_list", CREATURE_PART_HEAD);
		AddListItem(oPC, "body_sel_list", "Brustbereich");
		SetListInt(oPC, "body_sel_list", CREATURE_PART_TORSO);
		AddListItem(oPC, "body_sel_list", "Linker Oberarm");
		SetListInt(oPC, "body_sel_list", CREATURE_PART_LEFT_BICEP);
		AddListItem(oPC, "body_sel_list", "Linker Unterarm");
		SetListInt(oPC, "body_sel_list", CREATURE_PART_LEFT_FOREARM);
		AddListItem(oPC, "body_sel_list", "Linker Oberschenkel");
		SetListInt(oPC, "body_sel_list", CREATURE_PART_LEFT_THIGH);
		AddListItem(oPC, "body_sel_list", "Linkes Schienbein");
		SetListInt(oPC, "body_sel_list", CREATURE_PART_LEFT_SHIN);
		AddListItem(oPC, "body_sel_list", "Rechter Oberarm");
		SetListInt(oPC, "body_sel_list", CREATURE_PART_RIGHT_BICEP);
		AddListItem(oPC, "body_sel_list", "Rechter Unterarm");
		SetListInt(oPC, "body_sel_list", CREATURE_PART_RIGHT_FOREARM);
		AddListItem(oPC, "body_sel_list", "Rechter Oberschenkel");
		SetListInt(oPC, "body_sel_list", CREATURE_PART_RIGHT_THIGH);
		AddListItem(oPC, "body_sel_list", "Rechtes Schienbein");
		SetListInt(oPC, "body_sel_list", CREATURE_PART_RIGHT_SHIN);
		AddListItem(oPC, "body_sel_list", "Fluegel");
		SetListInt(oPC, "body_sel_list", CREATURE_PART_WING);
		AddListItem(oPC, "body_sel_list", "Schwanz");
		SetListInt(oPC, "body_sel_list", CREATURE_PART_TAIL);

		/*
		 * AddListItem(oPC,"body_sel_list","Hautfarbe");
		 * SetListInt(oPC,"body_sel_list",NWNX_BODYPART_COLOR_SKIN);
		 * AddListItem(oPC,"body_sel_list","Haarfarbe");
		 * SetListInt(oPC,"body_sel_list",NWNX_BODYPART_COLOR_HAIR);
		 * AddListItem(oPC,"body_sel_list","Taetowierung 1");
		 * SetListInt(oPC,"body_sel_list",NWNX_BODYPART_COLOR_TATTOO_1);
		 * AddListItem(oPC,"body_sel_list","Taetowierung 2");
		 * SetListInt(oPC,"body_sel_list",NWNX_BODYPART_COLOR_TATTOO_2);
		 */

		ResetConvList(oPC, oPC, "body_sel_list", 50000, "body_choose", "Was wollt Ihr nun aendern?");
	} else {
		ClearList(oPC, "body_sel_list");
		AddListItem(oPC, "body_sel_list", "Naechstes Modell");
		SetListInt(oPC, "body_sel_list", 1);
		AddListItem(oPC, "body_sel_list", "Voriges Modell");
		SetListInt(oPC, "body_sel_list", -1);
		ResetConvList(oPC, oPC, "body_sel_list", 50000, "body_choose", "Wie wollt Ihr es nun aendern?",
			"", "",
			"body_chgother", "Anderes Modell aendern");
	}
}








// void main() { }
