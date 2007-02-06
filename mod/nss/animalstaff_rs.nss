void main() {
	object oPC = GetPCSpeaker();
	object oComp = GetLocalObject(oPC, "animalstaff_comp");
	location lTarget = GetLocalLocation(oPC, "animalstaff_targetl");


	if ( !GetIsObjectValid(oComp) ) {
		SendMessageToPC(oPC, "Ihr ben�tigt einen Tiergef�hrten, um diesen Stab benutzen zu k�nnen.");
		return;
	}

	AssignCommand(oComp, ClearAllActions());
	AssignCommand(oComp, ActionForceMoveToLocation(lTarget, TRUE));
	AssignCommand(oComp, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 9999999.0));
}
