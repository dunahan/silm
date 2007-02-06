#include "inc_currency"

void main() {
	object oPC = GetLastClosedBy();
	object oItem = GetFirstItemInInventory();
	int nGold = 0;
	while ( GetIsObjectValid(oItem) ) {
		if ( GetTag(oItem) == "Orkkopf" ) {
			nGold = nGold + 200;
			DestroyObject(oItem);
		} else if ( GetTag(oItem) == "Goblinkopf" ) {
			nGold = nGold + 100;
			DestroyObject(oItem);
		} else if ( GetTag(oItem) == "Gnollkopf" ) {
			nGold = nGold + 200;
			DestroyObject(oItem);
		} else if ( GetTag(oItem) == "Grottenschratkopf" ) {
			nGold = nGold + 300;
			DestroyObject(oItem);
		}
		oItem = GetNextItemInInventory();
	}
	//SendMessageToPC(oPC,IntToString(nGold));
	GiveValueToCreature(oPC, nGold);
}
