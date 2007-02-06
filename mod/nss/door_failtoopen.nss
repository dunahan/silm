#include "_gen"
#include "x0_i0_anims"

const string
MESSAGE = "Nun schnell - ich kann das Tor nicht lange fuer Euch offen belassen.";

void ActionOpenTheDurnedDoor(object oDoor);

void main() {
	object oPC = GetClickingObject();
	if ( !GetIsCreature(oPC) )
		return;

	object oDoor = OBJECT_SELF;

	string sNightGuardTag = GetLocalString(oDoor, "night_guard_tag");
	// Check if its night and we are locked
	if ( sNightGuardTag != "" && GetLocked(oDoor) && GetLocalInt(oDoor, "nightlock") && !GetIsDay() ) {
		object oWaechter = GetNearestObjectByTag(sNightGuardTag, oDoor);

		//if (ACTION_INVALID == GetCurrentAction(oWaechter)) {
		//    ToPC("Busy", oPC);
		//    return;
		//}

		if ( !GetIsCreature(oWaechter) || GetDistanceBetween(oDoor, oWaechter) > 20.0 ) {
			ToPC("Es scheint kein Nachtwaechter da zu sein, der Euch die Tuere oeffnen kann.", oPC);
			return;
		}

		if ( GetIsInCombat(oPC) ) {
			AssignCommand(oWaechter, ActionSpeakString("Dort sind Feinde .. ich werde das Tor nicht oeffnen!"));
			return;
		}

		// Make sure the guard has the proper tools to do his job!
		if ( !GetIsObjectValid(GetItemPossessedBy(oWaechter, "key_citydoors")) )
			CreateItemOnObject("key_citydoors", oWaechter, 1);

		AssignCommand(oWaechter, ActionOpenTheDurnedDoor(oDoor));
	}
}



void ActionOpenTheDurnedDoor(object oDoor) {
	ClearAllActions(1);
	ActionSpeakString("Ich komme ..");
	ActionWait(0.5);
	//SetLocked(oDoor, 0);
	//SetLocalInt(oDoor, "dont_lock", 1);
	ActionMoveToObject(oDoor, 0);
	ActionUnlockObject(oDoor);
	ActionWait(0.5);
	ActionOpenDoor(oDoor);
	ActionSpeakString(MESSAGE);
	ActionWait(12.0f);
	ActionCloseDoor(oDoor);
	ActionWait(0.5);
	ActionLockObject(oDoor);
	ActionWait(0.5);
	//ActionDoCommand(SetLocalInt(oDoor, "dont_lock", 0));
	//ActionDoCommand(SetLocked(oDoor, 1));
	ActionDoCommand(WalkWayPoints());
}
