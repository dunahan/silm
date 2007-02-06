void main() {
	if ( GetIsNight() && !GetEncounterActive() ) {
		SendMessageToAllDMs("Day/Night-Encounter ON: " + GetResRef(GetArea(OBJECT_SELF)));
		SetEncounterActive(1);
	}

	if ( !GetIsNight() && GetEncounterActive() ) {
		SetEncounterActive(0);
		SendMessageToAllDMs("Day/Night-Encounter OFF: " + GetResRef(GetArea(OBJECT_SELF)));
	}
}
