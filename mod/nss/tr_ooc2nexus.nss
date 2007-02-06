#include "inc_decay"
#include "inc_persist"
#include "inc_subr_data"

void main() {
	object oPC = GetClickingObject();
	object oTgt = GetTransitionTarget(OBJECT_SELF);


	if ( GetLocalInt(oPC, "may_enter_game") ) {
		//Restart digestion on leaving the OOC area
		SetLocalDecay(oPC, "Resting_Food",
			GetLocalDecay(oPC, "Resting_Food"), 60);
		AssignCommand(oPC, JumpToObject(oTgt));
	} else {
		FloatingTextStringOnCreature(
			"Du darfst mit diesem Charakter das Spiel leider nicht betreten.  Beachte bitte die Servermeldungen, als du beigetreten bist.",
			oPC, 0);
	}
}
