#include "c_const"
#include "c_db"

void main() {
	object oGM = OBJECT_SELF;
	object oPlayer = GetPCSpeaker();
	SetLocalInt(oGM, "GameResult", RESULT_DRAW);
	SaveChessGame(oGM);
}

