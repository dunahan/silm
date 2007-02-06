/*
 * Activation routines for miscellaneous items which don't fit in
 * either category and are not elaborate enough to make up one of their own
 */

#include "NW_I0_GENERIC"
#include "inc_decay"
#include "inc_healerkit"
#include "inc_kjcurse"
#include "inc_keystone"
#include "inc_horse"
#include "inc_craft"
#include "inc_craft_hlp"
#include "inc_dbook"

#include "inc_cdb"


void _BuildTent(object oItem, object oPC, location lTarget) {
	CreateObject(OBJECT_TYPE_PLACEABLE, "zelt", lTarget);
	DestroyObject(oItem);
}



int ActivateMiscItem(object oPC, object oItem, location lTarget, object oTarget) {
	string sTag = GetTag(oItem);
	string sName = GetName(oItem);
//SendMessageToPC(oPC, sTag);

	if ( sTag == "blauerknallfrosc" ) {
		DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH,
					TRUE), lTarget));
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_HIT_FROST, TRUE), lTarget);
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_L, TRUE), lTarget);
	}

	if ( sTag == "roterknallfrosch" ) {
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_FIRE, TRUE),
			lTarget);
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_MIND, TRUE),
			lTarget);
	}

	if ( sTag == "gruenerknallfros" ) {
		DelayCommand(0.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(
					VFX_FNF_GAS_EXPLOSION_FIRE, FALSE), lTarget));
		DelayCommand(0.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH,
					FALSE), lTarget));
	}

	if ( sTag == "pinkerknallfrosc" ) {
		DelayCommand(0.1, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM),
				lTarget));
		DelayCommand(0.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN),
				lTarget));
		DelayCommand(0.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DESTRUCTION),
				lTarget));
		DelayCommand(0.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_S),
				lTarget));
	}


	if ( sTag == "heiligerknallfro" ) {
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID, TRUE), lTarget);
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_HIT_DIVINE, TRUE), lTarget);
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_BEAM_FIRE_LASH, FALSE), lTarget);
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE, FALSE), lTarget);
	}


//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
// Zelt aufbauen
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
	if ( sTag == "Zelt" ) {
		AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0f, 20.0f));
		AssignCommand(oPC, ActionDoCommand(_BuildTent(oItem, oPC, lTarget)));
		return 1;
	}
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----



//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
// Besondere "verfluchte" Speisen
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
	if ( sTag == "FOOD_curse01" ) {
		DestroyObject(oItem);
		DelayCommand(1.0f, AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_DRINK, 1.0f, 5.0f)));
		DelayCommand(2.0f, FloatingTextStringOnCreature("Das war lecker.", oPC, FALSE));
		changeGender(oPC);
		return 1;
	}

	if ( sTag == "FOOD_curse02" ) {
		DestroyObject(oItem);
		DelayCommand(1.0f, AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_DRINK, 1.0f, 5.0f)));
		DelayCommand(2.0f, FloatingTextStringOnCreature("Das war lecker.", oPC, FALSE));
		restoreGender(oPC);
		return 1;
	}

	if ( sTag == "FOOD_curse03" ) {
		DestroyObject(oItem);
		FloatingTextStringOnCreature("Das war lecker.", oPC, FALSE);
		DelayCommand(30.0, giggleCurse(oPC));
		return 1;
	}

	if ( sTag == "FOOD_curse04" ) {
		DestroyObject(oItem);
		FloatingTextStringOnCreature("Das war lecker.", oPC, FALSE);
		SetLocalDecay(oPC, "Resting_Food", 0, 60);
		return 1;
	}
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----



