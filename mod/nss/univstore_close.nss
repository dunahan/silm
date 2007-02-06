#include "_gen"
#include "inc_univstore"

void ClearInventory(object oInventory);


void ClearInventory(object oInventory) {
	object oItem = GetFirstItemInInventory(oInventory);
	while ( GetIsObjectValid(oItem) ) {
		DestroyObject(oItem);
		oItem = GetNextItemInInventory(oInventory);
	}
}

void main() {
	object oPC = GetLastClosedBy();

	string sChestId = GetLocalString(OBJECT_SELF, "store_tag");

	if ( sChestId == "" ) {
		SendMessageToAllDMs("Warning: Container " +
			GetName(OBJECT_SELF) +
			" in " +
			LocationToStringPrintable(GetLocation(OBJECT_SELF)) +
			" has no valid ChestId. Set the local string 'store_tag'.");
		return;
	}

	//Wenn der Inhalt der Truhe veraendert wurde
	if ( GetLocalInt(OBJECT_SELF, "bDisturbed") == TRUE ) {

		UnivStore_ClearStore(OBJECT_SELF);

		object oItem = GetFirstItemInInventory(OBJECT_SELF);
		while ( GetIsObjectValid(oItem) ) {

			UnivStore_StoreItem(OBJECT_SELF, oPC, oItem);

			oItem = GetNextItemInInventory(OBJECT_SELF);
		}

		SetLocalInt(OBJECT_SELF, "bDisturbed", FALSE);
	}  // bDisturbed?

	SendMessageToPC(oPC, "Ladung/Kapazitaet: " +
		IntToString(GetTotalContainerItemSizeSum(OBJECT_SELF)) +
		"/" + IntToString(UnivStore_GetCapacity(OBJECT_SELF)));

	ClearInventory(OBJECT_SELF);

	string sConv = GetLocalString(OBJECT_SELF, "store_conv_close");
	if ( "" != sConv )
		ActionStartConversation(oPC, sConv, TRUE, FALSE);


	//Truhe abschlie�en w�hrend Inhalt gel�scht wird
	SetLocked(OBJECT_SELF, TRUE);
	DelayCommand(3.0f, SetLocked(OBJECT_SELF, FALSE));

	SetLocalInt(OBJECT_SELF, "bChestOpen", FALSE);
	SetLocalObject(OBJECT_SELF, "oChestUser", OBJECT_INVALID);
}
