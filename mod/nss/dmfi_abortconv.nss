#include "inc_cardgame"
void main() {
	string sConv = GetLocalString(OBJECT_SELF, "dmfi_univ_conv");
	if ( sConv == "pc_cards1" || sConv == "pc_cards2" ) {
		DeleteLocalInt(OBJECT_SELF, "Tens");
		DeleteLocalString(OBJECT_SELF, "dmfi_univ_conv");
		object oCardStack = GetLocalObject(OBJECT_SELF, "cg_oCardStack");
		AbortGame(oCardStack);
	}
}