//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
// Essen verspeisen
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
	if ( GetStringLeft(sTag, 5) == "FOOD_" ) {
		int iDuration = 60;
		int iStomach = GetLocalDecay(oPC, "Resting_Food");

		if ( GetStringLength(sTag) > 12 )
			iDuration = StringToInt(GetStringRight(sTag, 3));

		//Last adjustments: Prolong duration up to 150% as given
		iDuration += iDuration / 2;
		//FloatingTextStringOnCreature("Hunger: " + IntToString(iStomach) + " / Nahrung: "+ IntToString(iDuration),oPC);
		//Last adjustments: Stomach can hold 13.5 hours of food
		//(11.5 hours without disturbance)
		//A whole cake yields 12 hours of food.
		if ( iStomach + iDuration > 1510 ) {
			FloatingTextStringOnCreature(
				"Das ist viel zu m�chtig! Vielleicht etwas leichteres ?", oPC, FALSE);
			return 1;
		}

		DestroyObject(oItem);
		SetLocalDecay(oPC, "Resting_Food", iDuration + iStomach, 60);


		// Gekochte Speisen
		if ( GetSubString(sTag, 5, 3) == "COK" ) {
			FloatingTextStringOnCreature("Das war lecker.", oPC, FALSE);
			return 1;
		}


		// Rohe Speisen
		if ( GetSubString(sTag, 5, 3) == "RAW" ) {
			if ( d10() == 1 ) {
				FloatingTextStringOnCreature("Rohe Nahrungsmittel bergen immer eine Infektionsgefahr.", oPC,
					FALSE);
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDisease(DISEASE_FILTH_FEVER), oPC);
				return 1;
			}
			FloatingTextStringOnCreature("Igitt. Kochen w�re wohl nicht schlecht gewesen.", oPC, FALSE);
			return 1;
		}
	}

	// Getraenke
	if ( GetSubString(sTag, 5, 3) == "LIQ" ) {
		DelayCommand(1.0f, AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_DRINK, 1.0f, 5.0f)));
		DelayCommand(2.0f, FloatingTextStringOnCreature("Das war lecker.", oPC, FALSE));
		//Create an empty milk bottle / water bottle in exchange for the one just downed.
		if ( sTag == "FOOD_LIQ_x00_060" || sTag == "FOOD_LIQ_997_060" ) {
			CreateItemOnObject("milkbottle_empty", oPC);
			if ( d20() == 1 )
				hiccupCurse(oPC);
		}
		if ( sTag == "FOOD_LIQ_000_060" ) {
			CreateItemOnObject("waterbot_empty", oPC);
			if ( d20() == 1 )
				hiccupCurse(oPC);
		}
		return 1;
	}

//----- ----- ----- ----- ----- ----- ----- ----- ----- -----



//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
// Angel auswerfen und fischen
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
	if ( sTag == "FishingRod" ) {
		ExecuteScript("fish_doit", oPC);
		return 1;
	}
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----



//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
// leere Wasserflasche an Wasserstelle auff�llen
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
	if ( sTag == "waterbot_empty" ) {
		object oArea = GetArea(oPC);
		object oTrig = GetFirstObjectInArea(oArea);
		while ( GetIsObjectValid(oTrig) ) {
			if ( GetTag(oTrig) == "FishingPlace" && GetIsInSubArea(oPC, oTrig) )
				break;
			oTrig = GetNextObjectInArea(oArea);
		}

		if ( !GetIsObjectValid(oTrig) ) {
			FloatingTextStringOnCreature("Das ist keine gute Stelle um eure Wasserflasche nachzuf�llen.",
				OBJECT_SELF, FALSE);
			return 1;
		}

		FloatingTextStringOnCreature("Ihr tretet n�her an den Wasserlauf und f�llt eure Flasche.", oPC, FALSE);
		AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0f, 4.0f));
		CreateItemOnObject("food_cok_000_060", oPC);
		DestroyObject(oItem);
		return 1;
	}
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----



//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
// leere Milchflasche mit Melken auff�llen
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
	if ( GetStringLowerCase(sTag) == "milkbottle_empty" ) {
		int iMilkCounter;

		if ( GetTag(oTarget) != "MILK_COW"
			&& GetTag(oTarget) != "NW_COW" ) {
			FloatingTextStringOnCreature("Es muss schon eine Kuh sein, die man melken will.", oPC, FALSE);
			return 1;
		}
		if ( GetDistanceBetween(oPC, oTarget) > 3.0f ) {
			FloatingTextStringOnCreature("Man muss an das Tier schon n�her herangehen.", oPC, FALSE);
			return 1;
		}

		iMilkCounter = GetLocalDecay(oTarget, "Milk_Counter");
		if ( iMilkCounter > 240 ) {
			FloatingTextStringOnCreature("Die Kuh ist im Moment leergemolken.", oPC, FALSE);
			return 1;
		}

		FloatingTextStringOnCreature("Ihr melkt die Kuh.", oPC, FALSE);
		AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0f, 5.0f));
		SetLocalDecay(oTarget, "Milk_Counter", iMilkCounter + 60, 60);
		CreateItemOnObject("food_cok_997", oPC);
		DestroyObject(oItem);
		return 1;
	}
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----



//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
// Zunder f�r Feuerstelle
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
	if ( sTag == "TMS_TINDER" ) {
		CreateObject(OBJECT_TYPE_PLACEABLE, "tms_pl_fire1", GetLocation(oPC));
		DelayCommand(1.0f, RecomputeStaticLighting(GetArea(oPC)));
		return 1;
	}
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----



//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
// Heiltasche
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
	if ( GetStringLeft(sTag, 10) == "HealerKit_" ) {
		UseHealerKit(oPC, oTarget, oItem);
		return 1;
	}
	if ( sTag == "Bandage" ) {
		AddBandage(oPC, oTarget, oItem);
		return 1;
	}
	if ( sTag == "Medicine" ) {
		AddMedicine(oPC, oTarget, oItem);
		return 1;
	}
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----

