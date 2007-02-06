#include "_gen"
#include "inc_decay"
#include "inc_currency"
#include "inc_customize"
#include "inc_misc"
#include "inc_nwnx"

void main() {
	object oItem;
	int iValue;


	if ( !GetIsObjectValid(oItem = GetItemPossessedBy(OBJECT_SELF, "dmfi_pc_emote")) )
		oItem = CreateItemOnObject("dmfi_pc_emote", OBJECT_SELF);

	// Don't let them start out on the verge of starving to death
	if ( GetLocalDecay(OBJECT_SELF, "Resting_Food") < 60 )
		SetLocalDecay(OBJECT_SELF, "Resting_Food", 241, 60);

	//Recover from a crash during trade where money is still
	//numerical
	if ( ( iValue = GetGold(OBJECT_SELF) ) ) {
		TakeGoldFromCreature(iValue, OBJECT_SELF, TRUE);
		GiveValueToCreature(OBJECT_SELF, iValue);
	}

	/* Destroy leftovers from crashes or intentional exits while crafting */
	Assert_Copy_Destroyed(OBJECT_SELF, INVENTORY_SLOT_CHEST);
	Assert_Copy_Destroyed(OBJECT_SELF, INVENTORY_SLOT_RIGHTHAND);

	/* Dice bag broadcasting should default to "local" (visible in area) */
	SetLocalInt(OBJECT_SELF, "dmfi_dicebag", 2);

	// Correct Starting XP vor older Chars
	if ( GetXP(OBJECT_SELF) < 6000 ) {
		SetXP(OBJECT_SELF, 6000);
	}
	//For now, no prestige classes, sorry.
	//SetLocalInt(OBJECT_SELF,"X1_AllowShadow",1);
	//SetLocalInt(OBJECT_SELF,"X1_AllowHarper",1);
	//SetLocalInt(OBJECT_SELF,"X1_AllowAsasin",1);
	//SetLocalInt(OBJECT_SELF,"X1_AllowBlkGrd",1);

	/*SetLocalInt(OBJECT_SELF,"X2_AllowDivcha",1);
	 * SetLocalInt(OBJECT_SELF,"X1_AllowDrDis",1); //What? Is an XP2 PrC!
	 * SetLocalInt(OBJECT_SELF,"X1_AllowDwDef",1);
	 * SetLocalInt(OBJECT_SELF,"X2_AllowKensei",1);
	 * SetLocalInt(OBJECT_SELF,"X2_AllowPalema",1);
	 * SetLocalInt(OBJECT_SELF,"X2_AllowShiftr",1);
	 * SetLocalInt(OBJECT_SELF,"X2_AllowWM",1); */


	int nNow = GetUnixTimestamp();
	int nSh = 0;
	// Make sure no ebs shields remain
	object oShield = GetFirstItemInInventory(OBJECT_SELF);
	while ( GetIsObjectValid(oShield) ) {
		if ( "s_ebs" == GetTag(oShield) ) {
			nSh = GetLocalInt(oShield, "ebs_create");
			if ( nSh == 0 || nNow - nSh > 3600 * 3 )
				DestroyObject(oShield);
		}

		oShield = GetNextItemInInventory(OBJECT_SELF);
	}

}


