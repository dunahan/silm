#include "inc_customize"

void main() {
	Assert_Changes_Committed(GetPCSpeaker(), INVENTORY_SLOT_CHEST);
	Assert_Changes_Committed(GetPCSpeaker(), INVENTORY_SLOT_RIGHTHAND);
	Assert_Changes_Committed(GetPCSpeaker(), INVENTORY_SLOT_CLOAK);
	SetLocalInt(GetPCSpeaker(), "noclothchange", 0);
}
