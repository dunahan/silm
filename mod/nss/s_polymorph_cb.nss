/* warning: this callback hook is both used for polymorph other and polymorph self! */

#include "_gen"
#include "inc_lists"

const string
CT = "polymorph";

effect GetEffectBonus(string str) {
	effect eLink;
	// For flying creatures
	if ( "fly" == str ) {
		eLink = EffectConcealment(100, MISS_CHANCE_TYPE_VS_MELEE);
		eLink = EffectLinkEffects(EffectMissChance(100, MISS_CHANCE_TYPE_VS_MELEE), eLink);
		eLink = EffectLinkEffects(EffectMovementSpeedIncrease(40), eLink);
	}

	return eLink;
}

void main() {
	object
	oPC = GetLocalObject(OBJECT_SELF, "ConvList_PC"),
	oTarget = GetLocalObject(oPC, "polymorph_target");

	int
	iSelection = GetLocalInt(oPC, "ConvList_Select"),
	iDoWildShapeTransform = GetLocalInt(oPC, "wildshape_transform");

	iSelection = GetListInt(oPC, CT, iSelection);

	string sEffect = GetLocalString(oPC, "polymorph_type");
	SetLocalString(oPC, "polymorph_type", "");

	// Do the actual polymorphing

	effect eP = SupernaturalEffect(EffectPolymorph(iSelection, FALSE));
	effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);

	if ( sEffect != "" ) {
		eP = EffectLinkEffects(GetEffectBonus(sEffect), eP);
	}

	ApplyEffectToObject(DTI, eVis, oTarget);
	ApplyEffectToObject(DTP, eP, oTarget);

	// And remove the conversation thingy
	AssignCommand(oPC, ActionStartConversation(oPC, "invalid", 1, 0));
}



/*void DoWildShapeTransForm(object oTarget, int nPolyID) {
 * 	int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",nPoly)) == 1;
 * 	int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",nPoly)) == 1;
 * 	int bItems  = StringToInt(Get2DAString("polymorph","MergeI",nPoly)) == 1;
 *
 * 	object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget);
 * 	object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,oTarget);
 * 	object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oTarget);
 * 	object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oTarget);
 * 	object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,oTarget);
 * 	object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oTarget);
 * 	object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oTarget);
 * 	object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,oTarget);
 * 	object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,oTarget);
 * 	object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oTarget);
 *
 *
 * 	if (GetIsObjectValid(oShield)) {
 * 		if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
 * 			GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
 * 			GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
 * 		{
 * 			oShield = OBJECT_INVALID;
 * 		}
 * 	}
 *
 *
 * 	ClearAllActions();
 * 	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
 * 	ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oTarget);
 *
 * 	// Now apply per-shape bona
 * 	switch (nPoly) {
 * 		case POLYMORPH_TYPE_BROWN_BEAR:
 * 			break;
 * 		case POLYMORPH_TYPE_PANTHER:
 * 			break;
 * 		case POLYMORPH_TYPE_WOLF:
 * 			break;
 * 		case POLYMORPH_TYPE_BOAR:
 * 			break;
 * 		case POLYMORPH_TYPE_BADGER:
 * 			break;
 * 	}
 *
 * 	object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
 * 	object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);
 *
 * 	if (bWeapon) {
 * 			IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
 * 	}
 *
 * 	if (bArmor) {
 * 		IPWildShapeCopyItemProperties(oShield,oArmorNew);
 * 		IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
 * 		IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
 * 	}
 *
 * 	if (bItems) {
 * 		IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
 * 		IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
 * 		IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
 * 		IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
 * 		IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
 * 		IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
 * 	}
 */
