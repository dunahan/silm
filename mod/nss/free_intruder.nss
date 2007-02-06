void main() {
	object oDoor1 = GetObjectByTag("SEC_DOORLOCK1");
	object oDoor2 = GetObjectByTag("SEC_DOORLOCK2");
	object oHebel = GetObjectByTag("SEC_HEBEL");
	int nDoorLock = GetLocked(oDoor1);

	if ( nDoorLock == TRUE ) {
		ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
		SetLocked(oDoor1, FALSE);
		ActionDoCommand(ActionOpenDoor(oDoor1));
		SetLocked(oDoor2, FALSE);
		ActionDoCommand(ActionOpenDoor(oDoor2));
	} else {
		ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
		ActionDoCommand(ActionCloseDoor(oDoor1));
		SetLocked(oDoor1, TRUE);
		ActionDoCommand(ActionCloseDoor(oDoor2));
		SetLocked(oDoor2, TRUE);
	}
}
