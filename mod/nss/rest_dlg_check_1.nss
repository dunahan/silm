#include "inc_decay"

int StartingConditional() {
	object oPC = GetPCSpeaker();

	if ( GetLocalInt(oPC, "Resting_Fail") ) return 0;

	int iFood = GetLocalDecay(oPC, "Resting_Food");

	//Allow resting if food would last for more than 2 remaining hours
	if ( iFood >= 120 ) return 0;

	SetLocalInt(oPC, "Resting_Fail", 1);
	return 1;
}
