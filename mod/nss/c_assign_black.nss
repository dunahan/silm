void main() {
	SetLocalInt(OBJECT_SELF, "nBlackAssigned", 1);
	SetLocalObject(OBJECT_SELF, "oBlackPlayer", GetPCSpeaker());

	if ( GetLocalInt(OBJECT_SELF, "nWhiteAssigned") && GetLocalInt(OBJECT_SELF, "GameState") == 2 )
		SetLocalInt(OBJECT_SELF, "GameState", 1);
}
