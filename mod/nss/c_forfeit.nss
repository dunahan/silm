#include "c_const"
#include "c_db"

void main() {
	object oGM = OBJECT_SELF;
	object oPlayer = GetPCSpeaker();
	if (GetLocalObject(oGM, "oWhitePlayer") == oPlayer)
		SetLocalInt(oGM, "GameResult", RESULT_BLACK);
	else
		SetLocalInt(oGM, "GameResult", RESULT_WHITE);

	SaveChessGame(oGM);
}

