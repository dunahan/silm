/*
 * inc_summon
 *
 * Idea based on the Ogi-Yun summoning system as depicted in the module
 * 'Kiss Of Fate' (to be found on NWVault)
 *
 * Rewritten from scratch by Narron (Carsten Pluntke)
 */

#include "inc_nwnx"
#include "inc_debug"

/*
 * Returns 0 - no valid card
 *         5 - new syntax
 *         9 - old syntax
 * Number means index into object tag for level number
 */
int GetCardType(object oCard) {
	string sPref;
	string sTag = GetTag(oCard);
	if ( GetStringLeft(sTag, 9) == "SUM_CARD_" ) return 9;

	sPref = GetStringLeft(sTag, 5);
	return ( sPref == "CWIZ_" ) || ( sPref == "CDRU_" )
		   || ( sPref == "CALL_" ) || ( sPref == "CCST_" )
		   || ( sPref == "CSPC_" ) ? 5 : 0;
}

string GetCardClass(object oCard) {
	int iCT = GetCardType(oCard);
	if ( iCT == 0 ) return "";

	if ( iCT == 9 ) return "CALL_";

	return GetStringLeft(GetTag(oCard), 5);
}

/*
 * Returns 0 - as magic as a loaf of bread
 *         1 - arcane spell user
 *         2 - cleric spell user
 *         4 - druidic spell user
 *     ... and bitwise combinations thereof
 */

int DetermineClassStructure(object oPC) {
	int iCS = 0;
	if ( GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0 ) iCS |= 4;
	if ( GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0 ) iCS |= 4;
	if ( GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0 ) iCS |= 2;
	if ( GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > 0 ) iCS |= 2;
	if ( GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0 ) iCS |= 1;
	if ( GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0 ) iCS |= 1;
	if ( GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0 ) iCS |= 1;
	return iCS;
}


int IsValidCard(object oCard, int iCS) {
	string sPref = GetCardClass(oCard);
	if ( sPref == "" ) return FALSE;

	if ( sPref == "CDRU_" && ( iCS & 4 ) == 0 ) return FALSE;

	if ( sPref == "CWIZ_" && ( iCS & 3 ) == 0 ) return FALSE;

	return TRUE;
}

int GetCardLevel(object oCard) {
	return StringToInt(
			   GetSubString(GetTag(oCard), GetCardType(oCard), 1));
}

string GetCardMonster(object oCard) {
	return GetStringLowerCase(
			   GetSubString(GetTag(oCard), GetCardType(oCard) + 2, 16));
}

// summarize the cards in the player's possession, up to the given level
int SummarizeCards(object oPC, int iMaxLevel) {
	int iNumCards = 0;
	int iCurrentLevel = -1;
	object oItem;
	object oBag;
	int iCS = DetermineClassStructure(oPC);

	//Take the cards in the card bag in consideration; if PC doesn't
	//possess a card bag, scan the player's inventory (including all other
	//bags)
	if ( !GetIsObjectValid(oBag = GetItemPossessedBy(oPC, "SUM_CARDBAG")) )
		oBag = oPC;

	oItem = GetFirstItemInInventory(oBag);
	while ( GetIsObjectValid(oItem) ) {
		if ( IsValidCard(oItem, iCS) ) {
			int iCardLevel = GetCardLevel(oItem);
			if ( iCardLevel <= iMaxLevel ) {
				if ( iCardLevel > iCurrentLevel ) {
					// Found a higher levelled card than those so far, begin new list
					iCurrentLevel = iCardLevel;
					iNumCards = 0;
				}
				if ( iCardLevel == iCurrentLevel )
					SetLocalObject(oPC, "SUM_CARD_" + IntToString(iNumCards++), oItem);
			}
		}
		oItem = GetNextItemInInventory(oBag);
	}
	return iNumCards;
}

//Pick one of the highest cards in the selection, up to iMaxLevel
//including
object PickCard(object oPC, int iMaxLevel, int iReturnBlanks = FALSE) {
	int iNumCards = SummarizeCards(oPC, iMaxLevel);
	object oCard;

	if ( !iNumCards ) {
		return OBJECT_INVALID;
	}

	oCard = GetLocalObject(oPC, "SUM_CARD_" + IntToString(Random(iNumCards)));

	//Drew a blank, ditch selection if unwanted
	if ( !iReturnBlanks && !GetCardLevel(oCard) ) {
		return OBJECT_INVALID;
	}

	return oCard;
}

//Creatures which are no PCs or DMs and don't belong to the goodly races
//are valid captures
int GetValidCapture(object oCreature) {
	int iRT = GetRacialType(oCreature);
	if ( GetIsPC(oCreature) || GetIsDM(oCreature) ) return FALSE;

	if ( GetPlotFlag(oCreature) || GetLocalInt(oCreature, "PLOT_FLAG") ) return FALSE;

	if ( Get2DAString("racialtypes", "PlayerRace", iRT) != "0" ) return FALSE;

	return TRUE;
}

