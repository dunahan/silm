#include "_gen"

void main() {
	object oTarget = GetLocalObject(OBJECT_SELF, "SR_IAct_Obj");
	location lTarget = GetLocalLocation(OBJECT_SELF, "SR_IAct_Loc");

	if ( GetIsObjectValid(oTarget) ) {
		/* fairy fire */
		effect eFairyFire = EffectVisualEffect(VFX_DUR_AURA_PULSE_RED_ORANGE);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFairyFire, oTarget, 60.0 * GetTotalLevel(OBJECT_SELF));
	} else {
		ActionCastSpellAtLocation(SPELL_DARKNESS, lTarget, METAMAGIC_NONE, TRUE, PROJECTILE_PATH_TYPE_DEFAULT,
			TRUE);
	}
}
