//#include "_map"
#include "_chat"
#include "inc_cdb"
#include "_gen"
#include "_audit"
#include "inc_currency"
#include "_mnx"

void main() {
	object oPC = GetExitingObject();

	int nGold = Money2Value(CountCreatureMoney(oPC, 0));
	audit("logout", oPC, audit_fields("xp", IntToString(GetXP(oPC)), "gold", IntToString(nGold)));

	ExecuteScript("_mod_clleave_cdb", oPC);
	//ExecuteScript("_mod_cleave_onl",oPC);

	//SaveMapPinsForPlayer(oPC);

	string sCharName = GetName(oPC);
	string sAccountName = GetPCName(oPC);
	int nAID = GetAccountID(oPC);
	int nCID = GetCharacterID(oPC);

	mnxCommand("clientleave", sAccountName, sCharName, IntToString(nAID), IntToString(nCID));

	ExecuteScript("logout_corpse", oPC);
	ExecuteScript("logout_pcdata", oPC);


	ChatPCout(oPC);
}
