#include "_gen"
#include "inc_univstore"


void main() {
	//int nItemCountMax = 50;//Maximale Kapazitaet der Truhe

	object oPC = GetLastDisturbed();
	object oDisturbItem = GetInventoryDisturbItem();
	int nDisturbType = GetInventoryDisturbType();
	object oChest = OBJECT_SELF;
	object oChestUser = GetLocalObject(OBJECT_SELF, "oChestUser");

	int nCount = GetLocalInt(OBJECT_SELF, "itemCount");

	//Wenn nicht richtiger Benutzer: Aktion rueckgaenig machen
	if ( oPC != oChestUser ) {
		if ( nDisturbType == INVENTORY_DISTURB_TYPE_ADDED ) {
			SendMessageToPC(oPC, "Jemand anders benutzt dieses Behaeltnis. Wartet bitte.");
			ActionGiveItem(oDisturbItem, oPC);
		} else if ( nDisturbType == INVENTORY_DISTURB_TYPE_REMOVED
				   || nDisturbType == INVENTORY_DISTURB_TYPE_STOLEN ) {
			SendMessageToPC(oPC,
				"Jemand anders benutzt diese Truhe. Ihr k�nnt diesen Gegenstand nicht nehmen.");
			ActionTakeItem(oDisturbItem, oPC);
		}
		return;
	}

	//Gegenstand wurde reingelegt
	if ( nDisturbType == INVENTORY_DISTURB_TYPE_ADDED ) {

		if ( GetTotalContainerItemSizeSum(OBJECT_SELF) > UnivStore_GetCapacity(OBJECT_SELF) ) {
			SendMessageToPC(oPC, "Dieser Gegenstand passt hier nun beim besten Willen nicht rein.");
			ActionGiveItem(oDisturbItem, oPC);
			return;
		}


		if ( ( IntToFloat(GetWeight(oDisturbItem)) / 10.0 ) >= UnivStore_GetMaxWeight(OBJECT_SELF) ) {
			SendMessageToPC(oPC, "Dieser Gegenstand ist zu schwer fuer dieses Behaeltnis.");
			ActionGiveItem(oDisturbItem, oPC);
			return;
		}

		SetLocalInt(OBJECT_SELF, "bDisturbed", TRUE);

		//Wenn Gold in die Kiste gelegt wurde
		// Should not happen anyways
		if ( GetBaseItemType(oDisturbItem) == BASE_ITEM_GOLD ) {
			SendMessageToPC(oPC, "Gold kann in dieser Truhe nicht gelagert werden.");
			//Gold an Spieler zurueckgeben
			ActionGiveItem(oDisturbItem, oPC);
			return;
		}



		//Wenn Item ein Inventar hat(Kontainer ist)
		if ( GetHasInventory(oDisturbItem) ) {
			//Behaelter in Truhe ausleeren
			object oItem = GetFirstItemInInventory(oDisturbItem);
			int nCustomItem;
			while ( GetIsObjectValid(oItem) ) {
				ActionTakeItem(oItem, oDisturbItem);

				nCustomItem = GetIsCustomItem(oItem);
				if ( nCustomItem ) {
					SendMessageToPC(oPC, "Dieser Gegenstand kann nicht in diesem Behaeltnis abgelegt werden,");
					DelayCommand(0.3f, ActionGiveItem(oItem, oPC));

				} else if ( GetTotalContainerItemSizeSum(OBJECT_SELF) >
						   UnivStore_GetCapacity(OBJECT_SELF) ) {
					SendMessageToPC(oPC, "Dieser Gegenstand passt hier nun beim besten Willen nicht rein.");
					DelayCommand(0.3f, ActionGiveItem(oItem, oPC));
					return;
				} else if ( ( IntToFloat(GetWeight(oItem)) / 10.0 ) >=
						   UnivStore_GetMaxWeight(OBJECT_SELF) ) {
					SendMessageToPC(oPC, "Dieser Gegenstand ist zu schwer fuer dieses Behaeltnis.");
					DelayCommand(0.3f, ActionGiveItem(oItem, oPC));
					return;

				} else {
					nCount += 1;
					SetLocalInt(OBJECT_SELF, "itemCount", nCount);
					SendMessageToPC(oPC, "Ladung/Kapazitaet: " +
						IntToString(GetTotalContainerItemSizeSum(OBJECT_SELF)) +
						"/" + IntToString(UnivStore_GetCapacity(OBJECT_SELF)));
				}

				audit("store", oPC, "container:" +
					GetLocalString(OBJECT_SELF, "store_tag"), "univstore", oItem);

				oItem = GetNextItemInInventory(oDisturbItem);
			}

			return;
		}

		//Wenn Custom-Item
		int nCustomItem = GetIsCustomItem(oDisturbItem);
		if ( nCustomItem ) {
			SendMessageToPC(oPC, "Dieser Gegenstand kann nicht in diesem Behaeltnis abgelegt werden,");
			ActionGiveItem(oDisturbItem, oPC);
		} else {
			audit("store", oPC, "container:" +
				GetLocalString(OBJECT_SELF, "store_tag"), "univstore", oDisturbItem);
			nCount += 1;
			SetLocalInt(OBJECT_SELF, "itemCount", nCount);

		}

		SendMessageToPC(oPC, "Ladung/Kapazitaet: " +
			IntToString(GetTotalContainerItemSizeSum(OBJECT_SELF)) +
			"/" + IntToString(UnivStore_GetCapacity(OBJECT_SELF)));
		return;

	}
	//Gegenstand wurde rausgenommen
	else if ( nDisturbType == INVENTORY_DISTURB_TYPE_REMOVED
			 || nDisturbType == INVENTORY_DISTURB_TYPE_STOLEN ) {
		nCount -= 1;
		SetLocalInt(OBJECT_SELF, "itemCount", nCount);
		SetLocalInt(OBJECT_SELF, "bDisturbed", TRUE);
		SendMessageToPC(oPC, "Ladung/Kapazitaet: " +
			IntToString(GetTotalContainerItemSizeSum(OBJECT_SELF)) +
			"/" + IntToString(UnivStore_GetCapacity(OBJECT_SELF)));
		audit("unstore", oPC, "container:" +
			GetLocalString(OBJECT_SELF, "store_tag"), "univstore", oDisturbItem);
	}
}
