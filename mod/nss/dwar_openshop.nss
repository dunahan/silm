//::///////////////////////////////////////////////
//:: FileName dwar_openshop
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 03.08.2005 11:41:13
//:://////////////////////////////////////////////
#include "nw_i0_plot"

void main() {

	// Entweder Gesch�ft mit dieser Kennzeichnung �ffnen, oder den Nutzer wissen lassen, dass kein Gesch�ft vorhanden ist.
	object oStore = GetNearestObjectByTag("dwar_shop001");
	if ( GetObjectType(oStore) == OBJECT_TYPE_STORE )
		gplotAppraiseOpenStore(oStore, GetPCSpeaker());
	else
		ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
