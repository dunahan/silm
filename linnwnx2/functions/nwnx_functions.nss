// Name     : NWNX functions
// Purpose  : Various new functions for objects
// Author   : Ingmar Stieger (Papillon)
// Author   : virusman
// Modified : February 2, 2007

// This file is licensed under the terms of the
// GNU GENERAL PUBLIC LICENSE (GPL) Version 2

#include "nwnx_functions_h"

/************************************/
/* Function prototypes              */
/************************************/

// Get the AC of armor oObject
int GetArmorAC(object oObject);

// Set the AC of armor oObject
void SetArmorAC(object oObject, int iAC);

// Set the gold piece value of oObject
void SetGoldPieceValue(object oObject, int iValue);

// Set tag of oObject to sValue
void SetTag(object oObject, string sValue);

// Set the racial type of oObject
// - nRacialType: RACIAL_TYPE_*
void SetRacialType(object oObject, int nRacialType);

// Get the length of oObject's description
// Works with items, placeables, doors and creatures
int GetDescriptionLength(object oObject);

// Get description of oObject
// Works with items, placeables, doors and creatures
string GetDescription(object oObject);

// Set description of oObject
// Works with items, placeables, doors and creatures
void SetDescription(object oObject, string sNewDescription);

// Get NPC's conversation resource name
string GetConversation(object oObject);

// Returns TRUE if the item is undroppable
int GetUndroppableFlag(object oItem);

// Set the Droppable flag on an item
// - oItem: the item to change
// - bUndroppable: TRUE or FALSE, whether the item is undroppable
void SetUndroppableFlag(object oItem, int bUndroppable);

// Get the weight of an item in tenths of pounds
int GetItemWeight(object oObject);

// Set item weight
// - oObject: the item to change
// - nWeight: new weight in tenths of pounds
// NOTE: Weight is recalculated from baseitems.2da on every player login
void SetItemWeight(object oObject, int nWeight);

// Get event handler for a creature
// - oObject: the target creature
// - nEventId: CREATURE_EVENT_* (see nwnx_functions_h)
string GetEventHandler(object oObject, int nEventId);

// Set event handler for a creature
// - oObject: the target creature
// - nEventId: CREATURE_EVENT_* (see nwnx_functions_h)
// - sScript: script file name
void SetEventHandler(object oObject, int nEventId, string sScript);

// Get Faction ID of an object
int GetFactionID(object oObject);

// Set Faction ID of an object
void SetFactionID(object oObject, int nFaction);

//Returns ground height of the location
float GetGroundHeight(location lLocation);

//Returns TRUE if the position is walkable
int GetIsWalkable(location lLocation);

object GetFirstArea();
object GetNextArea();

//Restart the server
//Works only with NWNX Reset Plugin installed
void RestartServer();

//For development purposes
void DebugMe(object oObject);

// Dump oObject
// Developers use only
void ObjectDump(object oObject);


/************************************/
/* Implementation                   */
/************************************/

int GetArmorAC(object oObject)
{
    string sAC;
    SetLocalString(oObject, "NWNX!FUNCTIONS!GETARMORAC", "      ");
    sAC = GetLocalString(oObject, "NWNX!FUNCTIONS!GETARMORAC");
    return StringToInt(sAC);
}

void SetArmorAC(object oObject, int iAC)
{
    SetLocalString(oObject, "NWNX!FUNCTIONS!SETARMORAC", IntToString(iAC));
}

void SetGoldPieceValue(object oObject, int iValue)
{
    SetLocalString(oObject, "NWNX!FUNCTIONS!SETGOLDPIECEVALUE", IntToString(iValue));
}

void SetTag(object oObject, string sValue)
{
    SetLocalString(oObject, "NWNX!FUNCTIONS!SETTAG", sValue);
}

void SetRacialType(object oObject, int nRacialType)
{
    SetLocalString(oObject, "NWNX!FUNCTIONS!SETRACIALTYPE", IntToString(nRacialType));
}

int GetDescriptionLength(object oObject)
{
    int nDescLength;
    SetLocalString(oObject, "NWNX!FUNCTIONS!GETDESCRIPTIONLENGTH", "          ");
    nDescLength = StringToInt(GetLocalString(oObject, "NWNX!FUNCTIONS!GETDESCRIPTIONLENGTH"));
    return nDescLength;
}

string GetDescription(object oObject)
{
    string sDesc;
    SetLocalString(oObject, "NWNX!FUNCTIONS!GETDESCRIPTION", "                                                                                                                                                                                                                                                            ");
    sDesc = GetLocalString(oObject, "NWNX!FUNCTIONS!GETDESCRIPTION");
    return sDesc;
}

