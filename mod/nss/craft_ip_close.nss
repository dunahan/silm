#include "inc_craft_ip"


void main() {
	object oPC = GetLastClosedBy();
	object oItem = GetFirstItemInInventory(OBJECT_SELF);

	if ( !GetIsObjectValid(oItem) ) {
		SpeakString("Bleeeerch.");
		return;
	}

	MkDialog(oPC, oItem);

	AssignCommand(oPC, ActionStartConversation(oPC, "list_select", TRUE, TRUE));
}



