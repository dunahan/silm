void main() {
	object oPC = GetPCSpeaker();
	object oComp = GetLocalObject(oPC, "animalstaff_comp");
	location lTarget = GetLocalLocation(oPC, "animalstaff_targetl");
	object oTarget = GetLocalObject(oPC, "animalstaff_target");

	if ( !GetIsObjectValid(oComp) ) {
		SendMessageToPC(oPC, "Ihr ben�tigt einen Tiergef�hrten, um diesen Stab benutzen zu k�nnen.");
		return;
	}

//    AssignCommand(oComp, ClearAllActions(1));
	DelayCommand(1.0, AssignCommand(oComp, SetFacingPoint(GetPositionFromLocation(lTarget))));
}
