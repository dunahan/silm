#include "inc_currency"

void main() {
	object oPC = GetLastClosedBy();

	int iValue = GetGold(oPC);
	GiveValueToCreature(oPC, iValue);
	TakeGoldFromCreature(iValue, oPC, TRUE);
}