//Imprint one of the PC's blank cards with the spirit of the given creature,
//return the new card object of successful.
object ImprintCard(object oPC, object oCreature) {
	object oCard;
	object oCard2;
	int iCrLevel;

	if ( !GetValidCapture(oCreature) ) return OBJECT_INVALID;

	//Fail if there is no empty card in the player's stash
	if ( !GetIsObjectValid(oCard = PickCard(oPC, 0, TRUE)) )
		return OBJECT_INVALID;

	iCrLevel = FloatToInt(GetChallengeRating(oCreature) + 0.5f);
	if ( GetHitDice(oCreature) > iCrLevel )
		iCrLevel = GetHitDice(oCreature);
	iCrLevel = ( iCrLevel + 2 ) / 2;
	if ( iCrLevel < 1 ) iCrLevel = 1;
	else if ( iCrLevel > 9 ) iCrLevel = 9;

	DestroyObject(oCard);
	//Create a new card with the correct creature summoning level
	oCard = CreateItemOnObject("sum_cardf00" + IntToString(iCrLevel), oPC);

	oCard2 = CopyObject(oCard, GetLocation(oPC), oPC, "CCST_" +
				 IntToString(iCrLevel) + "_" + GetResRef(oCreature));
	DestroyObject(oCard);
	oCard = oCard2;

	/*SetDescription(oCard,
	 * "Diese ehemals leere Karte beinhaltet einen "+GetName(oCreature)+"-Geist. "+
	 * "Man kann diese Kart nun direkt benutzen, um die gebundene Kreatur zu beschwoeren oder "+
	 * "implizit, indem man sie in die Kartentasche steckt und einen Beschwoerungszauber spricht.");*/
	return oCard;
}

//Get the calculation level of the summoning spell
int GetSpellLevel(int nSpell) {
	switch ( nSpell ) {
		case SPELL_SUMMON_CREATURE_I:
			return 1;

		case SPELL_SUMMON_CREATURE_II:
			return 2;

		case SPELL_SUMMON_CREATURE_III:
			return 3;

		case SPELL_SUMMON_CREATURE_IV:
			return 4;

		case SPELL_SUMMON_CREATURE_V:
			return 5;

		case SPELL_SUMMON_CREATURE_VI:
			return 6;

		case SPELL_SUMMON_CREATURE_VII:
			return 7;

		case SPELL_SUMMON_CREATURE_VIII:
			return 8;

		case SPELL_SUMMON_CREATURE_IX:
			return 9;
	}

	return 0;
}

//Get the summoning spell corresponding to the caster level
int GetSpellForLevel(int iLevel) {
	switch ( iLevel ) {
		case 1:
			return SPELL_SUMMON_CREATURE_I;

		case 2:
			return SPELL_SUMMON_CREATURE_II;

		case 3:
			return SPELL_SUMMON_CREATURE_III;

		case 4:
			return SPELL_SUMMON_CREATURE_IV;

		case 5:
			return SPELL_SUMMON_CREATURE_V;

		case 6:
			return SPELL_SUMMON_CREATURE_VI;

		case 7:
			return SPELL_SUMMON_CREATURE_VII;

		case 8:
			return SPELL_SUMMON_CREATURE_VIII;

		case 9:
			return SPELL_SUMMON_CREATURE_IX;
	}

	return -1;
}

int GetEffectiveSummLevel(object oPC, int iSpell) {
	int iLevel = GetSpellLevel(iSpell);
	if ( GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER, oPC) ) iLevel++;

	if ( iLevel < 1 ) iLevel = 1;
	else if ( iLevel > 9 ) iLevel = 9;

	return iLevel;
}

//Returns the summoned creature resref of the appropiate level and
//prerequisites
string GetSummoningCreature(object oPC, int nSpell) {
	int iLevel = GetEffectiveSummLevel(oPC, nSpell);
	string sResRef;
	object oCard;

	//Found appropriate card, done here.
	if ( GetIsObjectValid(oCard = PickCard(oPC, iLevel)) ) {
		return GetCardMonster(oCard);
	} else {
		string sSummon = "";
		if ( !GetIsPC(oPC) || GetIsDMPossessed(oPC) ) {
			if ( GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD ) {
				switch ( iLevel ) {
					case 1:
						sSummon = "celestischerhund"; break;
					case 2:
						sSummon = "celestischeradle"; break;
					case 3:
						sSummon = "celestischerschw"; break;
					case 4:
						sSummon = "leuchtenderarcho"; break;
					case 5:
						sSummon = "celestischerbrau"; break;
					case 6:
						sSummon = "bralani"; break;
					case 7:
						sSummon = "djinni"; break;
				}
			} else {
				switch ( iLevel ) {
					case 1:
						sSummon = "scheusalhafterra"; break;
					case 2:
						sSummon = "scheusalhaftemit"; break;
					case 3:
						sSummon = "scheusalhaftegro"; break;
					case 4:
						sSummon = "scheusalhaftersc"; break;
					case 5:
						sSummon = "scheusalhafte003"; break;
					case 6:
						sSummon = "scheusalhafterie"; break;
					case 7:
						sSummon = "unsichtbarerpirs"; break;
				}
			}
		}
		return sSummon;
	}
}

