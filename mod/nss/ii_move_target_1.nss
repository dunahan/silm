#include "inc_target"
#include "inc_amask"
#include "inc_nwnx_events"

void main() {

	object oPC = OBJECT_SELF;
	object oItem = GetEventItem();
	object oTarget = GetActionTarget();
	vector vTarget = GetEventPosition();
	location lTarget = Location(GetArea(oPC), vTarget, GetFacing(oPC));


	if ( !amask(oPC, AMASK_GM) &&
		!amask(oPC, AMASK_FORCETALK) &&
		!amask(oPC, AMASK_GLOBAL_FORCETALK)
	) {
		SendMessageToPC(oPC, "Ich mag dich nicht.  PAFF!");
		DestroyObject(oItem);
		return;
	}


	object oCurrentTarget = GetLocalObject(oItem, "current_target");
	int nRun = GetLocalInt(oItem, "current_target_run") == 1;
	int nQueues = GetLocalInt(oItem, "current_target_queues") == 1;

	if (GetIsObjectValid(oTarget)) {
		if (!GetIsCreature(oTarget)) {
			
			if (oTarget == oItem) {
				// toggle queueing
				nQueues = !nQueues;
				SetLocalInt(oItem, "current_target_queues", nQueues);
				if (nRun)
					SendMessageToPC(oPC, "Target queues actions.");
				else
					SendMessageToPC(oPC, "Target does not queue actions.");

			} else {
				SendMessageToPC(oPC, "Not a valid target.");
			}
		} else {
			if (GetIsPC(oTarget)) {
				// make him follow

				if (GetIsObjectValid(oCurrentTarget) && GetIsCreature(oCurrentTarget)) {
					if (!nQueues)
						AssignCommand(oCurrentTarget, ClearAllActions(TRUE));
					AssignCommand(oCurrentTarget, ActionForceFollowObject(oTarget, 2.0f));
				} else {
					SendMessageToPC(oPC, "Current target cannot follow selected PC, because its not a creature.");
				}
			} else {
				if (oTarget == oCurrentTarget) {
					nRun = !nRun;
					SetLocalInt(oItem, "current_target_run", nRun);
					if (nRun)
						SendMessageToPC(oPC, "Target runs.");
					else
						SendMessageToPC(oPC, "Target walks.");
				} else {
					ShowTargetFor(-1, oTarget, oPC);
					SetLocalObject(oItem, "current_target", oTarget);
					SetLocalInt(oItem, "current_target_run", 0);
					SetLocalInt(oItem, "current_target_queues", 0);
				}
			}
		}
	} else {
		if (GetIsObjectValid(oCurrentTarget)) {
			if (!nQueues)
				AssignCommand(oCurrentTarget, ClearAllActions(TRUE));
			AssignCommand(oCurrentTarget, ActionMoveToLocation(lTarget, nRun));
		} else {
			SendMessageToPC(oPC, "No valid target for this item is set.");
		}

	}
}
