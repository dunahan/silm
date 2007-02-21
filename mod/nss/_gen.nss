#include "_audit"
#include "inc_mysql"
#include "inc_functions"
#include "inc_currency"
#include "inc_2dacache"


const int
DTT = DURATION_TYPE_TEMPORARY,
DTI = DURATION_TYPE_INSTANT,
DTP = DURATION_TYPE_PERMANENT;


struct RealTime {
	int day;
	int month;
	int year;
	int hour;
	int minute;
	int second;
	int error;
};


int hears(object oSpeaker, object oListener, int nTalkMode);

int hears(object oSpeaker, object oListener, int nTalkMode) {
	float fDistance = GetDistanceBetween(oSpeaker, oListener);
	if ( TALKVOLUME_TALK == nTalkMode && fDistance > 20.0 )
		return 0;

	if ( TALKVOLUME_WHISPER == nTalkMode && fDistance > 8.0 )
		return 0;

	return GetObjectHeard(oSpeaker, oListener);
}


void bug(string sMessage);


// Makes a generic throw and displays the results
// to the user and all nearby DMs.
int MakeThrow(int nDC, int nDFaces, int nDCount, int nMod, int bDisplayToAll = FALSE);

// Returns the height difference between oA and oB.
// oB.z - oA.z = fElevation
float GetElevationBetween(object oA, object oB);

// makes n be between min and max
int clamp(int n, int min = 0, int max = 100);

// Returns the spell name as found in the serverside 2da/tlk.
string GetSpellName(int nSpellID);

// xx
float GetAbsoluteOrRelativeValue(string sParseMe, float fCurrentValue, float fAbsoluteValue);

// A simulated conciousness.
// Can be resisted by having immunity
// or saving throws.
// bConceal: Hide from enemies while unconcious
//  (Enemies ignore unconcious/down people)
effect EffectUnconscious(int bConceal = FALSE);

// Converts seconds to a time descriptor.
// Example:
//  65 -> "1 minute and 5 seconds"
string SecondsToTimeDesc(int nSeconds);

struct RealTime GetRealTime();

// Returns true if oPC is a DM by
// arbitary criteria.
// This is intended to allow DMs logged
// in as players to perform certain
// administrative tasks such as fixing
// reputations or banning troublemakers.
// int IsDM(object oPC = OBJECT_SELF, int bAllowPossess = TRUE);


int GetIsPolymorphed(object oCreature);


int GetIsDMAllowed(object oPC);


// Returns the player object to which sAccount matches; either
// the CharName or the Accoutname.
// case-insensitive.
object FindPCByAccount(string sAccount, int bCheckNameToo = TRUE);


// Sends a debug message out.  Low-cost.
void dbg(string sMessage, object oDebugTarget = OBJECT_INVALID, int nLevel = 1);

// Returns TRUE if oO is a item.
int GetIsItem(object oO);

// Returns TRUE if oO is a critter of sorts.
int GetIsCreature(object oO);

// Returns TRUE if oO is a placeable.
int GetIsPlaceable(object oO);


// Returns the total level of oCreature (all class levels combined).
// Returns 0 if not a creature.
int GetTotalLevel(object oCreature);


// Parses s into a bool value.
// true is everything > 0, 'yes', 'true', 't', 'y'.
// Rest is false.
int StringToBool(string s);

string BoolToString(int b);

int GetUnixTimestamp();


// Returns the unix ts when the mod was started
int GetModStartup();

string GetPCName(object oPC);


void ToPC(string sMsg, object oPC = OBJECT_SELF);

//void ToDMs(string sMsg);


object GetFirstArea();

object GetNextArea();


void Floaty(string sMsg, object oPC = OBJECT_SELF, int nBroadCast = 0);

void Floaty(string sMsg, object oPC = OBJECT_SELF, int nBroadCast = 0) {
	FloatingTextStringOnCreature(sMsg, oPC, nBroadCast);
}


int RemoveAllEffects(object oObj);

// Returns s trimmed.
// Read the short source code to understand sTrim.
string GetStringTrim(string s, string sTrimLeft = " ", string sTrimRight = " ");

// Returns oPC as a unique string representation
string PCToString(object oPC, int bShort = FALSE);

string AreaToString(object oPC);

string LocationToStringPrintable(location lo);


