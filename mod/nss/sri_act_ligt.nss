void main() {
	object oTarget = GetLocalObject(OBJECT_SELF, "SR_IAct_Obj");
	location lTarget = GetLocalLocation(OBJECT_SELF, "SR_IAct_Loc");

	if ( GetIsObjectValid(oTarget) )
		ActionCastSpellAtObject(SPELL_LIGHT, oTarget, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT,
			TRUE);
}
