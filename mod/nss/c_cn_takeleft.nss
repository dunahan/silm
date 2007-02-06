#include "c_chessinc"

int StartingConditional() {
	int l_iResult;

	l_iResult = ( GetLocalInt(OBJECT_SELF, "takeleft") == 1 );
	if ( l_iResult ) {
		object oGM = GetNearestObjectByTag("c_gamemaster");
		int nPos = GetLocalInt(OBJECT_SELF, "nPosition");
		int nTurn = GetLocalInt(oGM, "Turn");
		SetCustomToken(103, MovePositions(nPos, nPos - nTurn));
	}
	return l_iResult;
}
