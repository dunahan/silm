void main() {
	object oPC = GetLastAttacker();
	object oWache = GetFirstObjectInArea();
	string sWache = GetLocalString(OBJECT_SELF, "wache");
	int sLaenge = GetStringLength(sWache);
	while ( GetIsObjectValid(oWache) ) {
		if ( GetStringLeft(GetTag(oWache), sLaenge) == sWache ) {
			if ( LineOfSightObject(oWache, oPC) ) {
				AssignCommand(oWache, ActionSpeakString("ALARM!! Eindringling!!"));
				AssignCommand(oWache, ActionAttack(oPC));
				AdjustReputation(oPC, oWache, -100);
				DelayCommand(300.0, AdjustReputation(oPC, oWache, 100));
			}
		}
		oWache = GetNextObjectInArea();
	}
}
