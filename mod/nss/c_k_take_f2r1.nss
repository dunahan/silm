#include "c_chessinc"

void main() {
	int nSide, nPosition, nNewPosition;

	nSide = GetLocalInt(GetNearestObjectByTag("c_gamemaster"), "Turn");

	nPosition = GetLocalInt(OBJECT_SELF, "nPosition");
	nNewPosition = nPosition + 17 * nSide;
	TakePiece(nPosition, nNewPosition);
}
