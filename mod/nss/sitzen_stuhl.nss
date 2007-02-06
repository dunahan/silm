void main() {
	int nSteps = 0;

	object oPlayer = GetLastUsedBy();
	object oStuhl;

	if ( GetIsPC(oPlayer) ) {
		oStuhl = GetNearestObjectByTag("Stuhl", oPlayer, 0);

		if ( GetIsObjectValid(oStuhl) && !GetIsObjectValid(GetSittingCreature(oStuhl)) ) {
			AssignCommand(oPlayer, ActionSit(oStuhl));
			nSteps = 0;
		}
	}
}