string ObjectTypeToString(int nO);


int CountNearestObjectByTag(string sTag);

object GetNearestRandomObjectByTag(string sTag);

// Returns the nNth(start=1) nearest nObjectType to oNearTo
//  OR
// Returns the nNth(start=1) nObjectType that matches sTag in sInArea (without considering distance).
// object GetNearestObjectToObject(int nObjectType, object oNearTo, string sTag = "", int nNth = 1, string sInArea = "", int nCreatureCriteriaType = -1, int nCreatureCriteriaValue = -1);



// Returns true if there is a player in the same area the caller is (or if the caller is a PC)
int GetIsPlayerInArea();

// Returns true if a DM is online
int GetIsDMOnline();


string ClassToString(int nClass);
string FamiliarToString(object oPC);
string RaceToString(object oPC);

void KillInventory(object oC);

object GetItemResRefPossessedBy(object oInv, string sResRef);

int GetItemCountByResRef(object oInv, string sTag);

int GetItemCountByTag(object oInv, string sTag);



int GetPCCount(object oArea = OBJECT_INVALID, int bOnlyDMs = FALSE);

int GetPCPartyCount(object oPC);


/* impl */

struct RealTime GetRealTime() {
	struct RealTime r;
	
	SQLQuery("select s, m, h, dd, mm, yy;");
	if (!SQLFetch()) {
		r.error = 1;
		SendMessageToAllDMs("GetRealTime() failed. Argfslz.");
	} else {
		r.second = StringToInt(SQLGetData(1));
		r.minute = StringToInt(SQLGetData(2));
		r.hour = StringToInt(SQLGetData(3));
		r.day = StringToInt(SQLGetData(4));
		r.month = StringToInt(SQLGetData(5));
		r.year = StringToInt(SQLGetData(6));
	}
	return r;

}

int GetModStartup() {
	return GetLocalInt(GetModule(), "startup_ts");
}

object GetItemResRefPossessedBy(object oInv, string sResRef) {
	sResRef = GetStringLowerCase(sResRef);
	object oI = GetFirstItemInInventory(oInv);
	while ( GetIsObjectValid(oI) ) {
		if ( GetStringLowerCase(GetResRef(oI)) == sResRef )
			return oI;

		oI = GetNextItemInInventory(oInv);
	}
	return OBJECT_INVALID;
}


int GetItemCountByResRef(object oInv, string sResRef) {
	int nT = 0;
	sResRef = GetStringLowerCase(sResRef);
	object oI = GetFirstItemInInventory(oInv);
	while ( GetIsObjectValid(oI) ) {
		if ( GetStringLowerCase(GetResRef(oI)) == sResRef )
			nT += GetItemStackSize(oI);

		oI = GetNextItemInInventory(oInv);
	}
	return nT;
}

int GetItemCountByTag(object oInv, string sTag) {
	int nT = 0;
	sTag = GetStringLowerCase(sTag);
	object oI = GetFirstItemInInventory(oInv);
	while ( GetIsObjectValid(oI) ) {
		if ( GetStringLowerCase(GetTag(oI)) == sTag )
			nT += GetItemStackSize(oI);

		oI = GetNextItemInInventory(oInv);
	}
	return nT;

}

int clamp(int n, int min = 0, int max = 100) {
	return n > max ? max : n < min ? min : n;
}


void KillInventory(object oC) {
	object oI = GetFirstItemInInventory(oC);
	while ( GetIsObjectValid(oI) ) {
		DestroyObject(oI);
		oI = GetNextItemInInventory(oC);
	}
}

int GetIsPolymorphed(object oCreature) {
	effect e = GetFirstEffect(oCreature);
	while ( GetIsEffectValid(e) ) {
		if ( EFFECT_TYPE_POLYMORPH == GetEffectType(e) )
			return 1;

		e = GetNextEffect(oCreature);
	}
	return 0;
}

void dbg(string sMessage, object oDebugTarget = OBJECT_INVALID, int nLevel = 1) {

	sMessage = ( GetIsObjectValid(oDebugTarget) ? ObjectToString(oDebugTarget) +
				"/" + GetName(oDebugTarget) : "" ) + ": " + sMessage;

	if ( GetLocalInt(GetModule(), "debug") >= nLevel )
		SendMessageToAllDMs(sMessage);

	WriteTimestampedLogEntry(sMessage);
}

