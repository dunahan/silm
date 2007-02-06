#include "c_chessinc"

void main() {
	int nSide, nPosition, nNewPosition;

	nSide = GetLocalInt(GetNearestObjectByTag("c_gamemaster"), "Turn");

	nPosition = GetLocalInt(OBJECT_SELF, "nPosition");
	nNewPosition = nPosition + 8 * nSide;
	MovePiece(nPosition, nNewPosition);
	if ( GetLocalInt(OBJECT_SELF, "nPosition") == nNewPosition ) {
		if ( nNewPosition > 55 || nNewPosition < 8 ) SetLocalInt(OBJECT_SELF, "promote", 1);
	}
}
