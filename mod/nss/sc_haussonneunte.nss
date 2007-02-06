#include "x0_i0_secret"

void main() {

	object oUser = GetLastUsedBy();


	if ( GetLocalInt(GetModule(), "i") == 0 ) {
		ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN);
		SetLocalInt(GetModule(), "i", 1);
	} else {
		location lLoc = GetLocation(GetWaypointByTag("WP_Haus_Sonne_EG"));
		object player = GetLastUsedBy();
		AssignCommand(player, JumpToLocation(lLoc));
		ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE);
		SetLocalInt(GetModule(), "i", 0);
	}
}

