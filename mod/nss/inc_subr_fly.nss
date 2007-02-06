#include "inc_subr_ardefs"
#include "inc_subr_teff"

void Fly_Effect(object oPC) {
	object oEff1, oEff2;
	location lLoc = GetLocation(oPC);

	//oEff1 = CreateObject(OBJECT_TYPE_PLACEABLE,"plc_magicwhite",lLoc);
	oEff2 = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_dustplume", lLoc);
	//DelayCommand(5.0f,DestroyObject(oEff1));
	DelayCommand(4.0f, DestroyObject(oEff2));
}

int Fly_IsAirborne(object oPC) {
	return GetLocalInt(oPC, "SR_Airborne");
}

int Fly_IsAreaOK(object oPC) {
	return ( GetLocalInt(oPC, "SR_AreaFlags") & SR_AREA_OPENSPACE ) ? 1 : 0;
}

int Fly_IsPCOK(object oPC) {
	return GetCurrentHitPoints(oPC) >= GetMaxHitPoints(oPC) / 2;
}

void Fly_TakeOff(object oPC) {
	effect eEff1, eEff2;

	if ( Fly_IsAirborne(oPC) )
		return;

	eEff1 = EffectMovementSpeedIncrease(99);
	eEff2 = EffectMissChance(100, MISS_CHANCE_TYPE_VS_MELEE);
	eEff1 = EffectLinkEffects(eEff2, eEff1);
	eEff2 = EffectConcealment(100, MISS_CHANCE_TYPE_VS_MELEE);
	eEff1 = EffectLinkEffects(eEff2, eEff1);
	eEff2 = EffectConcealment(20);
	eEff1 = EffectLinkEffects(eEff2, eEff1);
	eEff2 = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
	eEff1 = EffectLinkEffects(eEff2, eEff1);


	Fly_Effect(oPC);

	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDisappear(), oPC);

	DelayCommand(2.5f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eEff1), oPC));

	SetLocalInt(oPC, "SR_Airborne", 1);
}

void Fly_Land(object oPC, int iHard = FALSE) {
	if ( !Fly_IsAirborne(oPC) ) return;

	Fly_Effect(oPC);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectAppear(), oPC);
	SR_RemoveTempEffect(oPC, EFFECT_TYPE_MOVEMENT_SPEED_INCREASE);
	DeleteLocalInt(oPC, "SR_Airborne");

	if ( iHard )
		ApplyEffectToObject(DURATION_TYPE_INSTANT,
			EffectDamage(d10(2), DAMAGE_TYPE_BLUDGEONING), oPC);
}

