#include "inc_nwnx"
#include "inc_craft_hlp"

int StartingConditional() {

	object oPC = GetPCSpeaker();
	object oArm = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

	if ( GetIsDM(oPC) )
		return FALSE;

	int nSkill = GetArmorAC(oArm) > 3 ? CSKILL_SMITH_ARMOR : CSKILL_TAILOR;

	struct PlayerSkill s = GetPlayerSkill(oPC, nSkill);

	return s.practical < 20;
}
