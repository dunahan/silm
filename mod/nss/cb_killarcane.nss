#include "inc_killarcane"
#include "inc_lists"


void main() {
	object
	oPC = GetLocalObject(OBJECT_SELF, "ConvList_PC");

	int
	iSelection = GetLocalInt(oPC, "ConvList_Select");
	iSelection = GetListInt(oPC, TT, iSelection);


	RemoveArcaneBySpellID(oPC, iSelection);
}
