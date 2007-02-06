#include "c_chessinc"

void main() {
	int nSide, nPosition, nNewPosition;
	object oTarget;
	object oGM = GetNearestObjectByTag("c_gamemaster");

	nSide = GetLocalInt(oGM, "Turn");

	nPosition = GetLocalInt(OBJECT_SELF, "nPosition");
	nNewPosition = nPosition + 9 * nSide;
	SetIntArray(oGM, "nSquare", nNewPosition - 8 * nSide, 0);
	MovePiece(nPosition, nNewPosition);
	if ( GetLocalInt(OBJECT_SELF, "nPosition") == nNewPosition ) {
		oTarget = GetObjectArray(oGM, "oSquare", nNewPosition - 8 * nSide);
		SetObjectArray(oGM, "oSquare", nNewPosition - 8 * nSide, oGM);
		DestroyObject(oTarget);
	} else SetIntArray(oGM, "nSquare", nNewPosition - 8 * nSide, ( -nSide ));
}
