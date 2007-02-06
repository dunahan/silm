#include "inc_lists"
#include "inc_ip"

const string T = "hws_ip";

const int MOD = 100,
		  MAX_IP = 85;

void MkDialog(object oPC, object oItem);


void MkDialog(object oPC, object oItem) {
	SetLocalObject(oPC, "selected_ip_item", oItem);

	int iSel = GetLocalInt(oPC, T + "_sel");


	string sHeader =
		"Welcome to fourecks. Click an IP to remove it, or click [Add] to add. Working on(name:ref:tag): " +
		GetName(oItem) + ":" + GetResRef(oItem) + ":" + GetTag(oItem);

	// Build conversation tree


	ClearList(oPC, T);

	// no selection, main menue
	if ( 0 == iSel ) {
		DeleteLocalInt(oPC, "selected_ip");

		itemproperty loop = GetFirstItemProperty(oItem);
		int i = 0;
		while ( GetIsItemPropertyValid(loop) ) {

			int nType = GetItemPropertyType(loop);
			int nSubT = GetItemPropertySubType(loop);

			int bTemporary = GetItemPropertyDurationType(loop) == DURATION_TYPE_TEMPORARY;


			string sAdd = GetItemPropertyName(loop) +
						  " (" + IntToString(nType) + ") " + ( bTemporary ? "Temporary!" : "" );

			AddListItem(oPC, T, sAdd);

			SetListInt(oPC, T, i + MOD);
			loop = GetNextItemProperty(oItem);
		}

		AddListItem(oPC, T, "Add another IP");
		SetListInt(oPC, T, -1);
		ResetConvList(oPC, oPC, T, 50000, "craft_ip_cb", sHeader);

	} else if ( -1 == iSel ) {
		// Add a list of all ips
		AddListItem(oPC, T, "AC Bonus");
		SetListInt(oPC, T, 1);

		AddListItem(oPC, T, "Holy Avenger");
		SetListInt(oPC, T, 36);


	} else {
		// selected IP MOD + n
		sHeader = "Hm?";

		int nID = GetLocalInt(oPC, "selected_ip");
		if ( !nID ) {
			nID = GetListInt(oPC, T, GetLocalInt(oPC, "ConvList_Select"));
			SetLocalInt(oPC, "selected_ip", nID);
		}

		AddListItem(oPC, T, "Remove this IP");
		SetListInt(oPC, T, 1);
		ResetConvList(oPC, oPC, T, 50000, "craft_ip_cb", sHeader, "", "", "craft_ip_b2m",
			"Back to main listing");

	}




}
