#include "inc_subr_data"
#include "inc_subr_eff"
#include "inc_subr_item"
#include "inc_subr_area"

void main() {
	string sChosen_SR = GetSubRace(OBJECT_SELF);
	int iRT = GetRacialType(OBJECT_SELF);

	//FIXME: Perminssion management
	int iSR_State = GetSubraceGranted(sChosen_SR, iRT, 1);

	if ( !iSR_State )
		return;

	if ( iSR_State == 2 ) {
		SendMessageToPC(OBJECT_SELF, "Subrasse " +
			sChosen_SR + " ist nur bei gesonderter Anmeldung verfuegbar.");
		return;
	}

	SetLocalString(OBJECT_SELF, "SR_Subrace", GetSubraceIdentifier(sChosen_SR, iRT));

	ApplySubraceItems(OBJECT_SELF);
	RefreshSubraceEffects(OBJECT_SELF);
	SR_Update_Flags(OBJECT_SELF);

	SendMessageToPC(OBJECT_SELF, "Subrasse " + sChosen_SR + " erkannt und gesetzt.");
}