void SetDescription(object oObject, string sNewDescription)
{
    SetLocalString(oObject, "NWNX!FUNCTIONS!SETDESCRIPTION", sNewDescription);
}

string GetConversation(object oObject)
{
    string sConv;
    SetLocalString(oObject, "NWNX!FUNCTIONS!GETCONVERSATION", "                 ");
    sConv = GetLocalString(oObject, "NWNX!FUNCTIONS!GETCONVERSATION");
    return sConv;
}

int GetUndroppableFlag(object oItem)
{
    string sUndroppable;
    SetLocalString(oItem, "NWNX!FUNCTIONS!GETUNDROPPABLE", "      ");
    sUndroppable = GetLocalString(oItem, "NWNX!FUNCTIONS!GETUNDROPPABLE");
    return StringToInt(sUndroppable);
}

void SetUndroppableFlag(object oItem, int bUndroppable)
{
    SetLocalString(oItem, "NWNX!FUNCTIONS!SETUNDROPPABLE", IntToString(bUndroppable));
}

int GetItemWeight(object oObject)
{
    string sWeight;
    SetLocalString(oObject, "NWNX!FUNCTIONS!GETITEMWEIGHT", "      ");
    sWeight = GetLocalString(oObject, "NWNX!FUNCTIONS!GETITEMWEIGHT");
    return StringToInt(sWeight);
}

void SetItemWeight(object oObject, int nWeight)
{
    SetLocalString(oObject, "NWNX!FUNCTIONS!SETITEMWEIGHT", IntToString(nWeight));
}

string GetEventHandler(object oObject, int nEventId)
{
    string sDesc;
    SetLocalString(oObject, "NWNX!FUNCTIONS!GETEVENTHANDLER", IntToString(nEventId)+"                                                                                                                                                                                                                                                            ");
    sDesc = GetLocalString(oObject, "NWNX!FUNCTIONS!GETEVENTHANDLER");
    return sDesc;
}

void SetEventHandler(object oObject, int nEventId, string sScript)
{
    SetLocalString(oObject, "NWNX!FUNCTIONS!SETEVENTHANDLER", IntToString(nEventId)+":"+sScript);
}

int GetFactionID(object oObject)
{
    int nFaction;
    SetLocalString(oObject, "NWNX!FUNCTIONS!GETFACTION", "        ");
    nFaction = StringToInt(GetLocalString(oObject, "NWNX!FUNCTIONS!GETFACTION"));
    return nFaction;
}

void SetFactionID(object oObject, int nFaction)
{
    SetLocalString(oObject, "NWNX!FUNCTIONS!SETFACTION", IntToString(nFaction));
}

float GetGroundHeight(location lLocation)
{
    vector vLocation = GetPositionFromLocation(lLocation);
    SetLocalString(GetModule(), "NWNX!FUNCTIONS!GETGROUNDHEIGHT", ObjectToString(GetAreaFromLocation(lLocation))+"�"+FloatToString(vLocation.x)+"�"+FloatToString(vLocation.y)+"�"+FloatToString(vLocation.z));
    return StringToFloat(GetLocalString(GetModule(), "NWNX!FUNCTIONS!GETGROUNDHEIGHT"));
}

int GetIsWalkable(location lLocation)
{
    vector vLocation = GetPositionFromLocation(lLocation);
    SetLocalString(GetModule(), "NWNX!FUNCTIONS!GETISWALKABLE", ObjectToString(GetAreaFromLocation(lLocation))+"�"+FloatToString(vLocation.x)+"�"+FloatToString(vLocation.y)+"�"+FloatToString(vLocation.z));
    return StringToInt(GetLocalString(GetModule(), "NWNX!FUNCTIONS!GETISWALKABLE"));
}

object GetFirstArea()
{
    return GetLocalObject(GetModule(), "NWNX!FUNCTIONS!GET_FIRST_AREA");
}

object GetNextArea()
{
    return GetLocalObject(GetModule(), "NWNX!FUNCTIONS!GET_NEXT_AREA");
}

void DebugMe(object oObject)
{
    SetLocalString(oObject, "NWNX!FUNCTIONS!DEBUGME", "      ");
}

void ObjectDump(object oObject)
{
    SetLocalString(oObject, "NWNX!FUNCTIONS!OBJDUMP", "      ");
}

void RestartServer()
{
    SetLocalString(GetModule(), "NWNX!RESETPLUGIN!SHUTDOWN", "1");
}
