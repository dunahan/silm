#include "inc_currency"

void main() {
	object oPC     = GetPCSpeaker();
	object oPackOx = GetLocalObject(OBJECT_SELF, "ANIMAL");
	int iPrice     = GetLocalInt(OBJECT_SELF, "PRICE");

	GiveValueToCreature(oPC, iPrice);

	SetLocalInt(oPackOx, "PRICE", iPrice * 2);

	DeleteLocalObject(oPackOx, "PACK_OWNER");

	DeleteLocalInt(oPackOx, "PACK_MODE");

	AssignCommand(oPackOx, ClearAllActions(TRUE));
}
