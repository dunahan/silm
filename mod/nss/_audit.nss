// _audit


#include "inc_mysql"


const string
AUDIT_TABLE = "audit";


void audit(string sEvent, object oPC = OBJECT_SELF, string sData = "", string sSection = "module",
		   object oTarget = OBJECT_INVALID);


int GetIsAudited(object o);

// Prepares some audit string for use in sData
string audit_fields(string s1 = "", string v1 = "", string s2 = "", string v2 = "", string s3 = "", string v3 = "", string s4 = "", string v4 = "", string s5 = "",
					string v5 = "");




void audit(string sEvent, object oPC = OBJECT_SELF, string sData = "", string sSection = "module",
		   object oTarget = OBJECT_INVALID) {

	string sFlags = "";

	if ( GetIsDM(oPC) )
		sFlags += "dm";

	string sLocation = "";
	if ( GetIsPC(oPC) )
		sLocation = nLocationToString(GetLocation(oPC));

	string sTP = "", sTC = "";
	sTC = GetName(oTarget);
	sTP = GetPCPlayerName(oTarget) == "" ? GetLocalString(oTarget, "player_name") : GetPCPlayerName(oTarget);
	if ( sTC == "" )
		sTC = "t:" + GetTag(oTarget);
	if ( sTP == "" )
		sTP = "r:" + GetResRef(oTarget);


	string sP = "", sC = "";

	sC = GetName(oPC);
	sP = GetPCPlayerName(oPC) == "" ? GetLocalString(oPC, "player_name") : GetPCPlayerName(oPC);

	if ( sC == "" )
		sC = "t:" + GetTag(oPC);
	if ( sP == "" )
		sP = "r:" + GetResRef(oPC);


	string sSQL = "insert into `" +
				  AUDIT_TABLE +
				  "` (`player`, `char`, `location`, `flags`, `event`, `data`, `category`, `tplayer`, `tchar`) values(";
	sSQL += "" + SQLEscape(sP) + ", ";
	sSQL += "" + SQLEscape(sC) + ", ";
	sSQL += "" + SQLEscape(sLocation) + ", ";
	sSQL += "" + SQLEscape(sFlags) + ", ";
	sSQL += "" + SQLEscape(sEvent) + ", ";
	sSQL += "" + SQLEscape(sData) + ", ";
	sSQL += "" + SQLEscape(sSection) + ", ";
	sSQL += "" + SQLEscape(sTP) + ", ";
	sSQL += "" + SQLEscape(sTC) + "";
	sSQL += ");";

	string sMsg = "A :: " + sP + " :: " + sC + " :: " + sFlags + " :: " + sEvent + " :: " + sData;

	SQLExecDirect(sSQL);

	WriteTimestampedLogEntry(sMsg);

	object oTmp = GetFirstPC();
	while ( GetIsObjectValid(oTmp) ) {
		if ( GetLocalInt(oTmp, "audit_trail") )
			SendMessageToPC(oTmp, sMsg);
		oTmp = GetNextPC();
	}
}

int GetIsAudited(object o) {
	if ( GetLocalInt(GetModule(), "audit") )
		return 1;

	if ( GetLocalInt(o, "audit") )
		return 1;

//    if (GetPlayerPersistentInt("audit", o))
//        return 1;

	return 0;
}




string audit_fields(string s1 = "", string v1 = "", string s2 = "", string v2 = "", string s3 = "", string v3 = "", string s4 = "", string v4 = "", string s5 = "",
					string v5 = "") {
	string sr = "";

	if ( s1 != "" ) {
		if ( v1 != "" )
			sr += ":" + s1 + ":" + v1;
		else
			sr += "info:" + s1;
	}
	if ( s2 != "" )
		sr += ":" + s2 + ":" + v2;
	if ( s3 != "" )
		sr += ":" + s3 + ":" + v3;
	if ( s4 != "" )
		sr += ":" + s4 + ":" + v4;
	if ( s5 != "" )
		sr += ":" + s5 + ":" + v5;

	if ( GetStringLeft(sr, 1) == ":" )
		sr = GetSubString(sr, 1, 1024);

	return sr;

}
