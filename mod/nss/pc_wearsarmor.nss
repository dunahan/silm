int StartingConditional() {
	object oPC = GetPCSpeaker();
	object oArm = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

	SetLocalObject(oPC, "CHG_CURRENT_ARM", oArm);
	return GetIsObjectValid(oArm);
}