int GetIsPlayerInArea() {
	return GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC));
}

int RemoveAllEffects(object oObj) {
	int i = 0;
	effect e = GetFirstEffect(oObj);
	while ( GetIsEffectValid(e) ) {
		RemoveEffect(oObj, e);
		i += 1;
		e = GetNextEffect(oObj);
	}
	return i;
}


int GetUnixTimestamp() {
	SQLQuery("select unix_timestamp();");
	SQLFetch();
	return StringToInt(SQLGetData(1));
}


void ToPC(string sMsg, object oPC = OBJECT_SELF) {
	SendMessageToPC(oPC, sMsg);
}


/*void ToDMs(string sMsg) {
 * 	object o = GetFirstPC();
 * 	while (GetIsObjectValid(o)) {
 * 		if (CheckMask(oPC, AMASK_GM) && !GetIsDM(o))
 * 			SendMessageToPC(o, sMsg);
 *
 * 		o = GetNextPC();
 * 	}
 * 	SendMessageToAllDMs(sMsg);
 * }*/

string GetPCName(object oPC) {
	return GetPCPlayerName(oPC) == "" ? GetLocalString(oPC, "player_name") : GetPCPlayerName(oPC);
}


string GetStringTrim(string s, string sTrimLeft = " ", string sTrimRight = " ") {
	int
	iS = 0,
	iC = GetStringLength(s) - 1;

	while ( GetSubString(s, iS, 1) == sTrimLeft )
		iS++;

	while ( GetSubString(s, iC, 1) == sTrimRight )
		iC--;

	return GetSubString(s, iS, iC + 1);
}

int StringToBool(string s) {
	s = GetStringLowerCase(s);
	return s == "true" || s == "yes" || s == "y" || s == "t" || StringToInt(s) != 0;
}

string BoolToString(int b) {
	return b > 0 ? "true" : "false";
}


/*
 * object GetNearestObjectToObject(int nObjectType, object oNearTo, string sTag = "", int nNth = 1, string sInArea = "", int nCreatureCriteriaType = -1, int nCreatureCriteriaValue = -1) {
 * 	int bChooseNext = FALSE;
 *
 * 	int n = nNth;
 *
 * 	object oArea = GetArea(oNearTo);
 * 	if ("" != sInArea)
 * 		oArea = GetObjectByTag(sInArea);
 *
 * 	if (!GetIsObjectValid(oNearTo) || GetArea(oNearTo) != oArea)
 * 		oNearTo = GetFirstObjectInArea(oArea);
 *
 * 	SendMessageToPC(GetFirstPC(), "Selected Tag: " + sTag);
 * 	SendMessageToPC(GetFirstPC(), "Selected Area: " + GetResRef(oNearTo) + "/" + GetTag(oNearTo) + "/" + GetName(oNearTo));
 * 	SendMessageToPC(GetFirstPC(), "Selected oNearTo: " + GetResRef(oNearTo) + "/" + GetTag(oNearTo) + "/" + GetName(oNearTo));
 *
 * 	object oThis = GetNearestObject(nObjectType, oNearTo, n);
 *
 * 	while (GetIsObjectValid(oThis)) {
 *
 * 		SendMessageToPC(GetFirstPC(), "Object(" + IntToString(n) + "): " + GetResRef(oThis) + "/" + GetTag(oThis) + "/" + GetName(oThis));
 *
 * 		if (!bChooseNext && sTag != "") {
 * 			if (GetStringLowerCase(GetTag(oThis)) != GetStringLowerCase(sTag)) {
 * 				bChooseNext = TRUE;
 * 				SendMessageToPC(GetFirstPC(), "Choosing next: Requested tag does not match.");
 * 			}
 * 		}
 *
 *
 * 		if (!bChooseNext && GetIsObjectValid(oArea)) {
 * 			if (GetArea(oThis) != oArea) {
 * 				SendMessageToPC(GetFirstPC(), "Choosing next: Area does not match.");
 * 				bChooseNext = TRUE;
 * 			}
 * 		}
 *
 *
 * 		if (!bChooseNext && OBJECT_TYPE_CREATURE == nObjectType) {
 * 			// TODO do criteria matching.
 * 		}
 *
 * 		if (n > nNth) {
 * 			SendMessageToPC(GetFirstPC(), "Got nuffink.");
 * 			break;
 * 		}
 *
 * 		if (bChooseNext) {
 * 			n++;
 * 			oThis = GetNearestObject(nObjectType, oNearTo, n);
 * 			bChooseNext = FALSE;
 * 			continue;
 * 		}
 *
 * 		SendMessageToPC(GetFirstPC(), "Got it.");
 *
 * 		return oThis;
 * 	}
 *
 * 	// Nothing found at all.
 * 	return OBJECT_INVALID;
 * } */


