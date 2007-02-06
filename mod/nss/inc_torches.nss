#include "inc_decay"

void _TorchWarn(object oPC, object oTorch) {
	int iRemain = GetLocalInt(oTorch, "Remaining");

	if ( GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) != oTorch ) return;

	if ( iRemain > 5 ) return;

	SendMessageToPC(oPC, "Eure Fackel geht bald zu Ende.");
}


void _TorchGone(object oPC, object oTorch) {
	int iRemain = GetLocalInt(oTorch, "Remaining");

	if ( GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) != oTorch ) return;

	if ( iRemain > 1 ) return;

	SendMessageToPC(oPC, "Eure Fackel ist heruntergebrannt.");
	DestroyObject(oTorch);
}


void EquippedTorch(object oPC, object oTorch) {
	int iRemain = GetLocalInt(oTorch, "Remain_stop");
	if ( !GetLocalInt(oTorch, "First_Use") ) {
		iRemain = 120 + Random(60);
		SetLocalInt(oTorch, "First_Use", 1);
	}
	SetLocalDecay(oTorch, "Remaining", iRemain, 60);

	DelayCommand(IntToFloat(( iRemain - 5 ) * 15), _TorchWarn(oPC, oTorch));
	DelayCommand(IntToFloat(( iRemain + 10 ) * 15), _TorchGone(oPC, oTorch));
}

void UnequippedTorch(object oPC, object oTorch) {
	int iRemain = GetLocalDecay(oTorch, "Remaining");
	SetLocalInt(oTorch, "Remain_stop", iRemain);
}

