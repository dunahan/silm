void Teleport_Object(object oObject, object oTarget) {
	if ( GetIsObjectValid(oObject) )
		AssignCommand(oObject, JumpToObject(oTarget));
}


void main() {
	object oClicker = GetClickingObject();
	object oTarget = GetTransitionTarget(OBJECT_SELF);

	SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);

	Teleport_Object(oClicker, oTarget);

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