int CountNearestObjectByTag(string sTag) {
	int c = 0;
	object o = GetNearestObjectByTag(sTag, OBJECT_SELF, c + 1);
	while ( GetIsObjectValid(o) ) {
		c++;
		o = GetNearestObjectByTag(sTag, OBJECT_SELF, c + 1);
	}
	return c;
}

object GetNearestRandomObjectByTag(string sTag) {
	int c = CountNearestObjectByTag(sTag);
	if ( c == 0 )
		return OBJECT_INVALID;

	int r = 1 + Random(c);
	return GetNearestObjectByTag(sTag, OBJECT_SELF, r);
}


string ObjectTypeToString(int nO) {
	switch ( nO ) {
		case OBJECT_TYPE_ALL:
			return "Anything.";

		case OBJECT_TYPE_AREA_OF_EFFECT:
			return "Anything.";

		case OBJECT_TYPE_CREATURE:
			return "Creature";

		case OBJECT_TYPE_DOOR:
			return "Door";

		case OBJECT_TYPE_ENCOUNTER:
			return "Encounter";

		case OBJECT_TYPE_ITEM:
			return "Item";

		case OBJECT_TYPE_PLACEABLE:
			return "Placeable";

		case OBJECT_TYPE_STORE:
			return "Store";

		case OBJECT_TYPE_TRIGGER:
			return "Trigger";

		case OBJECT_TYPE_WAYPOINT:
			return "Waypoint";
	}

	return "Invalid object";
}


string LocationToStringPrintable(location lo) {
	object oArea = GetAreaFromLocation(lo);
	vector v = GetPositionFromLocation(lo);
	float f = GetFacingFromLocation(lo);

	if ( !GetIsObjectValid(oArea) )
		return "";

	return "'" +
		   AreaToString(oArea) +
		   "':(" +
		   FloatToString(v.x) +
		   ":" + FloatToString(v.y) + ":" + FloatToString(v.z) + "):(" + FloatToString(f) + ")";

}

string PCToString(object oPC, int bShort = FALSE) {
	if ( !bShort )
		return "'" +
			   GetPCPlayerName(oPC) +
			   "'/'" +
			   GetName(oPC) + "'" + ( GetIsDM(oPC) ? " [DM]" : "" ) + " @ " + AreaToString(GetArea(oPC)) + "";
	else
		return /*"'" + GetPCPlayerName(oPC) + "'/'" + */ "'" + GetName(oPC) + "'";
}

string AreaToString(object oArea) {
	return "'" + GetName(oArea) + "'(" + GetResRef(oArea) + ")";
}


int GetIsPlaceable(object oO) {
	return GetObjectType(oO) == OBJECT_TYPE_PLACEABLE;
}


int GetIsItem(object oO) {
	return GetObjectType(oO) == OBJECT_TYPE_ITEM;
}

int GetIsCreature(object oO) {
	return GetObjectType(oO) == OBJECT_TYPE_CREATURE;
}

/*int IsDM(object oPC = OBJECT_SELF, int bAllowPossess = FALSE) {
 * 	if (GetIsDM(oPC))
 * 		return 1;
 *
 * 	//if (GetLocalInt(oPC, "dm"))
 * 	//
 *
 * 	// Allow possesses too?
 * 	if (bAllowPossess && GetIsDMPossessed(oPC))
 * 		return 1;
 *
 * 	string sName = GetStringLowerCase(GetPCPlayerName(oPC));
 * 	if (
 * 		// Bernhard
 * 		sName == "kyareth" ||
 * 		sName == "gm elven" ||
 * 		sName == "asthiae" ||
 * 		sName == "esthae" ||
 *
 * 		// ||-Catcher
 * 		sName == "kyareth" // Weil ich faul bin mit || oben.
 * 	)
 * 		return 1;
 *
 * 	return 0;
 * }*/



