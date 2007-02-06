#include "inc_craft_ip"


void main() {
	object
	oPC = GetLocalObject(OBJECT_SELF, "ConvList_PC");
	object
	oItem = GetLocalObject(oPC, "selected_ip_item");

	int iSelPart = GetLocalInt(oPC, T + "_sel"),
		iSelection = GetLocalInt(oPC, "ConvList_Select");

	iSelection = GetListInt(oPC, T, iSelection);


	// in IP?
	if ( iSelPart > 0 ) {

		int nID = GetLocalInt(oPC, "selected_ip");
		int i = 0, nType, nSubT, bTemporary;
		itemproperty loop;

		// listen for sub-options
		switch ( iSelection ) {
			case 1:
				// remove IP: nID

				loop = GetFirstItemProperty(oItem);

				while ( GetIsItemPropertyValid(loop) ) {

					nType = GetItemPropertyType(loop);
					nSubT = GetItemPropertySubType(loop);

					bTemporary = GetItemPropertyDurationType(loop);

					if ( nID == i ) {
						RemoveItemProperty(oItem, loop);
						break;
					}

					loop = GetNextItemProperty(oItem);
				}

				break;

			default:
				SendMessageToPC(oPC, "Unbekannte Option.");
				break;
		}

	} else if ( iSelPart == -1 ) {
		// add IP: iSelection

	} else {
		// Woah. Back to menue.
		SetLocalInt(oPC, T + "_sel", iSelection);
	}


}
