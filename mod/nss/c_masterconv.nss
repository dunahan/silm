void main() {
	/*    object
	 * 		oWhite = GetLocalObject(OBJECT_SELF, "oWhitePlayer"),
	 * 		oBlack = GetLocalObject(OBJECT_SELF, "oBlackPlayer");
	 *
	 * 	string t1, t2;
	 * 	SetCustomToken(1, t1 = (GetName(oWhite) + " (" + GetPCPlayerName(oWhite) + ")"));
	 * 	SetCustomToken(2, t2 = (GetName(oBlack) + " (" + GetPCPlayerName(oBlack) + ")"));
	 * 	SetCustomToken(3, GetLocalInt(OBJECT_SELF, "nWhiteAssigned") ? "Weiss: " +  t1 :
	 * 		"Schwarz: " + t2);*/


	BeginConversation("c_gamemaster", GetPCSpeaker());
}