object FindPCByAccount(string sAccount, int bCheckNameToo = TRUE) {
	object o = GetFirstPC();
	while ( GetIsObjectValid(o) ) {
		if ( GetStringLowerCase(GetPCPlayerName(o)) == GetStringLowerCase(sAccount)
			|| ( bCheckNameToo && GetStringLowerCase(GetName(o)) == GetStringLowerCase(sAccount) ) )
			return o;

		o = GetNextPC();
	}
	return OBJECT_INVALID;
}






int GetTotalLevel(object oCreature) {
	if ( !GetIsCreature(oCreature) )
		return 0;

	return
		   GetLevelByPosition(1, oCreature) +
		   GetLevelByPosition(2, oCreature) +
		   GetLevelByPosition(3, oCreature);
}






string ClassToString(int nClass) {
	string sResult = "Sysadmin";

	switch ( nClass ) {
		case CLASS_TYPE_ABERRATION: sResult = "Aberation"; break;
		case CLASS_TYPE_ANIMAL: sResult = "Tier"; break;
		case CLASS_TYPE_ARCANE_ARCHER: sResult = "Arkaner Bogenschuetze"; break;
		case CLASS_TYPE_ASSASSIN: sResult = "Assassin"; break;
		case CLASS_TYPE_BARBARIAN: sResult = "Barbar"; break;
		case CLASS_TYPE_BARD: sResult = "Barde"; break;
		case CLASS_TYPE_BEAST: sResult = "Biest"; break;
		case CLASS_TYPE_BLACKGUARD: sResult = "Finsterer Streiter"; break;
		case CLASS_TYPE_CLERIC: sResult = "Kleriker"; break;
		case CLASS_TYPE_COMMONER: sResult = "Buergerlicher"; break;
		case CLASS_TYPE_CONSTRUCT: sResult = "Konstrukt"; break;
		case CLASS_TYPE_DIVINECHAMPION: sResult = "Heiliger Raecher"; break; // xxx
		case CLASS_TYPE_DRAGON: sResult = "Drache"; break;
		case CLASS_TYPE_DRAGON_DISCIPLE: sResult = "Juenger des roten Drachen"; break; // xxx
		case CLASS_TYPE_DRUID: sResult = "Druide"; break;
		case CLASS_TYPE_DWARVENDEFENDER: sResult = "Zwergenverteidiger"; break; // xxx
		case CLASS_TYPE_ELEMENTAL: sResult = "Elementar"; break;
		case CLASS_TYPE_EYE_OF_GRUUMSH: sResult = "Auge des Gruumsh"; break;
		case CLASS_TYPE_FEY: sResult = "Pixie"; break;
		case CLASS_TYPE_FIGHTER: sResult = "Kaempfer"; break;
		case CLASS_TYPE_GIANT: sResult = "Riese"; break;
		case CLASS_TYPE_HARPER: sResult = "Harfner"; break;
		case CLASS_TYPE_HUMANOID: sResult = "Mensch"; break;
		case CLASS_TYPE_MAGICAL_BEAST: sResult = "Magisches Biest"; break;
		case CLASS_TYPE_MONK: sResult = "Moench"; break;
		case CLASS_TYPE_MONSTROUS: sResult = "Monster"; break;
		case CLASS_TYPE_OOZE: sResult = "Schleim"; break;
		case CLASS_TYPE_OUTSIDER: sResult = "Planarer"; break;
		case CLASS_TYPE_PALADIN: sResult = "Paladin"; break;
		case CLASS_TYPE_PALEMASTER: sResult = "Bleicher Meister"; break;
		case CLASS_TYPE_RANGER: sResult = "Waldlaeufer"; break;
		case CLASS_TYPE_ROGUE: sResult = "Schurke"; break;
		case CLASS_TYPE_SHADOWDANCER: sResult = "Schattentaenzer"; break;
		case CLASS_TYPE_SHAPECHANGER: sResult = "Gestaltwandler"; break;
		case CLASS_TYPE_SHIFTER: sResult = "Shifter"; break;
		case CLASS_TYPE_SORCERER: sResult = "Hexer"; break;
		case CLASS_TYPE_UNDEAD: sResult = "Untoter"; break;
		case CLASS_TYPE_VERMIN: sResult = "Insekt"; break;
		case CLASS_TYPE_WEAPON_MASTER: sResult = "Waffenmeister"; break;
		case CLASS_TYPE_WIZARD: sResult = "Magier"; break;
	}

	return sResult;
}


