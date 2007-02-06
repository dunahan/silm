#include "c_chessinc"

int StartingConditional() {
	int l_iResult;

	l_iResult = ( GetLocalInt(OBJECT_SELF, "takef1l2") == 1 );
	if ( l_iResult ) {
		object oGM = GetNearestObjectByTag("c_gamemaster");
		int nPos = GetLocalInt(OBJECT_SELF, "nPosition");
		int nTurn = GetLocalInt(oGM, "Turn");
		SetCustomToken(102, MovePositions(nPos, nPos + ( 6 * nTurn )));
	}
	return l_iResult;
}
