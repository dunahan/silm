void main() {
	object oPC = GetPCSpeaker();

	DeleteLocalObject(oPC, "dmfi_univ_target");
	SetLocalInt(oPC, "dmfi_univ_offset", 1);
	SetLocalString(oPC, "dmfi_univ_conv", "pc_emote");
	AssignCommand(oPC, ClearAllActions());
	AssignCommand(oPC, ActionStartConversation(OBJECT_SELF, "dmfi_universal", TRUE));
}