string RaceToString(object oPC) {
	int iRace = GetRacialType(oPC);
	string sResult = "Bleistift";

/*    if (GetSubRace(oPC) != "") {
 * 		return GetSubRace(oPC);
 * 	}*/

	switch ( iRace ) {
		case RACIAL_TYPE_ABERRATION: sResult = "Aberation"; break;
		case RACIAL_TYPE_ANIMAL: sResult = "Tier"; break;
		case RACIAL_TYPE_BEAST: sResult = "Biest"; break;
		case RACIAL_TYPE_CONSTRUCT: sResult = "Konstrukt"; break;
		case RACIAL_TYPE_DRAGON: sResult = "Drache"; break;
		case RACIAL_TYPE_DWARF: sResult = "Zwerg"; break;
		case RACIAL_TYPE_ELEMENTAL: sResult = "Elementar"; break;
		case RACIAL_TYPE_ELF: sResult = "Elf"; break;
		case RACIAL_TYPE_FEY: sResult = "Pixie"; break;
		case RACIAL_TYPE_GIANT: sResult = "Riese"; break;
		case RACIAL_TYPE_GNOME: sResult = "Gnom"; break;
		case RACIAL_TYPE_HALFELF: sResult = "Halbelf"; break;
		case RACIAL_TYPE_HALFLING: sResult = "Halbling"; break;
		case RACIAL_TYPE_HALFORC: sResult = "Halbork"; break;
		case RACIAL_TYPE_HUMAN: sResult = "Mensch"; break;
		case RACIAL_TYPE_HUMANOID_GOBLINOID: sResult = "Goblinoid"; break;
		case RACIAL_TYPE_HUMANOID_MONSTROUS: sResult = "Monster"; break;
		case RACIAL_TYPE_HUMANOID_ORC: sResult = "Ork"; break;
		case RACIAL_TYPE_HUMANOID_REPTILIAN: sResult = "Reptil"; break;
		case RACIAL_TYPE_MAGICAL_BEAST: sResult = "Magisches Biest"; break;
		case RACIAL_TYPE_OOZE: sResult = "Schleim"; break;
		case RACIAL_TYPE_OUTSIDER: sResult = "Planarer"; break;
		case RACIAL_TYPE_SHAPECHANGER: sResult = "Gestaltwandler"; break;
		case RACIAL_TYPE_UNDEAD: sResult = "Untoter"; break;
		case RACIAL_TYPE_VERMIN: sResult = "Insekt"; break;
	}

	return sResult;
}


string FamiliarToString(object oPC) {
	switch ( GetFamiliarCreatureType(oPC) ) {
		case FAMILIAR_CREATURE_TYPE_BAT:
			return "Fledermaus";

		case FAMILIAR_CREATURE_TYPE_CRAGCAT:
			return "Ratte";

		case FAMILIAR_CREATURE_TYPE_EYEBALL:
			return "Augenball";

		case FAMILIAR_CREATURE_TYPE_FAIRY_DRAGON:
			return "Feendrache";

		case FAMILIAR_CREATURE_TYPE_FIREMEPHIT:
			return "Feuermephit";

		case FAMILIAR_CREATURE_TYPE_HELLHOUND:
			return "Hoellenhund";

		case FAMILIAR_CREATURE_TYPE_ICEMEPHIT:
			return "Eismephit";

		case FAMILIAR_CREATURE_TYPE_IMP:
			return "Imp";

		case FAMILIAR_CREATURE_TYPE_PIXIE:
			return "Pixie";

		case FAMILIAR_CREATURE_TYPE_PSEUDO_DRAGON:
			return "Pseudodrache";

		case FAMILIAR_CREATURE_TYPE_RAVEN:
			return "Rabe";
	}

	return "None";
}




