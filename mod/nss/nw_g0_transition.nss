////////////////////////////////////////////////////////////
// OnClick/OnAreaTransitionClick
// NW_G0_Transition.nss
// Copyright (c) 2001 Bioware Corp.
////////////////////////////////////////////////////////////
// Created By: Sydney Tang
// Created On: 2001-10-26
// Description: This is the default script that is called
//              if no OnClick script is specified for an
//              Area Transition Trigger or
//              if no OnAreaTransitionClick script is
//              specified for a Door that has a LinkedTo
//              Destination Type other than None.
////////////////////////////////////////////////////////////

void Teleport_Object(object oObject, object oTarget) {
	if ( GetIsObjectValid(oObject) )
		AssignCommand(oObject, JumpToObject(oTarget));
}


void main() {
	object oClicker = GetClickingObject();
	object oTarget = GetTransitionTarget(OBJECT_SELF);

	SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);

	Teleport_Object(oClicker, oTarget);

	//Intra-Area transition, move associates manually
	if ( GetArea(OBJECT_SELF) == GetArea(oTarget) ) {
		Teleport_Object(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oClicker), oTarget);
		Teleport_Object(GetAssociate(ASSOCIATE_TYPE_DOMINATED, oClicker), oTarget);
		Teleport_Object(GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oClicker), oTarget);
		Teleport_Object(GetAssociate(ASSOCIATE_TYPE_SUMMONED, oClicker), oTarget);
		Teleport_Object(GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oClicker, 1), oTarget);
		Teleport_Object(GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oClicker, 2), oTarget);
		Teleport_Object(GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oClicker, 3), oTarget);
	}
}
