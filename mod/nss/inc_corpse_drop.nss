#include "inc_corpse"

int CorpseDropped(object oItem, object oPC) {
	if ( GetTag(oItem) != "loot_corpse" ) return FALSE;

	DropCorpseObject(oItem, oPC);
	return TRUE;
}