object GetFirstArea() {
	int i = 0;
	SetLocalInt(GetModule(), "area_iterator", 0);
	object wP = GetObjectByTag("area_marker", i);
	return GetArea(wP);
}

object GetNextArea() {
	int i = GetLocalInt(OBJECT_SELF, "area_iterator");
	i += 1;
	SetLocalInt(GetModule(), "area_iterator", i);
	object wP = GetObjectByTag("area_marker", i);
	return GetArea(wP);
}



string SecondsToTimeDesc(int nSeconds) {
	string sRet = "";
	int nHours = ( nSeconds / 3600 );
	nSeconds -= ( nHours * 3600 );
	int nMinutes = ( nSeconds / 60 );
	nSeconds -= ( nMinutes * 60 );

	if ( nHours > 0 )
		sRet += IntToString(nHours) +  " Stunde" + ( nHours > 1 ? "n" : "" );
	if ( nMinutes > 0 )
		sRet += ( nHours > 0 ? " und " : "" ) +
				IntToString(nMinutes) +  " Minute" + ( nMinutes > 1 ? "n" : "" );
	if ( nSeconds > 0 )
		sRet += ( ( nMinutes > 0 || nHours > 0 ) ? " und " : "" ) +
				IntToString(nSeconds) +  " Sekunde" + ( nSeconds > 1 ? "n" : "" );

	return sRet;
}




float GetAbsoluteOrRelativeValue(string sParseMe, float fCurrentValue,  float fAbsoluteValue) {
	// +5.x
	// -2.4
	// 20

	int bPercent = FALSE;
	int bRelativeAdd = FALSE;
	int bRelativeSub = FALSE;

	if ( GetStringLeft(sParseMe, 1) == "+" ) {
		sParseMe = GetStringRight(sParseMe, GetStringLength(sParseMe) - 1);
		bRelativeAdd = TRUE;
	} else if ( GetStringLeft(sParseMe, 1) == "-" ) {
		sParseMe = GetStringRight(sParseMe, GetStringLength(sParseMe) - 1);
		bRelativeSub = TRUE;
	}

	if ( GetStringRight(sParseMe, 1) == "%" ) {
		sParseMe = GetStringLeft(sParseMe, GetStringLength(sParseMe) - 1);
		bPercent = TRUE;
	}

	float fRet = fCurrentValue;

	float fChange = StringToFloat(sParseMe);

	if ( 0.0 == fChange )
		return fRet;

	if ( bRelativeAdd && !bPercent )
		fRet += fChange;
	else if ( bRelativeAdd && bPercent )
		// Add fChange percent of fAbs to fRet
		fRet += ( fAbsoluteValue / 100.0 ) * fChange;
	else if ( bRelativeSub && !bPercent )
		fRet -= fChange;
	// sub fChange to fRet
	else if ( bRelativeSub && bPercent )
		fRet -= ( fAbsoluteValue / 100.0 ) * fChange;
	// sub fChange percent of fAbs to fRet

	return fRet;
}



effect EffectUnconscious(int bConceal = FALSE) {
	effect e = EffectSleep();
	e = EffectLinkEffects(EffectDeaf(), e);
	e = EffectLinkEffects(EffectBlindness(), e);
	if ( bConceal )
		e = EffectLinkEffects(EffectConcealment(100), e);
	return e;
}

string GetSpellName(int nSpellID) {
	int nRes = StringToInt(Get2DACached("spells", "Name", nSpellID));
	if ( nRes == 0 )
		return "UNBEKANNTER ZAUBER (nicht in 2da)";

	return GetStringByStrRef(nRes);
}


int GetIsDMAllowed(object oPC) {
	string
	sAccount = SQLEscape(GetPCName(oPC)),
	sKey = SQLEscape(GetPCPublicCDKey(oPC));

	SQLQuery("select id from `dms` where `account` = " + sAccount + " and `key` = " + sKey + " limit 1;");

	return SQLFetch() == SQL_SUCCESS;
}