//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
// Zugangssteine
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----

	if ( GetStringRight(sTag, 9) == "_keystone" ) {
		UseKeyStone(oPC, oTarget, oItem);
		return 1;
	}
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----

//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
// Nishunes Spiegel der Offenbarung
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----

	if ( sTag == "spiegel_offenbarung" ) {
		//SendMessageToPC(oPC, "Die Nebel im Spiegel lften sich langsam und formen ein klares Bildnis");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_WISDOM, 5), oPC, 3600.0);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROT_PREMONITION), oPC,
			3600.0);
		return 1;
	}
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----

//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
// Flagge
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----

	if ( sTag == "flag_legion" ) {
		effect eFlag = EffectVisualEffect(VFX_DUR_FLAG_BLUE);
		if ( GetLocalInt(oPC, "Flag") == 1 ) {
			RemoveEffect(oPC, eFlag);
			DeleteLocalInt(oPC, "Flag");
		} else {
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFlag, oPC);
			SetLocalInt(oPC, "Flag", 1);
		}
		return 1;
	}
	if ( sTag == "flag_gabel" ) {
		effect eFlag = EffectVisualEffect(VFX_DUR_FLAG_GOLD_FIXED);
		if ( GetLocalInt(oPC, "Flag") == 1 ) {
			RemoveEffect(oPC, eFlag);
			DeleteLocalInt(oPC, "Flag");
		} else {
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFlag, oPC);
			SetLocalInt(oPC, "Flag", 1);
		}
		return 1;
	}

//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
// Sattel zum reiten benutzen auteigen / absteigen
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----

	if ( sTag == "itm_sattel" ) {
		int iPheno = GetPhenoType(oPC);

		if ( iPheno != PHENOTYPE_NORMAL && iPheno != PHENOTYPE_BIG )
			unmountHorse(oPC);
		else if ( oTarget != oPC )
			mountHorse(oPC, oTarget);
		return 1;
	}

//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
// Crafting System Plaene / Komponenten und Buecher
//----- ----- ----- ----- ----- ----- ----- ----- ----- -----

	/*if(GetStringLeft(sTag, 5) == "komp_")
	 * {
	 * AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID));
	 * CombinateItems(oPC, oItem, oTarget);
	 * }*/

	if ( "cp_basic" == sTag ) {
		int csk = GetLocalInt(oItem, "craft");
		int recipe = GetLocalInt(oItem, "craft_recipe");
		int nCID = GetCharacterID(oPC);

		string sCraftTag = GetCraftTagByCraftSkill(csk);

		if ( sCraftTag == "" ) {
			SendMessageToPC(oPC, "Bug.  Craft (" + IntToString(csk) + ") nicht in DB eingetragen.  Sorry.");

		} else if ( !GetIsObjectValid(GetItemPossessedBy(oPC, "dbook_" + sCraftTag)) ) {

			Notify(MSG_CRAFT_NEED_BOOK_TO_SCRIBE, oPC);
		} else {

			// Is it already in there?
			SQLQuery("select count(`id`) from `" +
				TABLE_RCPBOOK +
				"` where `character` = " +
				IntToString(nCID) +
				" and `cskill` = " +
				IntToString(csk) + " and `recipe` = " + IntToString(recipe) + " limit 1;");
			SQLFetch();
			if ( SQLGetData(1) == "1" ) {
				Notify(MSG_CRAFT_BOOK_HAS_RECIPE, oPC);
			} else {
				SQLQuery("insert into `" +
					TABLE_RCPBOOK +
					"` (`character`,`cskill`,`recipe`) values(" +
					IntToString(nCID) + ", " + IntToString(csk) + ", " + IntToString(recipe) + ");");

				AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));

				Notify(MSG_CRAFT_BOOK_RECIPE_ADDED, oPC);
				DestroyObject(oItem);
			}
		}
		return 1;
	}


	if ( GetStringLeft(sTag, 6) == "dbook_" ) {
		DBook_Start(oPC, oItem);
		return 1;
	}

	if ( GetStringLeft(sTag, 5) == "book_" ) {
		int nCount = GetCraftCount(oPC);
		if ( nCount >= 2 ) {
			Floaty("Ihr koennt keinen weiteren Beruf mehr erlernen.", oPC, 0);
		} else {

			AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));

			int nCSkill = GetLocalInt(oItem, "craft");
			if ( nCSkill != 0 ) {
				int ret = DoCraftLearnBasicStuff(oPC, nCSkill);
				if ( ret ) {
					SendMessageToPC(oPC, "Sie erlernen folgende Grundlagen: " + sName);
				} else {
					SendMessageToPC(oPC, "Aus diesem Buch koennen sie nichts mehr erlernen.");
				}
			}
		}
		return 1;
	}

//----- ----- ----- ----- ----- ----- ----- ----- ----- -----
	return 0;
}





