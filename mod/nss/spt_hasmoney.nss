#include "inc_currency"

int StartingConditional() {
	object oPC = GetPCSpeaker();

	return GetValue(oPC) >= ( GetLocalInt(oPC, "SPECIAL_PRICE") * 100 );
}
