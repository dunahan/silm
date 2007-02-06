// Name     : NWNX functions
// Purpose  : Various new functions for items
// Author   : Ingmar Stieger (Papillon)
// Modified : Apr 24, 2004 by Carsten Pluntke (Narron)

// This file is licensed under the terms of the
// GNU GENERAL PUBLIC LICENSE (GPL) Version 2

/************* /
 * /* Constants */
/*************/

/*const int NWNX_BODYPART_LOW = 3;
 * const int NWNX_BODYPART_GENDER = 3;
 * const int NWNX_BODYPART_COLOR_SKIN = 4;
 * const int NWNX_BODYPART_COLOR_HAIR = 5;
 * const int NWNX_BODYPART_COLOR_TATTOO_1 = 6;
 * const int NWNX_BODYPART_COLOR_TATTOO_2 = 7;
 * const int NWNX_BODYPART_FOOT_R = 8;
 * const int NWNX_BODYPART_FOOT_L = 9;
 * const int NWNX_BODYPART_SHIN_R = 10;
 * const int NWNX_BODYPART_SHIN_L = 11;
 * const int NWNX_BODYPART_THIGH_L = 12;
 * const int NWNX_BODYPART_THIGH_R = 13;
 * const int NWNX_BODYPART_PELVIS = 14;
 * const int NWNX_BODYPART_TORSO = 15;
 * const int NWNX_BODYPART_BELT = 16;
 * const int NWNX_BODYPART_NECK = 17;
 * const int NWNX_BODYPART_FOREARM_R = 18;
 * const int NWNX_BODYPART_FOREARM_L = 19;
 * const int NWNX_BODYPART_BICEP_R = 20;
 * const int NWNX_BODYPART_BICEP_L = 21;
 * const int NWNX_BODYPART_SHOULDER_R = 22;
 * const int NWNX_BODYPART_SHOULDER_L = 23;
 * const int NWNX_BODYPART_HAND_R = 24;
 * const int NWNX_BODYPART_HAND_L = 25;
 * const int NWNX_BODYPART_UNKNOWN = 26;
 * const int NWNX_BODYPART_HEAD = 27;
 * const int NWNX_BODYPART_TAIL = 28;
 * const int NWNX_BODYPART_WING = 29;
 * const int NWNX_BODYPART_HIGH = 29;*/


/************************************/
/* Function prototypes              */
/************************************/

// Initialization
void InitNWNX();

// Returns TRUE if NWNX is running
int NWNX_Initialized();


/************************************/
/* Implementation                   */
/************************************/



void InitNWNX() {
	int i;
	string sMemory = ".";
	object oMod = GetModule();
	SetLocalString(oMod, "NWNX!INIT", "1");
	//NWNX changes the value on its own.
	if ( GetLocalString(oMod, "NWNX!INIT") == "0" ) {
		WriteTimestampedLogEntry("NWNX subsystem initialized.");
		SetLocalInt(oMod, "NWNX_Init", 1);
	} else {
		WriteTimestampedLogEntry("No NWNX subsystem found.");
		return;
	}
	SetLocalString(oMod, "NWNX!INIT", "0");

	// allocate a 1k buffer to pass to the NWNX plugin
	for ( i = 0; i < 5; i++ )
		sMemory = sMemory + sMemory + sMemory + sMemory;
	// only use the NWNX! prefix if it's meant to be
	// processed by the plugin
	SetLocalString(oMod, "NWNX_buffer", sMemory);

	// connect to localhost:2182
	SetLocalString(oMod, "NWNX!MNX!OPEN!DATE!", "localhost:2182");
	WriteTimestampedLogEntry("MNX communication established.");
}

int NWNX_Initialized() {
	return GetLocalInt(GetModule(), "NWNX_Init");
}

/*int GetBodyPart(object oTgt, int nPart)
 * {
 * 	SetLocalString(oTgt,"NWNX!FUNCTIONS!GETBODYPART",
 * 		IntToString(nPart));
 * 	string sType = GetLocalString(oTgt,"NWNX!FUNCTIONS!GETBODYPART");
 * 	return StringToInt(sType);
 * }
 *
 * void SetBodyPart(object oTgt, int nPart, int nType)
 * {
 * 	SetLocalString(oTgt,"NWNX!FUNCTIONS!SETBODYPART",
 * 		IntToString(nPart)+"!"+IntToString(nType));
 * }
 *
 * //Thread- and multiple-call-safe SetBodyPart(), which automagically makes
 * //the changes visible.
 * void SafeSetBodyPart(object oTgt, int nPart, int nType, int iFlash=FALSE)
 * {
 * int iOldApp = GetAppearanceType(oTgt);
 * SetBodyPart(oTgt,nPart,nType);
 * if(!GetLocalInt(oTgt,"_BODY_UPDATE"))
 * {
 * 	if(iFlash)
 * 	  ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
 * 		EffectVisualEffect(VFX_IMP_HEALING_X),oTgt,1.5f);
 * 	SetCreatureAppearanceType(oTgt,APPEARANCE_TYPE_INVISIBLE_HUMAN_MALE);
 * 	SetLocalInt(oTgt,"_BODY_UPDATE",1);
 * 	DelayCommand(1.0f,SetCreatureAppearanceType(oTgt,iOldApp));
 * 	DelayCommand(1.1f,DeleteLocalInt(oTgt,"_BODY_UPDATE"));
 * }
 * }        */

// Sends a Key or a Key/Value pair to the mNWNX plugin
/*void mnxSetString(string sKey, string sValue="") {
 * 	object oModule = GetModule();
 *
 * 	SetLocalString(oModule, "NWNX!MNX!SEND!DATE!"+sKey+"!"+sValue,
 * 		  GetLocalString(oModule, "NWNX_buffer"));
 * }
 *
 * string mnxGetString(string sKey, string sValue="") {
 * 	mnxSetString(sKey,sValue);
 *
 * 	// check the return
 * 	string results = GetLocalString(GetModule(), "NWNX!MNX!SEND!DATE!"+sKey+"!"+sValue);
 * 	DeleteLocalString(GetModule(),"NWNX!MNX!SEND!DATE!"+sKey+"!"+sValue);
 *
 * 	/*
 * 	// look for the terminator
 * 	int iPos = FindSubString(results, "�");
 * 	if(iPos == -1)
 * 		return "*** no plugin ***";
 *
 * 	return GetStringLeft(results, iPos);
 * /
 * 	return results;
 * } */

// Need to sync the engine to the client otherwise effects
// stack.  SetCreatureAppearanceType() can do this, but it
// must be a change and not application of their current type.
// Therefore we need a pair.  A delay of about 1.0 second seems
// to be the safe minium between them.

// Hide SetCreatureAppearanceType() effects with a flashy effect.
// You can also do this with Cutscene Invisibility applied before
// the first SCAT();

//void ObjDump(object oTgt)
//{
//  SetLocalString(oTgt,"NWNX!FUNCTIONS!OBJDUMP","Empty");
//}

// void main() { }
