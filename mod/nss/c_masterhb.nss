#include "c_chessinc"

void main() {
	object oPlayer;
	int bWhiteLeft = FALSE;
	int bBlackLeft = FALSE;

	if ( GetLocalInt(OBJECT_SELF, "nWhiteAssigned") == 1 ) {
		oPlayer = GetLocalObject(OBJECT_SELF, "oWhitePlayer");
		if ( GetIsObjectValid(oPlayer) ) {
			/*if (GetArea(oPlayer) != GetArea(OBJECT_SELF)) {
			 * 	ActionSpeakString("Weisser Spieler hat das Gebiet verlassen. Weiss ist nun frei.");
			 * 	bWhiteLeft = TRUE;
			 * } */
		} else {
			Announce("Weisser Spieler hat das Spiel verlassen. Weiss ist nun frei.");
			bWhiteLeft = TRUE;
		}
	}

	if ( GetLocalInt(OBJECT_SELF, "nBlackAssigned") == 1 ) {
		oPlayer = GetLocalObject(OBJECT_SELF, "oBlackPlayer");
		if ( GetIsObjectValid(oPlayer) ) {
			/*if (GetArea(oPlayer) != GetArea(OBJECT_SELF))
			 * {
			 * 	ActionSpeakString("Schwarzer Spieler hat das Gebiet verlassen. Schwarz ist nun frei.");
			 * 	bBlackLeft = TRUE;
			 * }*/
		} else {
			Announce("Schwarzer Spieler hat das Spiel verlassen. Schwarz ist nun frei.");
			bBlackLeft = TRUE;
		}
	}

	if ( bWhiteLeft ) {
		SetLocalInt(OBJECT_SELF, "nWhiteAssigned", 0);
		SetLocalObject(OBJECT_SELF, "oWhitePlayer", OBJECT_INVALID);
		if ( GetLocalInt(OBJECT_SELF, "GameState") == 1 )
			SetLocalInt(OBJECT_SELF, "GameState", 2);
	}

	if ( bBlackLeft ) {
		SetLocalInt(OBJECT_SELF, "nBlackAssigned", 0);
		SetLocalObject(OBJECT_SELF, "oBlackPlayer", OBJECT_INVALID);
		if ( GetLocalInt(OBJECT_SELF, "GameState") == 1 )
			SetLocalInt(OBJECT_SELF, "GameState", 2);
	}

	/*GetNearestObjectByTag("chair");
	 * if (*/
}
