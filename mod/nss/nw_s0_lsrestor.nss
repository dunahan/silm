//::///////////////////////////////////////////////
//:: Lesser Restoration
//:: NW_S0_LsRestor.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 * 	Removes all supernatural effects related to ability
 * 	damage, as well as AC, Damage,
 */
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "inc_subr_eff"

void main() {
	//Declare major variables
	object oTarget = GetSpellTargetObject();
	effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION_LESSER);
	effect eBad = GetFirstEffect(oTarget);
	//Search for negative effects
	while ( GetIsEffectValid(eBad) ) {
		if ( GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE
			|| GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE
			|| GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE
			|| GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE
			|| GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE
			|| GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE
			|| GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE
			|| GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ) {
			//Remove effect if it is negative.
			SR_RemoveEffect(oTarget, eBad);
		}
		eBad = GetNextEffect(oTarget);
	}
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LESSER_RESTORATION, FALSE));

	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
}

