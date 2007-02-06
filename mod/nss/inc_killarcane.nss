#include "inc_lists"
#include "_gen"

const string TT = "killarcane";


void KillArcane_BuildDialog(object oPC);



void RemoveArcaneBySpellID(object oPC, int nID);


void KillArcane_BuildDialog(object oPC) {
	ClearList(oPC, TT);

	int nSpellID = -1;
	string sSpellName = "";

	string sAllSpells = " ";

	effect e = GetFirstEffect(oPC);
	while ( GetIsEffectValid(e) ) {
		if ( GetEffectSubType(e) == SUBTYPE_MAGICAL && GetEffectType(e) != EFFECT_TYPE_VISUALEFFECT ) {
			nSpellID = GetEffectSpellId(e);
			if ( nSpellID != -1 && - 1 == FindSubString(sAllSpells, IntToString(nSpellID)) ) {
				sSpellName = GetSpellName(nSpellID);
				sAllSpells += IntToString(nSpellID) + " ";
				AddListItem(oPC, TT, sSpellName);
				SetListInt(oPC, TT, nSpellID);
			}
		}
		e = GetNextEffect(oPC);
	}

	string sHeader = "Zu entfernende Arkane waehlen.";

	ResetConvList(oPC, oPC, TT, 50000, "cb_killarcane", sHeader);
}


void RemoveArcaneBySpellID(object oPC, int nID) {
	int nSpellID;
	effect e = GetFirstEffect(oPC);
	while ( GetIsEffectValid(e) ) {
		if ( GetEffectSubType(e) == SUBTYPE_MAGICAL && GetEffectType(e) != EFFECT_TYPE_VISUALEFFECT ) {
			nSpellID = GetEffectSpellId(e);
			if ( nSpellID != -1 && nSpellID == nID ) {
				SendMessageToPC(oPC, "Removing effect ID " + IntToString(nID));
				RemoveEffect(oPC, e);
				break;
			}
		}
		e = GetNextEffect(oPC);
	}

}