effect StringToEffect(string sE) {
	effect e;

	if ( "blind" == sE )
		e = EffectBlindness();
	else if ( "deaf" == sE )
		e = EffectDeaf();
	else if ( "death" == sE )
		e = EffectDeath();
	else if ( "dazed" == sE )
		e = EffectDazed();
	else if ( "confused" == sE )
		e = EffectConfused();
	else if ( "ethereal" == sE )
		e = EffectEthereal();
	else if ( "knockdown" == sE )
		e = EffectKnockdown();
	else if ( "slow" == sE )
		e = EffectSlow();
	else if ( "stunned" == sE )
		e = EffectStunned();
	else if ( "timestop" == sE )
		e = EffectTimeStop();
	else if ( "frightened" == sE )
		e = EffectFrightened();
	else if ( "haste" == sE )
		e = EffectHaste();
	else if ( "silence" == sE )
		e = EffectSilence();
	else if ( "entangle" == sE )
		e = EffectEntangle();
	else if ( "seeinvis" == sE )
		e = EffectSeeInvisible();
	else if ( "trueseeing" == sE )
		e = EffectTrueSeeing();
	else if ( "ultravision" == sE ) {
		effect eVis = EffectVisualEffect(VFX_DUR_ULTRAVISION);
		effect eUltra = EffectUltravision();
		e = EffectLinkEffects(eVis, eUltra);
	} else if ( "cutsceneghost" == sE )
		e = EffectCutsceneGhost();

	return e;
}


int GetIsDMOnline() {
	object oPC = GetFirstPC();
	while ( GetIsObjectValid(oPC) ) {
		if ( GetIsDM(oPC) )
			return 1;

		oPC = GetNextPC();
	}
	return 0;
}




/*int GetRLHour() {
 * 	string sSQL = "SELECT HOUR(CURTIME())";
 * 	SQLExecDirect(sSQL);
 * 	SQLFetch();
 * 	return StringToInt(SQLGetData(1));
 * }
 *
 * string getRLTime() {
 * 	string sSQL = "SELECT CURTIME()";
 * 	SQLExecDirect(sSQL);
 * 	SQLFetch();
 * 	return SQLGetData(1);
 * }
 *
 *
 * int getRLDaysInHBs(int nDays) {
 * 	return 14400*nDays;//60 Sekunden*60 Minuten*24 Stunden*nDays/6 Sekunden
 * }
 *
 * int getHBsInRLDays(int nHBs) {
 * 	return nHBs/14400;
 * }
 *
 * int getRLHoursInHBs(int nHours) {
 * 	return 600*nHours;
 * }
 *
 * int getHBsInRLHours(int nHBs) {
 * 	return nHBs/600;
 * } */


void bug(string sMessage) {
	sMessage = "(BUG!) " + sMessage;
	SendMessageToAllDMs(sMessage);
	WriteTimestampedLogEntry(sMessage);
}



float GetElevationBetween(object oA, object oB) {
	if ( !GetIsObjectValid(oA) || !GetIsObjectValid(oB)
		|| ( GetArea(oA) != GetArea(oB) ) )
		return 0.0;

	vector vA = GetPosition(oA);
	vector vB = GetPosition(oB);

	return vB.z - vA.z;
}


int MakeThrow(int nDC, int nDFaces, int nDCount, int nMod, int bDisplayToAll = FALSE) {
	int i;
	int nThrow = 0;

	for ( i = 0; i < abs(nDCount); i++ ) {
		nThrow += Random(nDFaces);;
	}
	if ( nThrow == nDCount )
		return 0;

	if ( nThrow == nDFaces * nDCount )
		return 1;

	nThrow += nMod;

	return nThrow >= nDC;
}




int GetPCCount(object oArea = OBJECT_INVALID, int bOnlyDMs = FALSE) {
	int i = 0;
	object o = GetFirstPC();
	while ( GetIsObjectValid(o) ) {
		if ( GetIsPC(o) ) {
			if ( !GetIsObjectValid(oArea) ) {
				if ( bOnlyDMs ) {
					if ( GetIsDM(o) )
						i++;
				} else
					i++;

			} else if ( oArea == GetArea(o) ) {
				if ( bOnlyDMs ) {
					if ( GetIsDM(o) )
						i++;
				} else
					i++;
			}
		}
		o = GetNextPC();
	}
	return i;
}

int GetPCPartyCount(object oPC) {
	int i = 0;
	object o = GetFirstFactionMember(oPC, 1);
	while ( GetIsObjectValid(o) ) {
		if ( GetIsPC(o) )
			i++;

		o = GetNextFactionMember(oPC, 1);
	}
	return i;
}