//Return the number of the visual eye candy effect
int GetSummonEffect(object oPC, int nSpell) {
	int iLevel = GetEffectiveSummLevel(oPC, nSpell);

	if ( iLevel > 6 ) return VFX_FNF_SUMMON_MONSTER_3;

	if ( iLevel > 3 ) return VFX_FNF_SUMMON_MONSTER_2;

	return VFX_FNF_SUMMON_MONSTER_1;
}

// Card of given level activated, determine which spell is best to use
int GetBestSummoningSpell(object oPC, int iTargetedLevel) {
	int i;

	//Be on the safe side: Search from targeted level up
	for ( i = iTargetedLevel; i < 10; i++ ) {
		int iSpell = GetSpellForLevel(i);
		if ( GetHasSpell(iSpell, oPC) ) return iSpell;
	}
	//Getting dangerous: Search from targeted level downwards
	for ( i = iTargetedLevel; i > 0; i-- ) {
		int iSpell = GetSpellForLevel(i);
		if ( GetHasSpell(iSpell, oPC) ) return iSpell;
	}
	//Has no summoning spells at all!
	return -1;
}

void _Post_Summoning(object oPC) {
	object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
	object oItem = GetFirstItemInInventory(oSummon);

	while ( GetIsObjectValid(oItem) ) {
		SetDroppableFlag(oItem, FALSE);
		oItem = GetNextItemInInventory(oSummon);
	}
	SetLocalObject(oSummon, "SUM_MASTER", oPC);
	SetLocalInt(oSummon, "SHOULD_FOLLOW", 1);
	SetLocalInt(oSummon, "SHOULD_FIGHT", 2);
//  ChangeToStandardFaction(oPC,STANDARD_FACTION_DEFENDER);
}

void DoSummonCreature(object oPC, location lLocation, float fDuration, int iSummonEffect, string sCreature) {

	AssignCommand(oPC,
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
			EffectSummonCreature(sCreature, iSummonEffect),
			lLocation, fDuration));
/*
 * AssignCommand(GetModule(),
 * 	ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
 * 	  EffectSummonCreature(sCreature,iSummonEffect),
 * 	  oPC,fDuration));
 */
	DelayCommand(1.0f, _Post_Summoning(oPC));
}

void SummonPerCard(object oPC, object oCard, location lLocation) {
	int iLevel = GetCardLevel(oCard);
	string sSummon = GetCardMonster(oCard);
	int iBestSpell = GetBestSummoningSpell(oPC, iLevel);
	int iDelta;

	if ( iBestSpell < 0 ) {
		FloatingTextStringOnCreature("Man muss einen Herbeirufungszauber kennen.", oPC, FALSE);
		return;
	}

	int iSPL = GetSpellLevel(iBestSpell);
	float fDuration = ( GetCardClass(oCard) == "CSPC_" )
					  ? HoursToSeconds(24)
					  : IntToFloat(iSPL) * 600.0;

	iDelta = iLevel - iSPL;

	DecrementRemainingSpellUses(oPC, iBestSpell);

	if ( iDelta > 0 ) {
		int iEff = Random(iDelta + 2);

		if ( iEff ) {
			if ( iEff < 3 ) {
				FloatingTextStringOnCreature("Nichts passiert.", oPC, FALSE);
			} else if ( iEff < 7 ) {
				object oCreat;

				FloatingTextStringOnCreature("Die beschworene Kreatur wendet sich gegen Euch!", oPC);
				oCreat = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetLocation(oPC));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1),
					oCreat);
				ChangeToStandardFaction(oCreat, STANDARD_FACTION_HOSTILE);
			} else {
				FloatingTextStringOnCreature("Die Karte explodiert!", oPC, FALSE);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(iEff)), oPC);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIREBALL), oPC);
			}
		}
		DestroyObject(oCard);
		return;
	}

	DoSummonCreature(oPC, lLocation, fDuration,
		GetSummonEffect(oPC, iBestSpell),
		sSummon);
	if ( iDelta > 0 ) DestroyObject(oCard);
}

int ActivateSummonItem(object oPC, object oItem, location lTarget, object oTarget) {
	if ( !IsValidCard(oItem, DetermineClassStructure(oPC)) ) return 0;

	SummonPerCard(oPC, oItem, lTarget);
	return 1;
}
