#include "inc_nwnx"
#include "inc_craft_hlp"

int StartingConditional() {

	object oPC = GetPCSpeaker();

	struct PlayerSkill s = GetPlayerSkill(oPC, CSKILL_TAILOR);

	return s.practical < 20;
}
