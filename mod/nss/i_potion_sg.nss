#include "_events"


void main() {
	if ( EVENT_ITEM_ACTIVATE != GetEvent() )
		return;

	object oPC = GetItemActivator();
	object oItem = GetItemActivated();

	if ( GetLocalInt(oPC, "no_potion_sg") )
		return;

	string sR = GetResRef(oItem),
		   sName = GetName(oItem);

	int iSG = 13;

	if ( "po_bier" == sR )
		iSG = 13;
	if ( "po_met" == sR )
		iSG = 14;
	if ( "po_likoer" == sR )
		iSG = 17;
	if ( "po_sake" == sR )
		iSG = 14;
	if ( "po_rotwein_halb" == sR )
		iSG = 14;
	if ( "po_rotwein_lieb" == sR )
		iSG = 14;
	if ( "po_rotwein_trock" == sR )
		iSG = 14;
	if ( "po_weiswein_halb" == sR )
		iSG = 14;
	if ( "po_weiswein_lieb" == sR )
		iSG = 14;
	if ( "po_weiswein_troc" == sR )
		iSG = 14;
	if ( "po_weizenbier" == sR )
		iSG = 13;
	if ( "po_zwergenbier" == sR )
		iSG = 15;

	int
	d = d20(1),
	m = GetFortitudeSavingThrow(oPC);

	string s = "Zaehigkeitswurf auf " + sName + ": " + IntToString(d) + " + "
			   + IntToString(m) + " = " + IntToString(d + m) + " vs " + IntToString(iSG) + ": " +
			   ( iSG > d + m ? "Gescheitert" : "Geschafft" ) + "!";

	AssignCommand(oPC, ActionSpeakString(s));
}
