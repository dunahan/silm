#include "inc_doors"

void main() {
	object oDoor = OBJECT_SELF;
	object oPC = GetLastOpenedBy();

	// ClearAllActions();

	int nAutoClose = GetLocalInt(oDoor, "autoclose");
	int nAutoLock = GetLocalInt(oDoor, "autolock");

	if ( nAutoLock < 0 || nAutoLock ) {
		ActionAutoCloseLock(nAutoClose < 0 ? 60 : nAutoClose);
	} else {
		ActionAutoClose(nAutoClose < 0 ? 60 : nAutoClose);
	}

}
