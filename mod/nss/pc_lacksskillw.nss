#include "inc_nwnx"
#include "inc_craft_hlp"

int StartingConditional() {
	object oPC = GetPCSpeaker();
	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int iBT = GetBaseItemType(oWeap);
	string sRanged = Get2DAString("baseitems", "RangedWeapon", iBT);

	if ( GetIsDM(oPC) )
		return FALSE;

	int nSkill = ( sRanged == "****" || sRanged == "" ) ? CSKILL_SMITH_WEAPON : CSKILL_FLETCHER;

	struct PlayerSkill s = GetPlayerSkill(oPC, nSkill);

	return s.practical < 20;
}
