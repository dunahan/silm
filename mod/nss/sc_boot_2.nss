void main() {

	location lLoc = GetLocation(GetWaypointByTag("Anlegestelle_1"));
	object player = GetLastUsedBy();
	AssignCommand(player, JumpToLocation(lLoc));

}
