// Dancing Lights
#include "_gen"

/*
 * cast at oPC: Follow oPC, put in party
 * cast at other person: follow other person, put in party
 * cast at location: stay there, put in party
 */

void main() {
	object oPC = OBJECT_SELF;

	object oTarget = GetSpellTargetObject();
	location lTarget = GetSpellTargetLocation();

	if ( GetIsObjectValid(oTarget) )
		lTarget = GetLocation(oTarget);

	int nDC = GetSpellSaveDC(); // gets the DC required to save against the effects of the spell
	int nLevel = GetCasterLevel(oPC); // gets the level the PC cast the spell as
	int nMeta = GetMetaMagicFeat();

	object oLight = CreateObject(OBJECT_TYPE_CREATURE, "dancelight", lTarget, TRUE);
	SetLocalInt(oLight, "dancelights_level", nLevel);

	if ( !GetIsPC(oTarget) )
		oTarget = oPC;

	AddHenchman(oTarget, oLight);

	AssignCommand(oLight, ActionForceFollowObject(oTarget, 1.0));
	SetLocalInt(oLight, "follow", 1);

	float fDuration = HoursToSeconds(nLevel);

	if ( METAMAGIC_EXTEND == nMeta )
		fDuration *= 2.0;

	AssignCommand(oLight, DelayCommand(fDuration, DestroyObject(oLight)));
}
