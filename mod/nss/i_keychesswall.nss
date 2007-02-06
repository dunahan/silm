/*
 * Chess-Dungeon Manager Key.
 */
#include "_events"

void main() {
	if ( EVENT_ITEM_ACTIVATE != GetEvent() )
		return;

	object oPC = GetItemActivator();

	if ( GetIsInCombat(oPC) ) {
		FloatingTextStringOnCreature("Kann nicht im Kampf eingesetzt werden.", oPC, FALSE);
		return;
	}

	location lo = GetLocalLocation(OBJECT_SELF, "lastpos");

	// PC ist im Schachdungeon und eine alte Location wurde gespeichert die nicht im Dungeon ist.
	if ( GetTag(GetArea(oPC)) == "Schachdungeon"
		&& GetTag(GetAreaFromLocation(lo)) != "Schachdungeon" ) {

		AssignCommand(oPC, JumpToLocation(lo));
		SendMessageToAllDMs(GetName(oPC) +
			" hat den Schachdungeon-Schluessel benutzt um dem Dungeon zu entkommen.");

		// PC ist im D, aber keine Location wurde gespeichert.
	} else if ( GetTag(GetArea(oPC)) == "Schachdungeon"
			   && !GetIsObjectValid(GetAreaFromLocation(lo)) ) {
		FloatingTextStringOnCreature("Keine vorherige Position ist hinterlegt.", oPC, FALSE);

		/// PC ist nicht im Schachdungeon.  Neue Location speichern und beamen
	} else if ( GetTag(GetArea(oPC)) != "Schachdungeon" ) {
		SetLocalLocation(OBJECT_SELF, "lastpos", GetLocation(oPC));
		AssignCommand(oPC, JumpToLocation(GetLocation(GetObjectByTag("wp_schach"))));
		SendMessageToPC(oPC,
			"Letzte Position wurde gespeichert, benutze den Schluessel erneut um zurueckzukehren.");
		SendMessageToAllDMs(GetName(oPC) +
			" hat den Schachdungeon-Schluessel benutzt um den Dungeon zu betreten.");
		// Shouldnt happen
	} else {
		FloatingTextStringOnCreature("What? Saved Area: " +
			GetTag(GetAreaFromLocation(lo)) +
			" -- Your area: " +
			GetTag(GetArea(oPC)) + " -- Dungeon: " + GetTag(GetObjectByTag("Schachdungeon")), oPC, FALSE);
	}
}
