//::///////////////////////////////////////////////
//:: FileName opendwarshop002
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 21.12.2005 19:55:38
//:://////////////////////////////////////////////
#include "nw_i0_plot"

void main() {

	// Entweder Gesch�ft mit dieser Kennzeichnung �ffnen, oder den Nutzer wissen lassen, dass kein Gesch�ft vorhanden ist.
	object oStore = GetNearestObjectByTag("dwar_shop002");
	if ( GetObjectType(oStore) == OBJECT_TYPE_STORE )
		gplotAppraiseOpenStore(oStore, GetPCSpeaker());
	else
		ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
