int StartingConditional() {
	object oPC = GetPCSpeaker();
	string sRevert = GetLocalString(oPC, "ConvList_Revert");
	int iStT = GetLocalInt(oPC, "ConvList_StT");

	if ( sRevert != "" ) {
		SetCustomToken(iStT + 12, GetLocalString(oPC, "ConvList_RevCap"));
		return 1;
	}
	return 0;
}
