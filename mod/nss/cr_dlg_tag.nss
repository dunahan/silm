#include "inc_selectlist"

void main() {
	object oPC = GetPCSpeaker();
	int iIndex = GetLocalInt(oPC, "ConvList_Select");

	int iTag = GetListDisplayMode(OBJECT_SELF, "Item", iIndex);

	SetListDisplayMode(OBJECT_SELF, "Item", ( iTag ? 0 : 1 ), iIndex);
}
