int StartingConditional() {
	object oGM = OBJECT_SELF;
	return GetLocalInt(oGM, "SavedToDB") == 0;
}
