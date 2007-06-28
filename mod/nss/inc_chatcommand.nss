/*
 * This file contains chat commands.
 */

#include "inc_mnx"

#include "_const"
#include "inc_chat_lib"
#include "_gen"
#include "inc_target"
#include "inc_limbo"
#include "inc_cdb"
#include "inc_dbplac"
#include "inc_security"
#include "inc_getopt"
#include "inc_craft_hlp"
#include "inc_decay"
#include "inc_mysql"

#include "inc_draw"
#include "inc_draw_text"

#include "inc_planewalk"

#include "x0_i0_anims"

#include "inc_mnx_temp"
#include "inc_xp_handling"

#include "inc_nwnx_func"
#include "inc_track"
#include "inc_objset"


int CommandManageSetItem(object oPC, int iMode);
int CommandManageSetSet(object oPC, int iMode);
int CommandManageSetClear(object oPC, int iMode);

int CommandShowWeather(object oPC, int iMode);

int CommandTag(object oPC, int iMode);

int CommandDescription(object oPC, int iMode);

int CommandGetDyePot(object oPC, int iMode);

int CommandCastSpell(object oPC, int iMode);

int CommandOhHellBang(object oPC, int iMode);


int CommandRotate(object oPC, int iMode);
int CommandHP(object oPC, int iMode);

int CommandRepeat(object oPC, int iMode);

int CommandCreateKey(object oPC, int iMode);
int CommandLock(object oPC, int iMode);

int CommandPlaneWalk(object oPC, int iMode);

int CommandLastLog(object oPC, int iMode);

int CommandRemind(object oPC, int iMode);

int CommandUptime(object oPC, int iMode);

int CommandRMNX(object oPC, int iMode);

int CommandDraw(object oPC, int iMode);
int CommandDrawText(object oPC, int iMode);

int CommandPortrait(object oPC, int iMode);

int CommandPlaceable(object oPC, int iMode);
int CommandCreature(object oPC, int iMode);
int CommandArea(object oPC, int iMode);
int CommandItem(object oPC, int iMode);

int CommandGetRecipe(object oPC, int iMode);



int CommandCharges(object oPC, int iMode);


int CommandOOC(object oPC, int iMode);

int CommandSubRace(object oPC, int iMode);
int CommandEffect(object oPC, int iMode);
int CommandWeather(object oPC, int iMode);
int CommandXP(object oPC, int iMode);


int CommandPassword(object oPC, int iMode);

int CommandInfo(object oPC, int iMode);
int CommandTarget(object oPC, int iMode);
int CommandStatus(object oPC, int iMode);
int CommandRandomWalk(object oPC, int iMode);
int CommandCopyObject(object oPC, int iMode);
int CommandJump(object oPC, int iMode);
int CommandFetch(object oPC, int iMode);

int CommandWWP(object oPC, int iMode);
int CommandCAQ(object oPC, int iMode);

int CommandFollow(object oPC, int iMode);

int CommandBodyPart(object oPC, int iMode);

int CommandWing(object oPC, int iMode);
int CommandTail(object oPC, int iMode);

int CommandLimbo(object oPC, int iMode);

int CommandColour(object oPC, int iMode);


int CommandCopyMod(object oPC, int iMode);

int CommandFix(object oPC, int iMode);


// Shuns a player: may not send private messages anymore, to all and anyone.
// DM only.
int CommandShunUnshun(object oPC, int iMode, int iState);

int CommandFleshToStone(object oPC, int iMode);
int CommandStoneToFlesh(object oPC, int iMode);

// Returns some info about a logged in player.
// DM only.


/* Player-specific ignore list! */
int CommandIgnoreList(object oPC, int iMode, int iState);


int CommandShowObj(object oPC, int iMode);
int CommandKillObj(object oPC, int iMode);

int CommandVoiceChat(object oPC, string sArg, int iMode);

// Syntax: .dice sides of dice, number of dice
int CommandDice(object oPC, int iMode);

int CommandAnimation(object oPC, string sArg, int iMode);



// Sets the name of a specified target.
// DM only.
int CommandSetName(object oPC, int iMode);

int CommandSetAppearance(object oPC, int iMode);
int CommandSetPhenotype(object oPC, int iMode);

int CommandLimbo(object oPC, int iMode);

int CommandFixFactions(object oPC, int iMode);

int CommandGetTargetChooser(object oPC, int iMode);
int CommandRestore(object oPC, int iMode);

int CommandVFX(object oPC, int iMode);
int CommandFX(object oPC, int iMode);

int CommandGetVar(object oPC, int iMode);
int CommandSetVar(object oPC, int iMode);
int CommandKill(object oPC, int iMode);
int CommandKick(object oPC, int iMode);

int CommandCreate(object oPC, int iMode);


int CommandShowConst(object oPC, int iMode);


int CommandSay(object oPC, int iMode);

int CommandWrite(object oPC, int iMode);


int CommandAFK(object oPC, int iMode);

int CommandReadTracks(object oPC, int iMode);


int CommandRehash(object oPC, int iMode);

int CommandIndicate(object oPC, int iMode);


int CommandGo(object oPC, int iMode);
int CommandGoReturn(object oPC, int iMode);
int CommandNudge(object oPC, int iMode);

int CommandEventHandler(object oPC, int iMode);

/* implementation */

// This is a stub you can copypaste to implement your own command.
// Return 1 to indicate "valid command", or 0 for "invalid command"
// Don't forget to register your command in msg_chat.
// oPC is the PC talking.
// iMode is the mode flag on which channel the message was sent on.
//   Refer to the header of "_chat" for a list.
// Note that the executing object is oPC itself; it is merely passed
// in as a convenience.
int CommandStub(object oPC, int iMode) {
	return OK;
}

int CommandManageSetItem(object oPC, int iMode) {
	string name = arg(0);
	object oI = CreateItemOnObject("move_target_g", oPC);
	SetLocalString(oI, "objset_name", name);
	SetName(oI, "group: " + name);
	return OK;
}

int CommandManageSetAdd(object oPC, int iMode) {
	string set = GetCurrentSet(oPC);
	if ("" == set) {
		ToPC("No group set.");
		return FAIL;
	}
	AddToSet(set, oPC, GetTarget());
	ToPC("groupadd: " + set + " -> " + GetName(GetTarget()));
	return OK;
}

int CommandManageSetSet(object oPC, int iMode) {
	string new = arg(0);
	if ("" == new) {
		ToPC("group: " + GetCurrentSet(oPC));
	} else {
		ToPC("groupsel: " + new);
		SetCurrentSet(new, oPC);
	}
	return OK;
}

int CommandManageSetClear(object oPC, int iMode) {
	string set = GetCurrentSet(oPC);
	if (opt("s"))
		set = optv("s");
	
	ClearSet(set, oPC);
	ToPC("groupclear: " + set);
	return OK;
}


int CommandEventHandler(object oPC, int iMode) {
	object oT = GetTarget();

	if (argc() == 2) {
		string sEvent = arg(0);
		string sVal = arg(1);
		if ("heartbeat" == sEvent)
			SetEventHandler(oT, CREATURE_EVENT_HEARTBEAT, sVal);
		else if ("perception" == sEvent)
			SetEventHandler(oT, CREATURE_EVENT_PERCEPTION, sVal);
		else if ("spellcast" == sEvent)
			SetEventHandler(oT, CREATURE_EVENT_SPELLCAST, sVal);
		else if ("attacked" == sEvent)
			SetEventHandler(oT, CREATURE_EVENT_ATTACKED, sVal);
		else if ("damaged" == sEvent)
			SetEventHandler(oT, CREATURE_EVENT_DAMAGED, sVal);
		else if ("endcombat" == sEvent)
			SetEventHandler(oT, CREATURE_EVENT_ENDCOMBAT, sVal);
		else if ("conversation" == sEvent)
			SetEventHandler(oT, CREATURE_EVENT_CONVERSATION, sVal);
		else if ("spawn" == sEvent)
			SetEventHandler(oT, CREATURE_EVENT_SPAWN, sVal);
		else if ("rested" == sEvent)
			SetEventHandler(oT, CREATURE_EVENT_RESTED, sVal);
		else if ("death" == sEvent)
			SetEventHandler(oT, CREATURE_EVENT_DEATH, sVal);
		else if ("userdef" == sEvent)
			SetEventHandler(oT, CREATURE_EVENT_USERDEF, sVal);
		else if ("blocked" == sEvent)
			SetEventHandler(oT, CREATURE_EVENT_BLOCKED, sVal);
		else {
			ToPC("Unknown event: " + sEvent);
			return FAIL;
		}
	} else if (argc() != 0) {
		ToPC("Syntax error: 0 or 2 arguments.");
		return SYNTAX;
	}

	ToPC("heartbeat: " + GetEventHandler(oT, CREATURE_EVENT_HEARTBEAT));
	ToPC("perception: " + GetEventHandler(oT, CREATURE_EVENT_PERCEPTION));
	ToPC("spellcast: " + GetEventHandler(oT, CREATURE_EVENT_SPELLCAST));
	ToPC("attacked: " + GetEventHandler(oT, CREATURE_EVENT_ATTACKED));
	ToPC("damaged: " + GetEventHandler(oT, CREATURE_EVENT_DAMAGED));
	ToPC("endcombat: " + GetEventHandler(oT, CREATURE_EVENT_ENDCOMBAT));
	ToPC("conversation: " + GetEventHandler(oT, CREATURE_EVENT_CONVERSATION));
	ToPC("spawn: " + GetEventHandler(oT, CREATURE_EVENT_SPAWN));
	ToPC("rested: " + GetEventHandler(oT, CREATURE_EVENT_RESTED));
	ToPC("death: " + GetEventHandler(oT, CREATURE_EVENT_DEATH));
	ToPC("userdef: " + GetEventHandler(oT, CREATURE_EVENT_USERDEF));
	ToPC("blocked: " + GetEventHandler(oT, CREATURE_EVENT_BLOCKED));

	return OK;
}



int CommandNudge(object oPC, int iMode) {

	object oTarget = GetTarget();
	
	if (!GetIsObjectValid(oTarget))
		return NotifyBadTarget();
	
	float
		x = StringToFloat(optv("x")),
		y = StringToFloat(optv("y")),
		z = StringToFloat(optv("z"));

	if (0f == x && 0f == y && 0f == z) {
		ToPC("nothing to be done.");
		return OK;
	}
	
	location loc = GetLocation(oTarget);
	vector pos = GetPositionFromLocation(loc);
	object area = GetAreaFromLocation(loc);
	float facing = GetFacingFromLocation(loc);
	
	pos.x += x;
	pos.y += y;
	pos.z += z;
	
	loc = Location(area, pos, facing);

	if (GetIsPlaceable(oTarget)) {
		object oNew = CreateObject(OBJECT_TYPE_PLACEABLE, GetResRef(oTarget), loc, FALSE, GetTag(oTarget)); // CopyObject(oTarget, loc);
		if (GetIsObjectValid(oNew)) {
			ToPC("done, create/kill placeable.");
			DestroyObject(oTarget, 0.2f);
		}
		else {
			ToPC("Cannot copy object to new location.");
			return FAIL;
		}
	} else {
		AssignCommand(oTarget, ActionJumpToLocation(loc));
		ToPC("done, action queued.");
	}

	return OK;
}

int CommandGo(object oPC, int iMode) {
	string loc = arg(0);
	struct mnxRet r = mnxCmd("location_count", loc);

	if (r.error) {
		ToPC("Command failed. Check rmnx error logs.");
		return FAIL;
	}

	int count = StringToInt(
		GetStringLeft(r.ret, FindSubString(r.ret, "#"))
	);
	loc = GetSubString(r.ret, FindSubString(r.ret, "#") + 1, 1024);

	if (0 == count) {
		ToPC("No locations found matching your criteria.");
		return FAIL;
	}

	if (count > 1) {
		ToPC("Ambigious location. Matches:");
		ToPC(loc);
		return FAIL;
	}

	r = mnxCmd("location", loc);
	if (r.error) { 
		ToPC("Command failed Check rmnx error logs. (2)");
		return FAIL;
	}

	location l;
	string swhat = GetStringLeft(r.ret, 1);
	string srest = GetSubString(r.ret, 1, 1024 * 12);

	if ("l" == swhat)
		l = nStringToLocation(srest);
	else if ("p" == swhat) {
		object target = GetPCByCID(StringToInt(srest));
		l = GetLocation(target);
	} else if ("t" == swhat) {
		l = GetLocation(GetObjectByTag(srest));
	} else {
		ToPC("Command failed (3).");
		return FAIL;
	}

	if (!GetIsObjectValid(GetAreaFromLocation(l))) {
		ToPC("This is not a valid location.");
		return FAIL;
	}

	SetLocalLocation(oPC, "go_last_location", GetLocation(oPC));
	JumpToLocation(l);
	return OK;
}

int CommandGoReturn(object oPC, int iMode) {
	location l = GetLocalLocation(oPC, "go_last_location");
	JumpToLocation(l);
	return OK;
}

int CommandInspect(object oPC, int iMode) {
	float fRadius = 60.0;
	float fDuration = 4.0;

	int bPersistencies = opt("pl");
	
	int nShow = 0;

	if (bPersistencies) {
		int i = 1;
		object oN = GetNearestObject(OBJECT_TYPE_PLACEABLE, oPC, i);
		while (GetIsObjectValid(oN)) {
			if (GetPlaceableID(oN) > 0) {
				effect eglow = EffectVisualEffect(VFX_DUR_GLOW_BROWN);
				DelayCommand(IntToFloat(i) * 0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eglow, oN, fDuration));
				nShow += 1;
			}
			i += 1;
			oN = GetNearestObject(OBJECT_TYPE_PLACEABLE, oPC, i);
		}
		ToPC("Showing all persistent placeables within " + FloatToString(fRadius) + " for " + FloatToString(fDuration) + ": " + IntToString(nShow));

	}
	return OK;

}


int CommandSQL(object oPC, int iMode) {
	string query = arg(0);

	SQLQuery(query);
	
	return OK;
}

int CommandpSQL(object oPC, int iMode) {
	string query = arg(0);

	pQ(query);
	
	return OK;
}


int CommandRehash(object oPC, int iMode) {
	pQ("select key, type, value, date_part('epoch', now())::int from gv;");
	int c;
	string cacheKey;
	while (pF()) {
		c += 1;
		cacheKey = "gv_" + pG(2) + "_" + pG(1);
		SetLocalInt(GetModule(), cacheKey, StringToInt(pG(4)));
		SetLocalString(GetModule(), cacheKey, pG(3));
	}
	ToDMs("Rehashed " + IntToString(c) + " gvs.");
	return OK;
}


void VoidCreateItemOnObject(string sItemTemplate, object oTarget = OBJECT_SELF, int nStackSize = 1,
							string sNewTag = "") {
	CreateItemOnObject(sItemTemplate, oTarget, nStackSize, sNewTag);
}


// Lists all herbs and sends the results via message.
void ListHerbs(object oTarget) {
	int nTotal = 0, nStack = 0;
	string sRef;

	object oHerb = GetFirstItemInInventory(oTarget);

	while ( GetIsObjectValid(oHerb) ) {
		sRef = GetResRef(oHerb);
		if ( GetStringLeft(sRef, 4) == "herb" ) {
			nStack = GetItemStackSize(oHerb);
			nTotal += nStack;
		}

		oHerb = GetNextItemInInventory(oTarget);
	}
	SendMessageToPC(oTarget, "You have " + IntToString(nTotal) + " herbs in total in your inventory.");
}


int CommandFix(object oPC, int iMode) {
	string sWhat = arg(0);
	object oTarget = GetTarget();
	string sRef = "";

	int nFixed = 0;
	int nStack = 1;

	float fDelay = 5.0;

	if ( "herbs" == sWhat ) {
		ListHerbs(oPC);

		object oHerb = GetFirstItemInInventory(oTarget);
		int nThisHerbCount = 0;


		while ( GetIsObjectValid(oHerb) ) {
			sRef = GetResRef(oHerb);
			if ( GetStringLeft(sRef, 4) == "herb" ) {
				nStack = GetItemStackSize(oHerb);
				if ( 239 > GetBaseItemType(oHerb) ) {
					// its an old herb
					fDelay += 0.1;
					DelayCommand(fDelay, DestroyObject(oHerb));
					fDelay += 0.1;
					DelayCommand(fDelay, VoidCreateItemOnObject(sRef, oTarget, nStack));
					nFixed += nStack;
				}
			}

			oHerb = GetNextItemInInventory(oTarget);
		}

		fDelay += 1.0;
		DelayCommand(fDelay, ListHerbs(oPC));
		fDelay += 1.0;
		DelayCommand(fDelay, SendMessageToPC(oPC, "Now is all done. Go do some evil."));

		SendMessageToPC(oPC, "Script will end its run in " +
			FloatToString(fDelay) + " seconds. Dont touch anything while its working, okay?");


	} else {
		SendMessageToPC(oPC, "Unknown value.");
		return FAIL;
	}

	SendMessageToPC(oPC, "Fixed " + IntToString(nFixed) + " entities.");
	return OK;
}



int CommandReadTracks(object oPC, int iMode) {
	//Spurenlesen

	if ( GetIsDM(oPC) )
		return ACCESS;

	if ( !GetLocalInt(GetModule(), "tracking") ) {
		SendMessageToPC(oPC, "Tracking is disabled.");
		return FAIL;
	}


	int nT = GetLocalInt(oPC, "use_active_tracking");
	SetLocalInt(oPC, "use_active_tracking", nT == 1 ? 0 : 1);
	if ( nT ) {
		SendMessageToPC(oPC, "Aktives Spurenlesen deaktiviert.");
	} else {
		SendMessageToPC(oPC, "Aktives Spurenlesen aktiviert.");
		string sMessage = arg(0);
		SetLocalInt(oPC, "active_tracking_message", sMessage != "");
	}

//    track(oPC);
//    CommandAnimation(oPC, "get_low", iMode);
	return OK;
}

int CommandAFK(object oPC, int iMode) {
	// is AFK?

/*    if (GetIsInCombat(oPC)) {
 * 		SendMessageToPC(oPC, "Du kannst nicht waehrend dem Kampfe AFK gehen.");
 * 		return ERROR;
 * 	}*/

	int nAFK = GetLocalInt(oPC, "afk");

	if ( nAFK > 0 ) {
		SetLocalInt(oPC, "afk", 0);

		effect e = GetFirstEffect(oPC);
		while ( GetIsEffectValid(e) ) {
			if ( GetEffectCreator(e) == oPC && GetEffectDurationType(e) == DURATION_TYPE_PERMANENT
				&& GetEffectType(e) == EFFECT_TYPE_VISUALEFFECT
				&& GetEffectSubType(e) == SUBTYPE_SUPERNATURAL ) {
				RemoveEffect(oPC, e);
				break;
			}

			e = GetNextEffect(oPC);
		}
		SendMessageToAllDMs(GetName(oPC) + " ist nicht mehr afk.");
		FloatingTextStringOnCreature("*Nicht mehr AFK*", oPC, TRUE);

	} else {
		AssignCommand(oPC, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(
						VFX_DUR_AFK)), oPC));
		SetLocalInt(oPC, "afk", 1 /* unix_ts? avoiding sql call for now*/);
		FloatingTextStringOnCreature("*AFK*", oPC, TRUE);
		SendMessageToAllDMs(GetName(oPC) + " ist afk.");
	}

	return OK;
}



int CommandObject(object oPC, int iMode) {
	return OK;
}

int CommandItem(object oPC, int iMode) {
	
	object oTarget = GetTarget();
	if (!GetIsItem(oTarget))
		return NotifyBadTarget();

	int weight = -1;
	int drop = -1;
	int value = -1;

	if (opt("weight"))
		weight = StringToInt(optv("weight"));
	if (opt("droppable"))
		drop = StringToBool(optv("droppable"));
	if (opt("value"))
		value = StringToInt(optv("value"));


	if (-1 != weight)
		SetItemWeight(oTarget, weight);
	if (-1 != drop)
		SetUndroppableFlag(oTarget, !drop);
	if (-1 != value)
		SetGoldPieceValue(oTarget, value);

	ToPC("Droppable: " + IntToString(GetUndroppableFlag(oTarget)));
	ToPC("Weight: " + IntToString(GetItemWeight(oTarget)));
	ToPC("Value: " + IntToString(GetGoldPieceValue(oTarget)));
	return OK;
}

int CommandCreature(object oPC, int iMode) {
	object oTarget = GetTarget();
	if ( !GetIsCreature(oTarget) && !GetIsPC(oTarget) )
		return NotifyBadTarget();

	int
	bImmortal = -1,
	bCommandable = -1,
	bPlot = -1,
	race = -1,
	faction = -1;

	if ( opt("plot") )
		bPlot = StringToBool(optv("plot"));

	if ( opt("i") )
		bImmortal = StringToBool(optv("i"));
	if ( opt("c") )
		bCommandable = StringToBool(optv("c"));

	if ( opt("race") )
		race = StringToInt(optv("race"));
	if ( opt("faction") )
		race = StringToInt(optv("faction"));
	

	if ( -1 != bImmortal )
		SetImmortal(oTarget, bImmortal);
	if ( -1 != bCommandable )
		SetCommandable(bCommandable, oTarget);
	
	if ( -1 != race )
		SetRacialType(oTarget, race);
	if ( -1 != faction )
		SetFactionID(oTarget, faction);

	ToPC("Commandable: " + IntToString(GetCommandable(oTarget)));
	ToPC("Plot: " + IntToString(GetPlotFlag(oTarget)));
	ToPC("Immortal: " + IntToString(GetImmortal(oTarget)));
	ToPC("RacialType: " + IntToString(GetRacialType(oTarget)));
	ToPC("Faction: " + IntToString(GetFactionID(oTarget)));
	ToPC("Conversation: " + GetConversation(oTarget));

	if ( opt("inv") )
		OpenInventory(oTarget, oPC);

	return OK;
}


int CommandPlaceable(object oPC, int iMode) {
	object oTarget = GetTarget();
	if ( !GetIsPlaceable(oTarget) )
		return NotifyBadTarget();

	int nUseable = -1;
	int nOpen = -1;
	int nPersist = -1;


	// Set/GetUseable
	if ( opt("useable") )
		nUseable = StringToBool(optv("useable"));

	if ( opt("persist") )
		nPersist = StringToBool(optv("persist"));

	if ( opt("open") )
		nOpen = StringToBool(optv("open"));

	if ( nUseable != -1 )
		SetUseableFlag(oTarget, nUseable);

	if ( nOpen != -1 ) {
		if ( !nOpen )
			AssignCommand(oTarget, ActionCloseDoor(oTarget));
		else
			AssignCommand(oTarget, ActionOpenDoor(oTarget));
	}

	int nIsPersistent = GetPlaceableID(oTarget) > 0;

	if ( nPersist != -1 ) {

		if ( nPersist == 0 ) {
			// Delete from DB
			if ( !nIsPersistent ) {
				ToPC("Placeable not in database.");
			} else {
				KillPlacie(oTarget, 0.0, FALSE);
				ToPC("Database entry removed.");
				nPersist = 0;
			}
		} else {
			// Add to DB
			if ( nIsPersistent ) {
				ToPC("Placeable is already persistent.");
			} else {
				int nResult = SavePlacie(oTarget);
				switch ( nResult ) {
					case SAVE_ERROR:
						ToPC("Cannot save placie.");
						break;
					case SAVE_NEW:
						ToPC("Made object persistent.");
						nIsPersistent = 1;
						break;
				}
			}
		}
	}

	/*
	 * string sText = arg(0);
	 * if ( nIsPersistent && GetStringLength(sText) > 0) {
	 * 	ToPC("Setting Scene Text to: " + sText);
	 * 	SQLQuery("delete from scene_descriptions where pid = " +
	 * 		IntToString(GetPlaceableID(oTarget)));
	 * 	SQLQuery("insert into scene_descriptions (pid, text) values(" +
	 * 		IntToString(GetPlaceableID(oTarget)) + ", " + SQLEscape(sText) +
	 * 		");");
	 * 	ToPC("Done.");
	 * }*/

	ToPC("Open: " + IntToString(GetIsOpen(oTarget)));
	ToPC("Useable: " + IntToString(GetUseableFlag(oTarget)));
	ToPC("Persistent: " + IntToString(GetPlaceableID(oTarget)));

	return OK;
}


int CommandShowWeather(object oPC, int iMode) {
	ShowAndUpdateWeather(GetArea(oPC), oPC);
	return OK;
}

int CommandDescription(object oPC, int iMode) {
	object oTarget = GetTarget();

	string sT = arg(0);
	if ( sT != "" ) {
		ToPC("Setting description ..");
		SetDescription(oTarget, sT);
	}

	ToPC("Description: " + GetDescription(oTarget));
	return OK;
}

int CommandTag(object oPC, int iMode) {
	object oTarget = GetTarget();

	string sT = arg(0);
	if ( sT != "" ) {
		ToPC("Setting tag ..");
		SetTag(oTarget, sT);
	}

	ToPC("Tag: " + GetTag(oTarget));
	return OK;
}


int CommandGetDyePot(object oPC, int iMode) {
	int nColour = StringToInt(arg(0));
	string sName = arg(1);

	if ( nColour < 1 || nColour > 175 )
		return FAIL;

	string sColour = IntToString(nColour);
	while ( GetStringLength(sColour) < 3 )
		sColour = "0" + sColour;

	string sTag = "x2_it_dye" + sColour;


	string sNewName = "Farbe";
	if ( sName != "" )
		sNewName = "Farbe: " + sName;

	object oPot = CreateItemOnObject("x2_it_dyec20", oPC, 1, sTag);
	SetName(oPot, sNewName);

	return OK;
}



int CommandCastSpell(object oPC, int iMode) {
	object oTarget = GetTarget();
	location lTarget = GetTargetLocation();

	if ( opt("loc") && !GetIsObjectValid(GetAreaFromLocation(lTarget)) )
		return NotifyBadTarget("bad location");

	if ( !opt("loc") && !GetIsObjectValid(oTarget) )
		return NotifyBadTarget();

	object oCaster = oPC;

	if ( opt("caster") )
		oCaster = GetTarget(StringToInt(optv("caster")));

	if ( !GetIsObjectValid(oCaster) )
		return NotifyBadTarget("bad caster");

	int nSpell = StringToInt(arg(0));
	if ( nSpell < 0 )
		return NotifyBadTarget("bad spell");

	int nMeta = METAMAGIC_ANY;
	if ( opt("m") )
		nMeta = StringToInt(optv("m"));

	int bCheat = TRUE;
	if ( opt("c") )
		bCheat = FALSE;

	int bInstant = FALSE;
	if ( opt("i") )
		bInstant = TRUE;


	// AssignCommand(oCaster, ClearAllActions(1));

	if ( opt("f") ) {
		if ( opt("loc") )
			DelayCommand(getsleep(), AssignCommand(oCaster, ActionCastFakeSpellAtLocation(nSpell, lTarget)));
		else
			DelayCommand(getsleep(), AssignCommand(oCaster, ActionCastFakeSpellAtObject(nSpell, oTarget)));

	} else {
		if ( opt("loc") )
			DelayCommand(getsleep(), AssignCommand(oCaster, ActionCastSpellAtLocation(nSpell, lTarget, nMeta,
						bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstant)));
		else
			DelayCommand(getsleep(), AssignCommand(oCaster, ActionCastSpellAtObject(nSpell, oTarget, nMeta,
						bCheat, PROJECTILE_PATH_TYPE_DEFAULT, bInstant)));
	}


	return OK;
}

int CommandOhHellBang(object oPC, int iMode) {
	int nNth = 1;
	int nAff = 0;
	float fDist = 60.0;

	object o = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oPC, nNth);
	while ( GetIsObjectValid(o) ) {
		if ( GetDistanceBetween(oPC, o) > fDist )
			break;

		if ( !GetImmortal(o) && !GetIsPC(o) && GetReputation(o, oPC) <= 10 ) {
			ApplyEffectToObject(DTI, EffectDamage(2048), o);
			nAff += 1;
		}

		nNth += 1;
		o = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oPC, nNth);
	}

	ToPC("Affected " + IntToString(nAff) + " suckers.");

	return OK;
}

int CommandRotate(object oPC, int iMode) {
	object oTarget = GetTarget();
	if ( !GetIsObjectValid(oTarget) )
		return NotifyBadTarget();

	string s = arg(0);
	if ( s == "" ) {
		ToPC("Rotation is: " + FloatToString(GetFacing(oTarget)));
	} else {
		float fRotation = GetAbsoluteOrRelativeValue(s, GetFacing(oTarget), 360.0);
		DelayCommand(getsleep(), AssignCommand(oTarget, SetFacing(fRotation)));
		ToPC("Done, rotating to " + FloatToString(fRotation));
	}

	return OK;
}




int CommandHP(object oPC, int iMode) {
	object oTarget = GetTarget();
	if ( 0 == GetMaxHitPoints(oTarget) )
		return NotifyBadTarget();

	string sHP = arg(0);

	if ( sHP == "" ) {} else {
		// parse percentage changes
		float fChange = GetAbsoluteOrRelativeValue(sHP, IntToFloat(GetCurrentHitPoints(oTarget)), IntToFloat(
								GetMaxHitPoints(oTarget)));
		if ( fChange == 0.0 ) {
			ToPC("No change.");
			return OK;
		}

		effect e;
		if ( fChange > 0.0 )
			e = EffectHeal(FloatToInt(fChange));
		else
			e = EffectDamage(FloatToInt(fChange));

		DelayCommand(getsleep(), ApplyEffectToObject(DTI, e, oTarget));
		DelayCommand(getsleep(), ToPC("Applied " + FloatToString(fChange)));
	}

	return OK;
}



int CommandCreateKey(object oPC, int iMode) {
	string
	sTag = arg(0),
	sName = arg(1);

	int nApp = -1;
	if ( opt("app") )
		nApp = StringToInt(optv("app"));

	object oKey = CreateItemOnObject("key_basic", oPC, 1, sTag);
	if ( nApp > -1 ) {
		object oKeyNew = CopyItemAndModify(oKey, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nApp, TRUE);
		DestroyObject(oKey);
		oKey = oKeyNew;
	}

	if ( sName != "" )
		SetName(oKey, sName);

	ToPC("Done.");
	return OK;
}




int CommandWrite(object oPC, int iMode) {
	string s = getoptargs();
	object oParchment = GetLocalObject(oPC, "paper_to_write");

	SetLocalString(oPC, "paper_text_to_write", s);
	FloatingTextStringOnCreature("Okay, Text gesetzt.", oPC, 0);
	return OK;
}



int CommandSay(object oPC, int iMode) {
	string sT = getoptarga();

	ActionSpeakString(sT);

	return OK;
}


int CommandTime(object oPC, int iMode) {
	int
	nYear  = GetCalendarYear(),
	nMonth = GetCalendarMonth(),
	nDay   = GetCalendarDay(),

	nHour  = GetTimeHour(),
	nMinute = GetTimeMinute(),
	nSecond = GetTimeSecond();

	int nChange = 0;

	if ( opt("yr") ) {
		nYear = StringToInt(optv("yr"));
		nChange = 1;
	}
	if ( opt("mo") ) {
		nMonth = StringToInt(optv("mo"));
		nChange = 1;
	}
	if ( opt("dy") ) {
		nDay = StringToInt(optv("dy"));
		nChange = 1;
	}

	if ( opt("hr") ) {
		nHour = StringToInt(optv("hr"));
		nChange = 1;
	}
	if ( opt("mn") ) {
		nMinute = StringToInt(optv("mn"));
		nChange = 1;
	}
	if ( opt("sc") ) {
		nSecond = StringToInt(optv("sc"));
		nChange = 1;
	}
	if ( nChange ) {
		SetTime(nHour, nMinute, nSecond, 0);
		SetCalendar(nYear, nMonth, nDay);

		nYear  = GetCalendarYear();
		nMonth = GetCalendarMonth();
		nDay   = GetCalendarDay();

		nHour  = GetTimeHour();
		nMinute = GetTimeMinute();
		nSecond = GetTimeSecond();
	}

	ToPC("Year: " + IntToString(nYear));
	ToPC("Month: " + IntToString(nMonth));
	ToPC("Day: " + IntToString(nDay));

	ToPC("Hour: " + IntToString(nHour));
	ToPC("Minute: " + IntToString(nMinute));
	ToPC("Second: " + IntToString(nSecond));

	return OK;
}


int CommandLock(object oPC, int iMode) {
	object oTarget = GetTarget();

	if ( !GetIsObjectValid(oTarget) )
		return NotifyBadTarget();

	string
	sKeyTag = "";
	int
	nLocked = -1,
	nLockable = -1,
	nKeyReq = -1,
	nLockDC = -1,
	nUnlockDC = -1;

	if ( opt("locked") )
		nLocked = StringToBool(optv("locked"));

	if ( opt("lockable") )
		nLockable = StringToBool(optv("lockable"));


	if ( opt("keytag") )
		sKeyTag = optv("keytag");

	if ( opt("keyreq") )
		nKeyReq = StringToBool(optv("keyreq"));

	if ( opt("lockdc") )
		nLockDC = StringToInt(optv("lockdc"));

	if ( opt("unlockdc") )
		nUnlockDC = StringToInt(optv("unlockdc"));

	if ( nLocked > -1 )
		SetLocked(oTarget, nLocked);

	if ( nLockable > -1 )
		SetLockLockable(oTarget, nLockable);

	if ( nLockDC > -1 )
		SetLockLockDC(oTarget, nLockDC);
	if ( nUnlockDC > -1 )
		SetLockUnlockDC(oTarget, nUnlockDC);
	if ( nKeyReq > -1 )
		SetLockKeyRequired(oTarget, nKeyReq);
	if ( sKeyTag != "" )
		SetLockKeyTag(oTarget, sKeyTag);

	ToPC("Locked: " + IntToString(GetLocked(oTarget)));
	ToPC("Lockable: " + IntToString(GetLockLockable(oTarget)));
	ToPC("LockDC: " + IntToString(GetLockLockDC(oTarget)));
	ToPC("UnlockDC: " + IntToString(GetLockUnlockDC(oTarget)));
	ToPC("KeyRequired: " + IntToString(GetLockKeyRequired(oTarget)));
	ToPC("KeyTag: " + GetLockKeyTag(oTarget));

	return OK;
}


int CommandPlaneWalk(object oPC, int iMode) {
	object oT = GetTarget();
	if ( !GetIsPC(oT) ) {
		return NotifyBadTarget();
	}

	string sPlane = "";
	if ( opt("plane") )
		sPlane = optv("plane");

	float fDuration = 120.0;
	if ( opt("duration") )
		fDuration = StringToFloat(optv("duration"));

	fDuration = fDuration < 5.0 ? 5.0 : fDuration;
	fDuration = fDuration > 200000.0 ? 200000.0 : fDuration;

	ToPC("Initiating planewalk.");
	PlaneWalk(oT, sPlane, fDuration);

	return OK;
}


int CommandRemind(object oPC, int iMode) {
	struct mnxRet r = mnxRun(oPC, "timedesc2sec", arg(0));
	if ( r.error ) {
		ToPC("Fehler: " + r.ret);
		return FAIL;
	}

	int nD = StringToInt(r.ret);
	if ( nD < 5 || nD > ( 60 * 60 * 24 * 7 ) ) {
		ToPC("Das ist keine gueltige Zeitangabe.");
		return FAIL;
	}

	DelayCommand(IntToFloat(nD), FloatingTextStringOnCreature("Erinnerung: " + arg(1) ==
			"" ? "Beep!" : arg(1), oPC, 0));
	ToPC("Erinnerung platziert.");
	return OK;
}

int CommandLastLog(object oPC, int iMode) {
	int nCount = 15;
	string sArea = pE(GetTag(GetArea(oPC)));

	if ( amask(oPC, AMASK_CAN_SEE_CHATLOGS) ) {
		if ( opt("count") )
			nCount = StringToInt(optv("count"));

		if ( nCount < 1 || nCount > 200 )
			nCount = 15;

		pQ("select ts,account_s,character_s,mode,text from chatlogs where area = "
			+ sArea +
			" and ts >= (select ts from chatlogs where area=" +
			sArea + " order by ts desc offset " + IntToString(nCount) + " limit 1)" +
			" order by ts asc;"
		);

	} else {
/*		SQLQuery("select timestamp,`account_s`,`character_s`,`mode`,`text` from `chatlogs` where `area` = "
			+ sArea +
			" and `timestamp` >= (select `timestamp` from `chatlogs` where `area`=" +
			sArea + " and `timestamp` >= substract(now(), interval 20 minute)" +
			" order by `timestamp` desc limit " + IntToString(nCount) + ",1)" +
			" order by `timestamp` asc;"
		);*/
		return FAIL;
	}

	while ( pF() ) {
		string
		sTS = pG(1),
		sAcc = pG(2),
		sChar = pG(3),
		sMode = pG(4),
		sText = pG(5);
		int nMode = StringToInt(sMode);

		if ( nMode & MODE_PRIVATE )
			continue;

		if ( nMode & MODE_COMMAND )
			continue;

		sMode = "";

		if ( nMode & MODE_PARTY )
			sMode += " [Party]";

		if ( nMode & MODE_SHOUT )
			sMode += " [Shout]";

		if ( nMode & MODE_WHISPER )
			sMode += " [Whisper]";


		if ( nMode & MODE_DM_MODE )
			sMode += " (DM)";


		ToPC("[" + sTS + "]" + sMode + " " + sChar + ": " + sText);
	}
	ToPC("End of /lastlog");

	return OK;
}



int CommandUptime(object oPC, int iMode) {
	string ret = mnxCommand("uptime");
	if ( mnxWasError() ) {
		ToPC("Data not available.");
		return FAIL;
	} else
		ToPC(ret);

	return OK;
}

int CommandRMNX(object oPC, int iMode) {
	string
	sCommand = arg(0),
	s0 = arg(1),
	s1 = arg(2),
	s2 = arg(3);

	object oT = GetTarget();

	string ret = mnxCommand(sCommand, s0, s1, s2);
	string err = "";
	ToPC("'" + sCommand + "(" + s0 + ", " + s1 + ", " + s2 + ")':");

	if ( mnxWasError() ) {
		err = mnxGetError();
		ToPC("ERROR: '" + err + "'");
		return FAIL;
	} else {
		ToPC("SUCCESS: '" + ret + "'");
	}

	return OK;
}


int CommandDraw(object oPC, int iMode) {

	return OK;
}



int CommandDrawText(object oPC, int iMode) {

	float
	fSpeed    = StringToFloat(optv("speed")),
	fLifeTime = StringToFloat(optv("lifetime")),
	fFontHeight = StringToFloat(optv("h")),
	fFontWidth = StringToFloat(optv("w")),
	fRotation  = StringToFloat(optv("r"));
	int nVFX = StringToInt(optv("vfx"));
	object oTarget = GetTarget();
	string sMsg = arg(0);
	if ( !opt("speed") ) fSpeed = 2.0;
	if ( !opt("lifetime") ) fLifeTime = 10.0;
	if ( !opt("h") ) fFontHeight = 0.5;
	if ( !opt("w") ) fFontWidth = 0.25;
	if ( !opt("vfx") ) nVFX = VFX_BEAM_FIRE_W_SILENT;

	// Delay TextMessage(sMsg, oTarget, fSpeed, fLifeTime, fFontHeight, fFontWidth, nVFX, fRotate);

	return OK;
}


int CommandGetRecipe(object oPC, int iMode) {
	int nID = StringToInt(arg(0));

	struct Recipe r =  FindRecipeByPlanOrComponents("", "", nID);
	if ( !GetIsRecipeValid(r) ) {
		SendMessageToPC(oPC, "Dieses Rezept gibt es nicht.");
		return OK;
	}

	object oItem = CreateItemOnObject("cp_basic", oPC, 1);
	if ( !GetIsObjectValid(oItem) ) {
		SendMessageToPC(oPC, "Grrrroaaaar! ResRef cp_basic fehlt!");
		return OK;
	}

	SetName(oItem, "Rezeptplan: " + r.name);
	SetStolenFlag(oItem, 1);

	SetLocalInt(oItem, "craft", r.cskill);
	SetLocalInt(oItem, "craft_recipe", r.id);

	SendMessageToPC(oPC, "Okay, recipe created.");

	return OK;

}

int CommandColour(object oPC, int iMode) {
	struct Colour c;

	string sSet = arg(0);
	if ( sSet == "orange" )
		c = cOrange;
	else if ( sSet == "weiss" )
		c = cWhite;
	else if ( sSet == "blau" )
		c = cLightBlue;
	else if ( sSet == "gruen" )
		c = cGreen;
	else if ( sSet == "cyan" )
		c = cTeal;
	else if ( sSet == "gelb" )
		c = cYellow;
	else {
		ToPC("Diese Farbe gibt es nicht.");
		return SYNTAX;
	}

	SetLocalColour(oPC, "emote_colour", c);
	ToPC("Gesetzt.");

	return OK;
}

int CommandCharges(object oPC, int iMode) {

	object oT = GetTarget();
	if ( !GetIsItem(oT) )
		return NotifyBadTarget("Not some item");

	if ( argc() == 0 ) {
		SendMessageToPC(oPC, "Charges: " + IntToString(GetItemCharges(oT)));
	} else if ( argc() == 1 ) {
		SetItemCharges(oT, StringToInt(arg(0)));
		SendMessageToPC(oPC, "Charges: " + IntToString(GetItemCharges(oT)));
	}

	return OK;
}


int CommandLimbo(object oPC, int iMode) {
	object oTarget = GetTarget();

	if ( CREATURE_SIZE_INVALID == GetCreatureSize(oTarget)/* || GetIsPC( oTarget ) */ ) {
		return NotifyBadTarget();
	}

	if ( IsLimbo(oTarget) )
		Unlimbo(oTarget);
	else
		Limbo(oTarget);

	return OK;
}


int CommandOOC(object oPC, int iMode) {
	string sText = getoptargs();
	SpeakString(ColourTag(cOOC) + sText + ColourTagClose());
	return OK;
}


int CommandXP(object oPC, int iMode) {
	object oT = GetTarget();

	if ( !GetIsCreature(oT) )
		return NotifyBadTarget("Has to be a creature.");

	if ( ( argc() == 0 || arg(0) == "" ) ) {
		SendMessageToPC(oPC, "XP: " + IntToString(GetXP(oT)));
		return OK;

	} else if ( argc() == 1 ) {
		int nXP = StringToInt(arg(0));
		if ( nXP == 0 ) {
			ToPC("Cannot set XP to 0.");
			return FAIL;
		}

		int bIsCAPXP = opt("cap");

		if ( bIsCAPXP ) {
			AddCombatEP(oPC, nXP);


			SendMessageToPC(oPC, "XP is: " + IntToString(GetXP(oT)));

		} else {

			SendMessageToPC(oPC, "XP was: " + IntToString(GetXP(oT)));

			SetXP(oT, nXP);

			SendMessageToPC(oPC, "XP is: " + IntToString(GetXP(oT)));
		}

		return OK;

	} else if ( opt("levelup") ) {
		int nClassType = CLASS_TYPE_INVALID;
		if ( opt("class") )
			nClassType = StringToInt(optv("class"));

		LevelUpHenchman(oT, nClassType, TRUE);
		return OK;
	}

	return SYNTAX;
}


int CommandEffect(object oPC, int iMode) {
	object
	oT = GetTarget();
	location
	lT = GetTargetLocation();

	string
	sE = arg(0),
	s1 = arg(1),
	s2 = arg(2),
	s3 = arg(3),
	s4 = arg(4),
	s5 = arg(5),
	s6 = arg(6);

	effect e;

	int
	nDurT = DURATION_TYPE_PERMANENT;
	float
	fDur = 0.0;

	if ( opt("durtype") )
		nDurT = StringToInt(optv("durtype"));
	if ( opt("duration") )
		fDur = StringToFloat(optv("duration"));

	if ( fDur > 0.0 )
		nDurT = DURATION_TYPE_TEMPORARY;

	if ( opt("r") ) {
		int i = 0;
		e = GetFirstEffect(oT);
		while ( GetIsEffectValid(e) ) {
			RemoveEffect(oT, e);
			i++;
			e = GetNextEffect(oT);
		}
		SendMessageToPC(oPC, IntToString(i) + " effects removed.");
		return OK;
	}

	if ( "vfx" == sE && argc() == 2 )
		e = EffectVisualEffect(StringToInt(s1));

	else if ( "blind" == sE )
		e = EffectBlindness();
	else if ( "damage" == sE && argc() == 3 )
		e = EffectDamage(StringToInt(s1), StringToInt(s2));
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
	else if ( "frightened" == sE ) {
		effect eFear = EffectFrightened();
		effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

		e = EffectLinkEffects(eFear, eMind);
		e = EffectLinkEffects(e, eDur);
	} else if ( "haste" == sE )
		e = EffectHaste();
	else if ( "curse" == sE && argc() == 7 )
		e = EffectCurse(StringToInt(s1), StringToInt(s2), StringToInt(s3), StringToInt(s4), StringToInt(s5),
				StringToInt(s6));
	else if ( "polymorph" == sE && argc() == 3 )
		e = EffectPolymorph(StringToInt(s1), StringToBool(s2));
	else if ( "acincrease" == sE && argc() == 2 )
		e = EffectACIncrease(StringToInt(s1));
	else if ( "acdecrease" == sE && argc() == 2 )
		e = EffectACDecrease(StringToInt(s1));
	else if ( "disease" == sE && argc() == 2 )
		e = EffectDisease(StringToInt(s1));
	else if ( "silence" == sE )
		e = EffectSilence();
	else if ( "entangle" == sE )
		e = EffectEntangle();
	else if ( "abilityincrease" == sE && argc() == 3 )
		e = EffectAbilityIncrease(StringToInt(s1), StringToInt(s2));
	else if ( "abilitydecrease" == sE && argc() == 3 )
		e = EffectAbilityDecrease(StringToInt(s1), StringToInt(s2));
	else if ( "seeinvis" == sE )
		e = EffectSeeInvisible();
	else if ( "trueseeing" == sE )
		e = EffectTrueSeeing();
	else if ( "ultravision" == sE ) {
		effect eVis = EffectVisualEffect(VFX_DUR_ULTRAVISION);
		effect eUltra = EffectUltravision();
		e = EffectLinkEffects(eVis, eUltra);
	} else if ( "speedincrease" == sE && argc() == 2 )
		e = EffectMovementSpeedIncrease(StringToInt(s1));
	else if ( "speeddecrease" == sE && argc() == 2 )
		e = EffectMovementSpeedDecrease(StringToInt(s1));
	else if ( "skillincrease" == sE && argc() == 3 )
		e = EffectSkillIncrease(StringToInt(s1), StringToInt(s2));
	else if ( "skilldecrease" == sE && argc() == 3 )
		e = EffectSkillDecrease(StringToInt(s1), StringToInt(s2));
	else if ( "cutsceneghost" == sE )
		e = EffectCutsceneGhost();

	else {
		SendMessageToPC(oPC, "Unknown effect or wrong parameter count.");
		return FAIL;
	}

	if ( opt("s") )
		e = SupernaturalEffect(e);
	else if ( opt("e") )
		e = ExtraordinaryEffect(e);

	if ( opt("loc") )
		DelayCommand(getsleep(), ApplyEffectAtLocation(nDurT, e, lT, fDur));
	else
		DelayCommand(getsleep(), ApplyEffectToObject(nDurT, e, oT, fDur));

	return OK;
}


int CommandSubRace(object oPC, int iMode) {
	object oT = GetTarget();

	if ( !GetIsCreature(oT) )
		return NotifyBadTarget("Not a creature.");

	string sR = arg(0);

	if ( opt("d") ) {
		SetSubRace(oT, "");
		SendMessageToPC(oPC, "Subrace cleared.");
		return OK;
	}

	if ( argc() == 0 ) {
		SendMessageToPC(oPC, "Subrace: " + GetSubRace(oT));
	} else {
		SendMessageToPC(oPC, "Subrace was: " + GetSubRace(oT));
		SetSubRace(oT, sR);
		SendMessageToPC(oPC, "Subrace now: " + sR);
	}

	return OK;
}


// area -rsl
int CommandArea(object oPC, int iMode) {
	object
	oT = GetTarget();
	string
	s0 = arg(0),
	s1 = arg(1);
	location
	lPC = GetLocation(oPC);

	if ( opt("rsl") ) {
		SendMessageToPC(oPC, "RSL(): ");
		RecomputeStaticLighting(GetArea(oPC));
		SendMessageToPC(oPC, "done.");
		return OK;

	} else if ( opt("tli") ) {
		int c0 = GetTileMainLight1Color(lPC);
		int c1 = GetTileMainLight2Color(lPC);

		if ( argc() == 0 ) {
			SendMessageToPC(oPC, "L1: " + IntToString(c0));
			SendMessageToPC(oPC, "L2: " + IntToString(c1));
			return OK;

		} else if ( argc() == 2 ) {
			SendMessageToPC(oPC, "L1 was: " + IntToString(c0));
			SendMessageToPC(oPC, "L2 was: " + IntToString(c1));
			c0 = StringToInt(s0);
			c1 = StringToInt(s1);
			SetTileMainLightColor(lPC, c0, c1);
			c0 = GetTileMainLight1Color(lPC);
			c1 = GetTileMainLight2Color(lPC);
			SendMessageToPC(oPC, "L1 is: " + IntToString(c0));
			SendMessageToPC(oPC, "L2 is: " + IntToString(c1));
			return OK;
		}
	} else if ( opt("tsi") ) {
		int c0 = GetTileSourceLight1Color(lPC);
		int c1 = GetTileSourceLight2Color(lPC);

		if ( argc() == 0 ) {
			SendMessageToPC(oPC, "S1: " + IntToString(c0));
			SendMessageToPC(oPC, "S2: " + IntToString(c1));
			return OK;

		} else if ( argc() == 2 ) {
			SendMessageToPC(oPC, "S1 was: " + IntToString(c0));
			SendMessageToPC(oPC, "S2 was: " + IntToString(c1));
			c0 = StringToInt(s0);
			c1 = StringToInt(s1);
			SetTileSourceLightColor(lPC, c0, c1);
			c0 = GetTileSourceLight1Color(lPC);
			c1 = GetTileSourceLight2Color(lPC);
			SendMessageToPC(oPC, "S1 is: " + IntToString(c0));
			SendMessageToPC(oPC, "S2 is: " + IntToString(c1));
			return OK;
		}
	} else if ( opt("explore") ) {
		ExploreAreaForPlayer(GetArea(oT), oT, TRUE);
		return OK;
	}

	return OK;
}



int CommandPassword(object oPC, int iMode) {
	string sPass = getoptargs();

	int iAID = GetAccountID(oPC);

	if ( !iAID ) {
		SendMessageToPC(oPC,
			"Dein Account wurde nicht gefunden.  Dies ist ein Bug.  Bitte teile uns dies mit.");
		return FAIL;
	}

	if ( GetStringLowerCase(sPass) == "penis" ) {
		SendMessageToPC(oPC, "Ehm.   Ja.   Aww.   Nein?");
		return FAIL;
	}

	if ( !GetIsGoodPassword(sPass) ) {
		SendMessageToPC(oPC, "Dieses Passwort ist zu kurz. (mindestens 6 Zeichen).");
		return FAIL;
	}

	pQ("update accounts set password = sha1(" +
		pE(sPass) + ") where id = '" + IntToString(iAID) + "' limit 1;");
	pQ("updateaccounts set register_on = now() where id='" +
		IntToString(iAID) + "' and register_on = NULL limit 1;");

	SendMessageToPC(oPC,
		"Dein Passwort wurde gesetzt; du kannst dich damit nun in der Charakterverwaltung einloggen.");

	ChatHookAudit(oPC, FALSE, "***");
	return OK;
}



int CommandBodyPart(object oPC, int iMode) {
	object oTarget = GetTarget();

	if ( !GetIsCreature(oTarget) )
		return NotifyBadTarget("Must be a creature.");

	if ( argc() == 1 ) {
		int nPart = StringToInt(arg(0));
		int nVal = GetCreatureBodyPart(nPart, oTarget);
		SendMessageToPC(oPC, "Part for " + IntToString(nPart) + " is: " + IntToString(nVal));

	} else if ( argc() == 2 ) {
		int nPart = StringToInt(arg(0));
		int nVal = StringToInt(arg(1));

		SetCreatureBodyPart(nPart, nVal, oTarget);
		SendMessageToPC(oPC, "Okay, done.");
	}


	return OK;
}



int CommandWing(object oPC, int iMode) {
	object oTarget = GetTarget();

	if ( !GetIsCreature(oTarget) )
		return NotifyBadTarget("Must be a creature.");

	if ( argc() == 0 ) {
		int nWing = GetCreatureWingType(oTarget);
		SendMessageToPC(oPC, "Wings are: " + IntToString(nWing));
	} else {
		int nWing = GetCreatureWingType(oTarget);
		SendMessageToPC(oPC, "Wings were: " + IntToString(nWing));
		nWing = StringToInt(arg(0));
		SetCreatureWingType(nWing, oTarget);
		nWing = GetCreatureWingType(oTarget);
		SendMessageToPC(oPC, "Wings are: " + IntToString(nWing));
	}


	return OK;
}

int CommandTail(object oPC, int iMode) {
	object oTarget = GetTarget();

	if ( !GetIsCreature(oTarget) )
		return NotifyBadTarget("Must be a creature.");

	if ( argc() == 0 ) {
		int nWing = GetCreatureTailType(oTarget);
		SendMessageToPC(oPC, "Tail is: " + IntToString(nWing));
	} else {
		int nWing = GetCreatureTailType(oTarget);
		SendMessageToPC(oPC, "Tail was: " + IntToString(nWing));
		nWing = StringToInt(arg(0));
		SetCreatureTailType(nWing, oTarget);
		nWing = GetCreatureTailType(oTarget);
		SendMessageToPC(oPC, "Tail is: " + IntToString(nWing));
	}


	return OK;
}



int CommandPortrait(object oPC, int iMode) {
	object oTarget = GetTarget();

	if ( !GetIsObjectValid(oTarget) )
		return NotifyBadTarget("Has to be a valid object.");

	string sNewPortrait = arg(0);


	if ( argc() == 0 ) {
		string sResRef = GetPortraitResRef(oTarget);
		SendMessageToPC(oPC, "Aktuelles Portrait: " + sResRef);
		return OK;
	} else if ( argc() == 1 ) {
		string sResRef = GetPortraitResRef(oTarget);
		SendMessageToPC(oPC, "Altes Portrait: " + sResRef);
		SetPortraitResRef(oTarget, sNewPortrait);
		sResRef = GetPortraitResRef(oTarget);
		SendMessageToPC(oPC, "Neues Portrait: " + sResRef);
		return OK;
	}
	return OK;
}


int CommandRandomWalk(object oPC, int iMode) {
	object oT = GetTarget();

	if ( !GetIsCreature(oT) )
		return NotifyBadTarget("Not a creature.");

//    AssignCommand(oT, ClearAllActions());

	AssignCommand(oT, ActionRandomWalk());

	return OK;
}


int CommandWWP(object oPC, int iMode) {
	object o = GetTarget();

	if ( !GetIsCreature(o) )
		return NotifyBadTarget("Not a creature.");

	AssignCommand(o, WalkWayPoints());

	return OK;
}



int CommandCAQ(object oPC, int iMode) {
	object o = GetTarget();

	if ( !GetIsCreature(o) )
		return NotifyBadTarget("Not a creature.");

	AssignCommand(o, ClearAllActions(1));

	return OK;
}


int CommandStatus(object oPC, int iMode) {
	if ( amask(oPC, AMASK_GM) ) {
		SendMessageToPC(oPC, "Players logged in:");
		object o = GetFirstPC();
		while ( GetIsObjectValid(o) ) {
			SendMessageToPC(oPC, PCToString(o));
			o = GetNextPC();
		}
		SendMessageToPC(oPC, "End of status.");
	} else {
		int nDM = 0;
		string sDM = "";
		int nPlayer = 0;
		object o = GetFirstPC();
		while ( GetIsObjectValid(o) ) {
			if ( GetIsDM(o) ) {
				sDM += GetName(o) + ", ";
				nDM++;
			} else
				nPlayer++;

			o = GetNextPC();
		}
		sDM = GetStringLeft(sDM, GetStringLength(sDM) - 2);
		ToPC("Spieler online: " + IntToString(nPlayer));
		ToPC("Spielleiter online (" + IntToString(nDM) + "): " + sDM);

	}
	return OK;
}


int CommandFollow(object oPC, int iMode) {
	if ( !amask(oPC, AMASK_GM) ) {
		object oNear = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
		if ( !GetIsPC(oNear) )
			return FAIL;

		Floaty("Folge: "  + GetName(oNear), oPC, 0);
//        ClearAllActions();
		ActionForceFollowObject(oNear, 1.5);
		return OK;
	}


	// follow - make self follow current target
	// follow me - make current target follow self
	
	// follow target - make target follow self!
	// follow target target - make target follow target

	string
	p0 = arg(0),
	p1 = arg(1);

	object o0 = GetTarget(StringToInt(p0));
	object o1 = GetTarget(StringToInt(p1));

	object oT = GetTarget();

	if (argc() == 1 && p0 == "me") {
		AssignCommand(GetTarget(), ActionForceFollowObject(oPC, 1.5));
		return OK;
	}
	
	// make self follow current target
	if ( argc() == 0 ) {
//        ClearAllActions(1);
		ActionForceFollowObject(oT);
		return OK;
	
	// make target follow self
	} else if ( argc() == 1 ) {
//        AssignCommand(o0, ClearAllActions(1));
		AssignCommand(o0, ActionForceFollowObject(oPC, 1.5));
		return OK;
	} else if ( argc() == 2 ) {
//        AssignCommand(o0, ClearAllActions(1));
		AssignCommand(o0, ActionForceFollowObject(o1, 1.5));
		return OK;
	}

	return OK;
}

int CommandCopyObject(object oPC, int iMode) {
	object oT = GetTarget();

	if ( !GetIsObjectValid(oT) )
		return NotifyBadTarget();

	object new = CopyObject(oT, GetLocation(oPC), oPC);

	if ( GetIsPC(oT) )
		ChangeToStandardFaction(new, STANDARD_FACTION_COMMONER);

	if ( opt("limbo") )
		Limbo(new);

	if ( opt("newslot") ) {
		int n = StringToInt(optv("newslot"));
		SetTarget(new, n);
	}

	return OK;
}

int CommandCopyMod(object oPC, int iMode) {
	object oT = GetTarget();
	if ( !GetIsItem(oT) )
		return NotifyBadTarget();

	int nType = StringToInt(arg(0));
	int nIndex = StringToInt(arg(1));
	int nNew = StringToInt(arg(2));

	object oNew = CopyItemAndModify(oT, nType, nIndex, nNew, TRUE);

	return OK;
}


int CommandJump(object oPC, int iMode) {
	location lT = GetTargetLocation();
	object oT = GetTarget();

	if ( !opt("loc") ) {
		if ( !GetIsObjectValid(oT) )
			return NotifyBadTarget();

//        ClearAllActions();
		ActionJumpToObject(oT);

	} else {
//        ClearAllActions();
		ActionJumpToLocation(lT);
	}

	return OK;
}


int CommandFetch(object oPC, int iMode) {
	int i = 0;
	int count = argc();

	object oTarget;

	if ( 0 < count ) {
		for ( i = 0; i < count; i++ ) {
			oTarget = GetTarget(StringToInt(arg(i)));
//            DelayCommand(getsleep(), AssignCommand(oTarget, ClearAllActions()));
			DelayCommand(getsleep(), AssignCommand(oTarget, JumpToObject(oPC)));
		}
	} else {
		oTarget = GetTarget();

		if ( GetIsItem(oTarget) ) {
			CopyItem(oTarget, oPC, TRUE);
			DestroyObject(oTarget);
		} else if ( GetIsCreature(oTarget) ) {
//            DelayCommand(getsleep(), AssignCommand(oTarget, ClearAllActions()));
			DelayCommand(getsleep(), AssignCommand(oTarget, JumpToObject(oPC)));

		} else {
			return NotifyBadTarget();
		}
	}

	return OK;
}


int CommandKick(object oPC, int iMode) {
	object oPC =  FindPCByAccount(arg(0));

	if ( !GetIsPC(oPC) ) {
		SendMessageToPC(oPC, "Spieler '" + arg(0) + "' nicht gefunden.");
		return FAIL;
	}

	SendMessageToPC(oPC, "Okay, " + PCToString(oPC) + " fliegt nun.");
	BootPC(oPC);

	return OK;
}


int CommandCreate(object oPC, int iMode) {
	//p0 = objtype
	//p1 = resref
	//p2 = location(obj, loc)
	//p3 = newtag
	int nObjType = StringToInt(arg(0));
	string sRes = arg(1);
	int nLoc = arg(2) == "loc" ? 2 : ( arg(2) == "obj" ? 1 : -1 );
	string sTag = arg(3);
	int iStackSize = StringToInt(arg(4));
	if ( iStackSize < 1 || iStackSize > 500 )
		iStackSize = 1;

	if ( arg(2) == ""
		|| nLoc == -1
		|| ( nObjType != OBJECT_TYPE_ITEM
			&& nObjType != OBJECT_TYPE_CREATURE
			&& nObjType != OBJECT_TYPE_PLACEABLE
			&& nObjType != OBJECT_TYPE_STORE && nObjType != OBJECT_TYPE_WAYPOINT )
		|| ( nLoc == 1 && nObjType != OBJECT_TYPE_ITEM ) ) {
		SendMessageToPC(oPC, "Syntax: objtype(int), resref, location(obj, loc), [tag(str)] [stacksize(int)]");
		return SYNTAX;
	}




	SendMessageToPC(oPC, "Attempting to create '" + sRes + "' ..");

	if ( nLoc == 2 ) {
		object o = CreateObject(nObjType, sRes, GetTargetLocation(), FALSE, sTag);
		if ( GetIsObjectValid(o) )
			SendMessageToPC(oPC, "Okay, created on location.");
		else {
			SendMessageToPC(oPC, "Failed creating at location!");
			return FAIL;
		}
	} else {
		object o = CreateItemOnObject(sRes, GetTarget(), iStackSize, sTag);
		if ( GetIsObjectValid(o) )
			SendMessageToPC(oPC, "Okay, created on " + GetName(GetTarget()));
		else {
			SendMessageToPC(oPC, "Failed creating on creature '" + GetName(GetTarget()) + "'.");
			return FAIL;
		}
	}
	return OK;

}


int CommandShunUnshun(object oPC, int iMode, int iState) {
	iState = iState != 0;
	if ( "" == getoptargs() ) {
		SendMessageToPC(oPC, "Required argument: Acccountname to un/shun.");
		return FAIL;
	} else {
		object found = FindPCByAccount(getoptargs());

		if ( GetIsObjectValid(found) ) {

			if ( GetIsDM(found) ) {
				SendMessageToPC(oPC, "DMs cannot be shunned.");
				return FAIL;
			}

			SetLocalInt(found, "shunned", iState);

			if ( iState )
				SendMessageToPC(oPC, "Player shunned.");
			else
				SendMessageToPC(oPC, "Player not shunned anymore.");
		} else {
			SendMessageToPC(oPC, "Player '" + getoptargs() + "' not found.");
			return FAIL;
		}
	}
	return OK;
}


int CommandInfo(object oPC, int iMode) {
	string sArg = getoptargs();

	if ( "" == sArg ) {
		object oTarget = GetTarget();

		if ( !GetIsObjectValid(oTarget) ) {
			return NotifyBadTarget();
		}

		SendMessageToPC(oPC, "Name: " + GetName(oTarget));
		SendMessageToPC(oPC, "ObjectType: " +
			IntToString(GetObjectType(oTarget)) + ", OID: " + ObjectToString(oTarget));
		SendMessageToPC(oPC, "Area: " + AreaToString(GetArea(oTarget)));
		SendMessageToPC(oPC, "Tag: " + GetTag(oTarget));
		SendMessageToPC(oPC, "ResRef: " + GetResRef(oTarget));

	} else {
		object o = FindPCByAccount(sArg);
		if ( GetIsObjectValid(o) ) {
			SendMessageToPC(oPC, "Info for '" + sArg + "'");
			SendMessageToPC(oPC, " Charname: " + GetName(o));
			SendMessageToPC(oPC, " XP: " + IntToString(GetXP(o)));
			SendMessageToPC(oPC, " Account: "  + GetPCPlayerName(o));
			SendMessageToPC(oPC, " IP: " + GetPCIPAddress(o));
			SendMessageToPC(oPC, " Key: " + GetPCPublicCDKey(o));
			SendMessageToPC(oPC, " Area: " + AreaToString(GetArea(o)));
			SendMessageToPC(oPC, "End of info.");
		} else {
			SendMessageToPC(oPC, "Player '" + sArg + "' not found.");
			return FAIL;
		}
	}
	SendMessageToPC(oPC, "End of info.");
	return OK;
}


int CommandIgnoreList(object oPC, int iMode, int iState) {
	iState = iState != 0;
	if ( "" == getoptargs() )
		SendMessageToPC(oPC, "Benoetigtes Argument: Acccountname");
	else {
		object found = FindPCByAccount(getoptargs());

		if ( GetIsObjectValid(found) ) {
			if ( GetLocalInt(oPC, "ignore_" + GetPCPlayerName(found)) && iState )
				SendMessageToPC(oPC, "Spieler '" +
					GetPCPlayerName(found) + "' ist bereits auf deiner Ignorelist.");
			else if ( !GetLocalInt(oPC, "ignore_" + GetPCPlayerName(found)) && !iState )
				SendMessageToPC(oPC, "Spieler '" +
					GetPCPlayerName(found) + "' ist nicht auf deiner Ignorelist.");

			SetLocalInt(oPC, "ignore_" + GetPCPlayerName(found), iState);

			if ( iState )
				SendMessageToPC(oPC, "Spieler '" +
					GetPCPlayerName(found) + "' kann dir keine Nachrichten mehr senden.");
			else
				SendMessageToPC(oPC, "Spieler '" +
					GetPCPlayerName(found) + "' ist nicht mehr auf deiner Ignorelist.");

		} else {
			SendMessageToPC(oPC, "Spieler '" + getoptargs() + "' nicht gefunden.");
			return FAIL;
		}
	}
	return OK;
}


int CommandShowObj(object oPC, int iMode) {
	float fRange = StringToFloat(arg(0));
	if ( fRange <= 0.0 || fRange >= 30.0 ) {
		SendMessageToPC(oPC, "Bad Idea( tm ).");
		return FAIL;
	}

	string sTagMask = "**";
	if ( opt("m") )
		sTagMask = optv("m");

	int nType = OBJECT_TYPE_PLACEABLE;
	if ( opt("type") )
		nType = StringToInt(optv("type"));

	int c = 0;
	string sTag;
	object o = GetFirstObjectInShape(SHAPE_SPHERE, fRange, GetLocation(oPC), FALSE, nType);
	while ( GetIsObjectValid(o) ) {
		sTag = GetTag(o);
		if ( TestStringAgainstPattern(sTagMask, sTag) ) {
			SendMessageToPC(oPC, GetName(o) + ", Tag: " + GetTag(o) + ", ResRef: " + GetResRef(o));
			c += 1;
		}
		o = GetNextObjectInShape(SHAPE_SPHERE, fRange, GetLocation(oPC), FALSE, nType);
	}
	SendMessageToPC(oPC, "Found " + IntToString(c) + " placeables.");
	return OK;
}


int CommandKillObj(object oPC, int iMode) {
	float fRange = StringToFloat(arg(0));
	if ( fRange <= 0.0 || fRange >= 30.0 ) {
		SendMessageToPC(oPC, "Bad Idea( tm ).");
		return FAIL;
	}

	float delay = 0.2;

	string sTagMask = "**";
	if ( opt("m") )
		sTagMask = optv("m");

	int nType = OBJECT_TYPE_PLACEABLE;
	if ( opt("type") )
		nType = StringToInt(optv("type"));

	int c = 0;
	string sTag;
	object o = GetFirstObjectInShape(SHAPE_SPHERE, fRange, GetLocation(oPC), FALSE, nType);
	while ( GetIsObjectValid(o) ) {
		sTag = GetTag(o);
		if ( TestStringAgainstPattern(sTagMask, sTag) ) {
			KillInventory(o);
			KillPlacie(o, delay);
			delay += 0.1;
			c += 1;
		}
		o = GetNextObjectInShape(SHAPE_SPHERE, fRange, GetLocation(oPC), FALSE, nType);
	}
	if ( c > 0 )
		RecomputeStaticLighting(GetArea(oPC));
	SendMessageToPC(oPC, "Annihilated " + IntToString(c) + " placeables!");
	return OK;
}

int CommandVoiceChat(object oPC, string sArg, int iMode) {

	int id = -1;
	string sOpt = "";
	int iWhite = FindSubString(sArg, " ");
	sArg = GetStringLowerCase(sArg);
	if ( iWhite != -1 ) {
		sOpt = GetSubString(sArg, iWhite + 1, 1024);
		sArg = GetSubString(sArg, 0, iWhite);
	}

	// List cleverly autogenerated
	if ( "attack" == sArg ) id = VOICE_CHAT_ATTACK;
	else if ( "badidea" == sArg ) id = VOICE_CHAT_BADIDEA;
	else if ( "battlecry1" == sArg ) id = VOICE_CHAT_BATTLECRY1;
	else if ( "battlecry2" == sArg ) id = VOICE_CHAT_BATTLECRY2;
	else if ( "battlecry3" == sArg ) id = VOICE_CHAT_BATTLECRY3;
	else if ( "bored" == sArg ) id = VOICE_CHAT_BORED;
	else if ( "cando" == sArg ) id = VOICE_CHAT_CANDO;
	else if ( "cantdo" == sArg ) id = VOICE_CHAT_CANTDO;
	else if ( "cheer" == sArg ) id = VOICE_CHAT_CHEER;
	else if ( "cuss" == sArg ) id = VOICE_CHAT_CUSS;
	else if ( "death" == sArg ) id = VOICE_CHAT_DEATH;
	else if ( "encumbered" == sArg ) id = VOICE_CHAT_ENCUMBERED;
	else if ( "enemies" == sArg ) id = VOICE_CHAT_ENEMIES;
	else if ( "flee" == sArg ) id = VOICE_CHAT_FLEE;
	else if ( "followme" == sArg ) id = VOICE_CHAT_FOLLOWME;
	else if ( "gattack1" == sArg ) id = VOICE_CHAT_GATTACK1;
	else if ( "gattack2" == sArg ) id = VOICE_CHAT_GATTACK2;
	else if ( "gattack3" == sArg ) id = VOICE_CHAT_GATTACK3;
	else if ( "goodbye" == sArg ) id = VOICE_CHAT_GOODBYE;
	else if ( "goodidea" == sArg ) id = VOICE_CHAT_GOODIDEA;
	else if ( "group" == sArg ) id = VOICE_CHAT_GROUP;
	else if ( "guardme" == sArg ) id = VOICE_CHAT_GUARDME;
	else if ( "healme" == sArg ) id = VOICE_CHAT_HEALME;
	else if ( "hello" == sArg ) id = VOICE_CHAT_HELLO;
	else if ( "help" == sArg ) id = VOICE_CHAT_HELP;
	else if ( "hide" == sArg ) id = VOICE_CHAT_HIDE;
	else if ( "hold" == sArg ) id = VOICE_CHAT_HOLD;
	else if ( "laugh" == sArg ) id = VOICE_CHAT_LAUGH;
	else if ( "lookhere" == sArg ) id = VOICE_CHAT_LOOKHERE;
	else if ( "moveover" == sArg ) id = VOICE_CHAT_MOVEOVER;
	else if ( "neardeath" == sArg ) id = VOICE_CHAT_NEARDEATH;
	else if ( "no" == sArg ) id = VOICE_CHAT_NO;
	else if ( "pain1" == sArg ) id = VOICE_CHAT_PAIN1;
	else if ( "pain2" == sArg ) id = VOICE_CHAT_PAIN2;
	else if ( "pain3" == sArg ) id = VOICE_CHAT_PAIN3;
	else if ( "picklock" == sArg ) id = VOICE_CHAT_PICKLOCK;
	else if ( "poisoned" == sArg ) id = VOICE_CHAT_POISONED;
	else if ( "rest" == sArg ) id = VOICE_CHAT_REST;
	else if ( "search" == sArg ) id = VOICE_CHAT_SEARCH;
	else if ( "selected" == sArg ) id = VOICE_CHAT_SELECTED;
	else if ( "spellfailed" == sArg ) id = VOICE_CHAT_SPELLFAILED;
	else if ( "stop" == sArg ) id = VOICE_CHAT_STOP;
	else if ( "talktome" == sArg ) id = VOICE_CHAT_TALKTOME;
	else if ( "taskcomplete" == sArg ) id = VOICE_CHAT_TASKCOMPLETE;
	else if ( "taunt" == sArg ) id = VOICE_CHAT_TAUNT;
	else if ( "thanks" == sArg ) id = VOICE_CHAT_THANKS;
	else if ( "threaten" == sArg ) id = VOICE_CHAT_THREATEN;
	else if ( "weaponsucks" == sArg ) id = VOICE_CHAT_WEAPONSUCKS;
	else if ( "yes" == sArg ) id = VOICE_CHAT_YES;
	else {
		SendMessageToPC(oPC, "Unbekannter VoiceChat '" + sArg + "'; benutze: ");
		SendMessageToPC(oPC, " attack, badidea, battlecry1, battlecry2, battlecry3, bored, cando, cantdo");
		SendMessageToPC(oPC, " cheer, cuss, death, encumbered, enemies, flee, followme, gattack1");
		SendMessageToPC(oPC, " gattack2, gattack3, goodbye, goodidea, group, guardme, healme, hello");
		SendMessageToPC(oPC, " help, hide, hold, laugh, lookhere, moveover, neardeath, no, yes");
		SendMessageToPC(oPC, " pain1, pain2, pain3, picklock, poisoned, rest, search, selected");
		SendMessageToPC(oPC,
			" spellfailed, stop, talktome, taskcomplete, taunt, thanks, threaten, weaponsucks");
		return SYNTAX;
	}

	if ( ( sOpt == "target" || sOpt == "t" ) && amask(oPC, AMASK_GLOBAL_GM) ) {
		object oTarget = GetTarget();
		if ( !GetIsCreature(oTarget) )
			return NotifyBadTarget();

		DelayCommand(0.0, PlayVoiceChat(id, oTarget));
	} else {
		DelayCommand(0.0, PlayVoiceChat(id, oPC));
	}
	return OK;
}

int CommandDice(object oPC, int iMode) {
	int
	iNum = StringToInt(arg(0)),
	iDie = StringToInt(arg(1));

	if ( iDie < 2 )
		iDie = 2;
	if ( iDie > 2000 )
		iDie = 2000;
	if ( iNum < 1 )
		iNum = 1;
	if ( iNum > 20 )
		iNum = 20;

	string r = IntToString(iNum) + "d" + IntToString(iDie) + ": ";
	int c, i, total = 0;
	for ( i = 0; i < iNum; i++ ) {
		total += ( c = Random(iDie) + 1 );
		r += IntToString(c) + " ";
	}
	r += " = " + IntToString(total);

	SpeakToMode(oPC, r, iMode);
	return OK;
}


int CommandAnimation(object oPC, string sArg, int iMode) {
	string sOpt = "";

	int iWhite = FindSubString(sArg, " ");
	sArg = GetStringLowerCase(sArg);
	if ( iWhite != -1 ) {
		sOpt = GetSubString(sArg, iWhite + 1, 1024);
		sArg = GetSubString(sArg, 0, iWhite);
	}

	float fDuration = 10000000.0;
	int iAni = -1;

	// autogenerated, xxx cut stuff we dont want
	if ( "bow" == sArg )
		iAni = ANIMATION_FIREFORGET_BOW;
	if ( "dodge_duck" == sArg )
		iAni = ANIMATION_FIREFORGET_DODGE_DUCK;
	if ( "dodge_side" == sArg )
		iAni = ANIMATION_FIREFORGET_DODGE_SIDE;
	if ( "drink" == sArg )
		iAni = ANIMATION_FIREFORGET_DRINK;
	if ( "greeting" == sArg )
		iAni = ANIMATION_FIREFORGET_GREETING;
	if ( "head_turn_left" == sArg )
		iAni = ANIMATION_FIREFORGET_HEAD_TURN_LEFT;
	if ( "head_turn_right" == sArg )
		iAni = ANIMATION_FIREFORGET_HEAD_TURN_RIGHT;
	if ( "pause_bored" == sArg )
		iAni = ANIMATION_FIREFORGET_PAUSE_BORED;
	if ( "pause_scratch_head" == sArg )
		iAni = ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD;
	if ( "read" == sArg )
		iAni = ANIMATION_FIREFORGET_READ;
	if ( "salute" == sArg )
		iAni = ANIMATION_FIREFORGET_SALUTE;
	if ( "steal" == sArg )
		iAni = ANIMATION_FIREFORGET_STEAL;
	if ( "taunt" == sArg )
		iAni = ANIMATION_FIREFORGET_TAUNT;
	if ( "victory1" == sArg )
		iAni = ANIMATION_FIREFORGET_VICTORY1;
	if ( "victory2" == sArg )
		iAni = ANIMATION_FIREFORGET_VICTORY2;
	if ( "victory3" == sArg )
		iAni = ANIMATION_FIREFORGET_VICTORY3;

	if ( "sitcross" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM1;
	if ( "dance" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM2;
	if ( "kneel" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM3;
	if ( "crazy" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM5;
	if ( "freeze" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM6;
	if ( "lieleft" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM7;
	if ( "lieright" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM8;

	if ( "conjure1" == sArg )
		iAni = ANIMATION_LOOPING_CONJURE1;
	if ( "conjure2" == sArg )
		iAni = ANIMATION_LOOPING_CONJURE2;
	if ( "dead_back" == sArg )
		iAni = ANIMATION_LOOPING_DEAD_BACK;
	if ( "dead_front" == sArg )
		iAni = ANIMATION_LOOPING_DEAD_FRONT;
	if ( "get_low" == sArg )
		iAni = ANIMATION_LOOPING_GET_LOW;
	if ( "get_mid" == sArg )
		iAni = ANIMATION_LOOPING_GET_MID;
	if ( "listen" == sArg )
		iAni = ANIMATION_LOOPING_LISTEN;
	if ( "look_far" == sArg )
		iAni = ANIMATION_LOOPING_LOOK_FAR;
	if ( "meditate" == sArg )
		iAni = ANIMATION_LOOPING_MEDITATE;
	if ( "pause" == sArg )
		iAni = ANIMATION_LOOPING_PAUSE;
	if ( "pause_drunk" == sArg )
		iAni = ANIMATION_LOOPING_PAUSE_DRUNK;
	if ( "pause_tired" == sArg )
		iAni = ANIMATION_LOOPING_PAUSE_TIRED;
	if ( "pause2" == sArg )
		iAni = ANIMATION_LOOPING_PAUSE2;
	if ( "sit" == sArg )
		iAni = ANIMATION_LOOPING_SIT_CROSS;
	if ( "spasm" == sArg )
		iAni = ANIMATION_LOOPING_SPASM;
	if ( "talk_forceful" == sArg )
		iAni = ANIMATION_LOOPING_TALK_FORCEFUL;
	if ( "talk_laughing" == sArg )
		iAni = ANIMATION_LOOPING_TALK_LAUGHING;
	if ( "talk_normal" == sArg )
		iAni = ANIMATION_LOOPING_TALK_NORMAL;
	if ( "talk_pleading" == sArg )
		iAni = ANIMATION_LOOPING_TALK_PLEADING;
	if ( "worship" == sArg )
		iAni = ANIMATION_LOOPING_WORSHIP;

	if ( "c1" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM1;
	if ( "c2" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM2;
	if ( "c3" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM3;
	if ( "c4" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM4;
	if ( "c5" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM5;
	if ( "c6" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM6;
	if ( "c7" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM7;
	if ( "c8" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM8;
	if ( "c9" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM9;
	if ( "c10" == sArg )
		iAni = ANIMATION_LOOPING_CUSTOM10;

	if ( iAni == -1 ) {
		SendMessageToPC(oPC, "Unbekannte Animation '" + sArg + "', benutze: ");
		SendMessageToPC(oPC, " dead_back, dead_front, get_low, get_mid, listen, look_far, meditate, pause");
		SendMessageToPC(oPC,
			" pause_drunk, pause_tired, pause2, sit, talk_forceful, talk_laughing, talk_normal, talk_pleading, worship");
		SendMessageToPC(oPC,
			" bow, dodge_duck, dodge_side, drink, greeting, head_turn_left, head_turn_right, pause_bored, pause_scratch_head, read");
		SendMessageToPC(oPC, " salute, spasm, steal, taunt, victory1, victory2, victory3");
		SendMessageToPC(oPC, " conjure1, conjure2");
		return SYNTAX;
	}


	if ( sOpt == "target" && amask(oPC, AMASK_GLOBAL_GM) ) {
		object oTarget = GetTarget();
		if ( CREATURE_SIZE_INVALID == GetCreatureSize(oTarget) ) {
			return NotifyBadTarget();
		}
//        DelayCommand(getsleep(), AssignCommand(oTarget, ClearAllActions()));
		DelayCommand(getsleep(), AssignCommand(oTarget, ActionPlayAnimation(iAni, 1.0, fDuration)));
	} else {

//        DelayCommand(getsleep(), AssignCommand(oPC, ClearAllActions()));
		DelayCommand(getsleep(), AssignCommand(oPC, ActionPlayAnimation(iAni, 1.0, fDuration)));
	}
	return OK;
}


int CommandSetName(object oPC, int iMode) {
	object oTarget = GetTarget();

	if ( !GetIsObjectValid(oTarget) || GetIsPC(oTarget) ) {
		return NotifyBadTarget();
	}

	location lO = GetLocation(oTarget);

	if ( arg(0) != "" ) {
		SetName(oTarget, arg(0));
		SendMessageToPC(oPC, "Okay, luv, Name ist nun '" + GetName(oTarget) + "'.");
	} else {
		SetName(oTarget);
		SendMessageToPC(oPC, "Okay, luv, Name ist zurueck beim Anfang ..");
	}

	if ( Limbo(oTarget) )
		Unlimbo(oTarget);

	return OK;
}


int CommandFleshToStone(object oPC, int iMode) {
	object oTarget = GetTarget();

	/* can only petrify creatures */
	if ( CREATURE_SIZE_INVALID == GetCreatureSize(oTarget) ) {
		return NotifyBadTarget();
	}

	effect ePetrify = EffectPetrify();

	ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePetrify, oTarget);
	AssignCommand(oTarget, ClearAllActions(TRUE));

	return OK;
}



int CommandStoneToFlesh(object oPC, int iMode) {
	object oTarget = GetTarget();

	/* can only de-petrify creatures */
	if ( CREATURE_SIZE_INVALID == GetCreatureSize(oTarget) ) {
		return NotifyBadTarget();
	}

	effect ePetrify = EffectPetrify();

	effect e = GetFirstEffect(oTarget);
	while ( GetIsEffectValid(e) ) {

		if ( GetEffectType(e) == EFFECT_TYPE_PETRIFY && GetEffectDurationType(e) == DURATION_TYPE_PERMANENT )
			RemoveEffect(oTarget, e);

		e = GetNextEffect(oTarget);
	}

	return OK;
}


int CommandFixFactions(object oPC, int iMode) {
	if ( arg(0) == "all" ) {
		object oO = GetFirstPC();

		while ( GetIsObjectValid(oO) ) {
			FixFactionsForObject(oO, oPC);
			SendMessageToPC(oPC, "Factions fuer " + GetName(oO) + " repariert.");
			oO = GetNextPC();
		}

	} else if ( arg(0) == "target" ) {
		/* target mode */
		object oTarget = GetTarget();
		if ( !GetIsPC(oPC) ) {
			return NotifyBadTarget();
		}

		FixFactionsForObject(oTarget, oPC);
		SendMessageToPC(oPC, "Factions fuer " + GetName(oTarget) + " repariert.");

	} else if ( arg(0) == "personal" ) {
		int t1 = StringToInt(arg(1)),
			t2 = StringToInt(arg(2));
		object o1 = GetTarget(1),
			   o2 = GetTarget(2);

		if ( t1 < 1 || t1 > TARGET_MAX || t2 < 1 || t2 > TARGET_MAX )
			return NotifyBadTarget(); // Syntax("personal target_1 target_2");

		if ( !GetIsCreature(o1) || !GetIsCreature(o2) )
			return NotifyBadTarget();

		ClearPersonalReputation(o1, o2);

	} else {
		SendMessageToPC(oPC, "Ungueltiges Argument, einer von 'all', 'target', 'personal'");
		return SYNTAX;
	}

	return OK;
}



int CommandGetTargetChooser(object oPC, int iMode) {
	object oCh = GetItemPossessedBy(oPC, "choose_target");
	if ( GetIsObjectValid(oCh) )
		DestroyObject(oCh);
	else
		CreateItemOnObject("choose_target", oPC, 1);

	return OK;
}

int CommandRestore(object oPC, int iMode) {
	object oTarget = GetTarget();
	if ( !GetIsCreature(oTarget)  ) {
		return NotifyBadTarget();
	}

	if ( opt("s") ) {
		effect e = GetFirstEffect(oTarget);
		while ( GetIsEffectValid(e) ) {
			DelayCommand(getsleep(), RemoveEffect(oTarget, e));
			e = GetNextEffect(oTarget);
		}
	}

	if ( opt("e") ) {
		int nEffectID = StringToInt(optv("e"));
		effect e = GetFirstEffect(oTarget);
		while ( GetIsEffectValid(e) ) {
			if ( nEffectID == 0
				|| ( nEffectID > 0 && GetEffectType(e) == nEffectID )
				&& GetEffectSubType(e) != SUBTYPE_SUPERNATURAL )
				DelayCommand(getsleep(), RemoveEffect(oTarget, e));
			e = GetNextEffect(oTarget);
		}
	}

	if ( opt("l") ) {
		DelayCommand(getsleep(), ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(2000), oTarget));
	}

	if ( opt("r") ) {
		SetLocalInt(oTarget, "Resting_Counter_val", 0);
		SetLocalDecay(oTarget, "Resting_Food", 241, 60);
	}

	ToPC("Done.");
	return OK;
}


int CommandVFX(object oPC, int iMode) {
	string p0 = GetStringLowerCase(arg(0));
	string p1 = GetStringLowerCase(arg(1));
	string p2 = GetStringLowerCase(arg(2));
	string p3 = GetStringLowerCase(arg(3));

	int iTar = ( p0 == "o" || p0 == "obj" ) ? 0 : ( ( p0 == "loc" || p0 == "l" ) ? 1 : -1 );
	int iDur = ( p1 == "t"
				|| p1 ==
				"temp" ) ? DURATION_TYPE_TEMPORARY : ( ( p1 == "i"
														|| p1 ==
														"inst" ) ? DURATION_TYPE_INSTANT : ( ( p1 == "p"
																							  || p1 ==
																							  "perm" ) ?
																							DURATION_TYPE_PERMANENT
																							: -1 ) );
	int iVFX = StringToInt(p2);
	float fDur = StringToFloat(p3);

	if ( p2 == "" || iTar < 0 || iTar > 1
		|| ( iDur != DURATION_TYPE_INSTANT
			&& iDur != DURATION_TYPE_PERMANENT && iDur != DURATION_TYPE_TEMPORARY )
		|| iVFX < 0 || iVFX > MAX_VFX_EFFECT_ID
		|| ( iDur == DURATION_TYPE_TEMPORARY && ( fDur < 0.0 || fDur > 1000000.0 ) ) ) {
		return SYNTAX; // Syntax("target_type(obj, loc), duration(temp, inst, perm), vfx_id(int) [duration]", 1);
	}

	float x, y, z;

	if ( opt("x") )
		x = StringToFloat(optv("x"));
	if ( opt("y") )
		y = StringToFloat(optv("y"));
	if ( opt("z") )
		z = StringToFloat(optv("z"));

	object oTarget = GetTarget();
	location lTarget = GetTargetLocation();
	vector oP = GetPositionFromLocation(lTarget);
	object oA = GetAreaFromLocation(lTarget);
	float fD = GetFacingFromLocation(lTarget);
	oP.x += x;
	oP.y += y;
	oP.z += z;
	lTarget = Location(oA, oP, fD);

	effect e = EffectVisualEffect(iVFX);

	if ( 1 == iTar )
		DelayCommand(getsleep(), ApplyEffectAtLocation(iDur, e, lTarget, fDur));
	else
		DelayCommand(getsleep(), ApplyEffectToObject(iDur, e, oTarget, fDur));

	return OK;
}

int CommandFX(object oPC, int iMode) {
	// void ApplyEffectToObject(int nDurationType, effect eEffect, object oTarget, float fDuration=0.0f)
	// void ApplyEffectAtLocation(int nDurationType, effect eEffect, location lLocation, float fDuration=0.0f)


	return NOTFOUND;

}




int CommandTarget(object oPC, int iMode) {
	int nSlot, nNth, nSlotFrom;
	string sTag, sAreaTag, sMask, sWhat;



	if ( GetLocalInt(oPC, "target_use_cache") ) {
		nNth = GetLocalInt(OBJECT_SELF, "target_n");
		nSlot = GetLocalInt(OBJECT_SELF, "target_t");
		nSlotFrom = GetLocalInt(OBJECT_SELF, "target_f");
		sWhat = GetLocalString(OBJECT_SELF, "target_what");
		sAreaTag = GetLocalString(OBJECT_SELF, "target_area");
		sTag = GetLocalString(OBJECT_SELF, "target_tag");
		sMask = GetLocalString(OBJECT_SELF, "target_mask");

		// invalidate cache
		SetLocalInt(OBJECT_SELF, "target_use_cache", 0);

	} else {

		nSlot = GetTargetSlot();

		nNth = 1;
		if ( opt("n") )
			nNth = StringToInt(optv("n"));

		sTag = "";
		if ( opt("tag") )
			sTag = optv("tag");

		sAreaTag = "";
		if ( opt("area") )
			sAreaTag = optv("area");


		nSlotFrom = 0;
		if ( opt("f") )
			nSlotFrom = StringToInt(optv("f"));

		sMask = "";
		if ( opt("m") )
			sMask = optv("m");

		sWhat = arg(0);

	}


	if ( opt("l") ) {
		// show all targets!
		int i = 1;
		object ot;
		location lt;
		for ( i = 1; i <= TARGET_MAX; i++ ) {
			ot = GetTarget(i);
			lt = GetTargetLocation(i);
			if ( GetIsObjectValid(ot) ) {
				SendMessageToPC(oPC, "O[" +
					IntToString(i) +
					"] '" +
					GetName(ot) +
					"' (OID: " + ObjectToString(ot) + "), ObjectType: " + IntToString(GetObjectType(ot)));
				SendMessageToPC(oPC, " @ " + LocationToStringPrintable(GetLocation(ot)));
			}

			string sl = LocationToStringPrintable(lt);
			if ( sl != "" )
				SendMessageToPC(oPC, "L[" + IntToString(i) + "] " + sl);

		}
		return OK;
	}

	if ( sWhat == "x" ) {
		ToPC("Targeting next.");

		// increment nth, set sWhat to
		int nNth = GetLocalInt(OBJECT_SELF, "target_n");
		nNth += 1;
		SetLocalInt(OBJECT_SELF, "target_n", nNth);

		SetLocalInt(OBJECT_SELF, "target_use_cache", 1);
		// re-run the command with the new values.
		return CommandTarget(oPC, iMode);
	}

	if ( sWhat == "v" ) {
		ToPC("Targeting previous.");

		// increment nth, set sWhat to
		int nNth = GetLocalInt(OBJECT_SELF, "target_n");
		nNth -= 1;
		if ( nNth < 1 )
			nNth = 1;
		SetLocalInt(OBJECT_SELF, "target_n", nNth);

		SetLocalInt(OBJECT_SELF, "target_use_cache", 1);
		// re-run the command with the new values.
		return CommandTarget(oPC, iMode);
	} else {
		// save the current options if we are not running next-style
		SetLocalInt(OBJECT_SELF, "target_n", nNth);
		SetLocalInt(OBJECT_SELF, "target_t", nSlot);
		SetLocalInt(OBJECT_SELF, "target_f", nSlotFrom);
		SetLocalString(OBJECT_SELF, "target_what", sWhat);
		SetLocalString(OBJECT_SELF, "target_area", sAreaTag);
		SetLocalString(OBJECT_SELF, "target_tag", sTag);
		SetLocalString(OBJECT_SELF, "target_mask", sMask);
	}

	if ( opt("d") ) {
		SetDefaultSlot(StringToInt(sWhat));
		return OK;
	}

	object oArea = OBJECT_SELF;
	if ( opt("area") ) {
		oArea = GetObjectByTag(sAreaTag);
		if ( AREA_INVALID == GetIsAreaNatural(oArea) ) {
			ToPC("--area is not a valid area.");
			return OK;
		}
	}


	object oFrom = oPC;

	if ( opt("f") )
		oFrom = GetTarget(nSlotFrom);

	if ( !GetIsObjectValid(oFrom) ) {
		ToPC("-f is not a valid object.");
		return OK;
	}


	object o;


	// Get Object by tag.  Assumes "all" for object type.
	if ( opt("tag") ) {
		o = GetObjectByTag(sTag, nNth - 1);
		sWhat = "skip";
	}

	if ( sWhat == "a" ) {
		// get nearest everything
		o = GetNearestObject(OBJECT_TYPE_ALL, oFrom, nNth);

	} else if ( sWhat == "pc" ) {
		// get nearest player
		o = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oFrom, nNth);

	} else if ( sWhat == "n" ) {
		// get nearest npc
		o = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oFrom, nNth);

	} else if ( sWhat == "h" ) {
		// get nearest HOSTILE character
		o = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oFrom, nNth);


	} else if ( sWhat == "p" ) {
		// get nearest placie
		o = GetNearestObject(OBJECT_TYPE_PLACEABLE, oFrom, nNth);

	} else if ( sWhat == "d" ) {
		// get nearest door
		o = GetNearestObject(OBJECT_TYPE_DOOR, oFrom, nNth);

	} else if ( sWhat == "i" ) {
		// get nearest item
		o = GetNearestObject(OBJECT_TYPE_ITEM, oFrom, nNth);

	} else if ( sWhat == "w" ) {
		// get nearest waypoint
		o = GetNearestObject(OBJECT_TYPE_WAYPOINT, oFrom, nNth);

	} else if ( sWhat == "st" ) {
		o = GetNearestObject(OBJECT_TYPE_STORE, oFrom, nNth);

	} else if ( sWhat == "t" ) {
		o = GetNearestObject(OBJECT_TYPE_TRIGGER, oFrom, nNth);

	} else if ( sWhat == "aoe" ) {
		o = GetNearestObject(OBJECT_TYPE_ALL, oFrom, nNth);

	} else if ( sWhat == "ar" ) {
		o = GetArea(oPC);

	} else if ( sWhat == "mod" ) {
		o = GetModule();

	} else if ( sWhat == "s" ) {
		// our humble self
		o = oPC;

	} else if ( sWhat == "pci" ) {
		// player by index
		int i = 1;
		object op = GetFirstPC();
		while ( GetIsObjectValid(op) ) {
			if ( i > nNth )
				break;
			if ( op == oPC ) {
				op = GetNextPC();
				continue;
			}

			if ( i == nNth ) {
				o = op;
				break;
			}

			op = GetNextPC();
			i++;
		}

	} else if ( sWhat == "oi" ) {
		int i = 1;
		object op = GetFirstObjectInArea(oArea);
		while ( GetIsObjectValid(op) ) {
			if ( sMask != "" && !TestStringAgainstPattern("**" + sMask + "**", GetTag(op)) ) {
				op = GetNextObjectInArea(oArea);
				continue;
			}

			if ( i > nNth )
				break;

			if ( i == nNth ) {
				o = op;
				break;
			}

			op = GetNextObjectInArea(oArea);
			i++;
		}

	} else if ( sWhat == "l" ) {
		// get this location
		SetTargetLocation(GetLocation(oPC), nSlot);
		return OK;

	} else {
		// barf
	}


	if ( GetIsObjectValid(o) ) {
		SetTarget(o, nSlot);
	} else {
		SendMessageToPC(oPC, "No object found that matches your selected criteria.");
		return FAIL;
	}

	return OK;
}



int CommandKill(object oPC, int iMode) {
	object oTarget = GetTarget();
	if ( !GetIsObjectValid(oTarget) ) {
		return NotifyBadTarget();
	}

	int bUseDestroy = opt("d");

	AssignCommand(oTarget, SetIsDestroyable(TRUE, FALSE, FALSE));

	if ( bUseDestroy ) {
		KillInventory(oTarget);
		DestroyObject(oTarget, getsleep());
		return OK;
	}

	switch ( GetObjectType(oTarget) ) {
		case OBJECT_TYPE_CREATURE:
			SetImmortal(oTarget, FALSE);

			// Set Hitpoints to 0. Do NOT kill into death.
			DelayCommand(getsleep(), AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_INSTANT,
						EffectDamage(GetCurrentHitPoints(oTarget)), oTarget)));
			break;

		case OBJECT_TYPE_TRIGGER:
		case OBJECT_TYPE_STORE:
		case OBJECT_TYPE_WAYPOINT:
		case OBJECT_TYPE_DOOR:
		case OBJECT_TYPE_ITEM:
		case OBJECT_TYPE_PLACEABLE:
			KillInventory(oTarget);
			DestroyObject(oTarget, getsleep());
			break;
		default:
			SendMessageToPC(oPC, "Dieses Objekt kann ich nicht, hmm, verarbeiten.");
			return FAIL;
	}

	return OK;
}


int CommandGetVar(object oPC, int iMode) {
	string
	p0 = arg(0),
	p1 = arg(1),
	p2 = arg(2);

	int nType = ( p0 == "int" ? 1 : ( p0 == "str" ? 2 : ( p0 == "float" ? 3 : -1 ) ) );

	if ( p1 == "" || nType == -1 )
		return SYNTAX; // Syntax("type(int, str, float) key");

	object oTarget = GetTarget();
	if ( !GetIsObjectValid(oTarget) )
		return NotifyBadTarget();


	switch ( nType ) {
		case 1:
			SendMessageToPC(oPC, "'" + p1 + "' = '" + IntToString(GetLocalInt(oTarget, p1)) + "'");
			break;
		case 2:
			SendMessageToPC(oPC, "'" + p1 + "' = '" + GetLocalString(oTarget, p1) + "'");
			break;
		case 3:
			SendMessageToPC(oPC, "'" + p1 + "' = '" + FloatToString(GetLocalFloat(oTarget, p1)) + "'");
			break;
	}

	return OK;
}

int CommandSetVar(object oPC, int iMode) {
	string
	p0 = arg(0),
	p1 = arg(1),
	p2 = arg(2);


	int nType = ( p0 == "int" ? 1 : ( p0 == "str" ? 2 : ( p0 == "float" ? 3 : -1 ) ) );

	if ( p2 == "" || nType == -1 )
		return SYNTAX; // Syntax("type(int, str, float) key value");

	object oTarget = GetTarget();
	if ( !GetIsObjectValid(oTarget) )
		return NotifyBadTarget();


	switch ( nType ) {
		case 1:
			SetLocalInt(oTarget, p1, StringToInt(p2));
			break;
		case 2:
			SetLocalString(oTarget, p1, p2);
			break;
		case 3:
			SetLocalFloat(oTarget, p1, StringToFloat(p2));
			break;
	}

	SendMessageToPC(oPC, "Done.");

	return OK;
}




int CommandSetAppearance(object oPC, int iMode) {
	object oTarget = GetTarget();
	if ( !GetIsCreature(oTarget) ) {
		return NotifyBadTarget();
	}

	int iOld = GetAppearanceType(oTarget);

	if ( arg(0) == "" ) {
		SendMessageToPC(oPC, "Aktuelles Erscheinungsbild: " + IntToString(iOld));
		return OK;
	}

	int iApp = StringToInt(arg(0));

	if ( iApp < 0 || iApp > 2048 ) {
		SendMessageToPC(oPC, "Ungueltiger Erscheinungswert.");
		return FAIL;
	}



	SetCreatureAppearanceType(oTarget, iApp);

	SendMessageToPC(oPC, "Altes Erscheinungsbild: " + IntToString(iOld));
	SendMessageToPC(oPC, "Neues Erscheinungsbild: " + IntToString(iApp));
	return OK;
}



int CommandSetPhenotype(object oPC, int iMode) {
	object oTarget = GetTarget();
	if ( !GetIsCreature(oTarget) )
		return NotifyBadTarget();

	int iOld = GetPhenoType(oTarget);

	if ( arg(0) == "" ) {
		SendMessageToPC(oPC, "Current Phenotype: " + IntToString(iOld));
		return OK;
	}

	int iApp = StringToInt(arg(0));

	if ( iApp < 0 || iApp > 2048 ) {
		SendMessageToPC(oPC, "Invalid Phenotype.");
		return FAIL;
	}



	SetPhenoType(iApp, oTarget);

	SendMessageToPC(oPC, "Old Phenotype: " + IntToString(iOld));
	SendMessageToPC(oPC, "New Phenotype: " + IntToString(iApp));
	return OK;
}


int CommandShowConst(object oPC, int iMode) {
	string sArg = arg(0);

	if ( sArg == "mode" ) {
		SendMessageToPC(oPC, " MODE_TALK: " + IntToString(MODE_TALK));
		SendMessageToPC(oPC, " MODE_SHOUT: " + IntToString(MODE_SHOUT));
		SendMessageToPC(oPC, " MODE_WHISPER: " + IntToString(MODE_WHISPER));
		SendMessageToPC(oPC, " MODE_PRIVATE: " + IntToString(MODE_PRIVATE));
		SendMessageToPC(oPC, " MODE_PARTY: " + IntToString(MODE_PARTY));
		SendMessageToPC(oPC, " MODE_DM: " + IntToString(MODE_DM));
		SendMessageToPC(oPC, " MODE_DM_MODE: " + IntToString(MODE_DM_MODE));
		SendMessageToPC(oPC, " MODE_COMMAND: " + IntToString(MODE_COMMAND));
	}

	if ( sArg == "object" ) {
		SendMessageToPC(oPC, " OBJECT_TYPE_ALL: " + IntToString(OBJECT_TYPE_ALL));
		SendMessageToPC(oPC, " OBJECT_TYPE_AREA_OF_EFFECT: " + IntToString(OBJECT_TYPE_AREA_OF_EFFECT));
		SendMessageToPC(oPC, " OBJECT_TYPE_CREATURE: " + IntToString(OBJECT_TYPE_CREATURE));
		SendMessageToPC(oPC, " OBJECT_TYPE_DOOR: " + IntToString(OBJECT_TYPE_DOOR));
		SendMessageToPC(oPC, " OBJECT_TYPE_ENCOUNTER    : " + IntToString(OBJECT_TYPE_ENCOUNTER));
		SendMessageToPC(oPC, " OBJECT_TYPE_INVALID: " + IntToString(OBJECT_TYPE_INVALID));
		SendMessageToPC(oPC, " OBJECT_TYPE_ITEM : " + IntToString(OBJECT_TYPE_ITEM));
		SendMessageToPC(oPC, " OBJECT_TYPE_PLACEABLE: " + IntToString(OBJECT_TYPE_PLACEABLE));
		SendMessageToPC(oPC, " OBJECT_TYPE_STORE: " + IntToString(OBJECT_TYPE_STORE));
		SendMessageToPC(oPC, " OBJECT_TYPE_TRIGGER: " + IntToString(OBJECT_TYPE_TRIGGER));
		SendMessageToPC(oPC, " OBJECT_TYPE_WAYPOINT: " + IntToString(OBJECT_TYPE_WAYPOINT));
	}

	if ( sArg == "phenotype" ) {
		SendMessageToPC(oPC, " PHENOTYPE_NORMAL: " + IntToString(PHENOTYPE_NORMAL));
		SendMessageToPC(oPC, " PHENOTYPE_BIG: " + IntToString(PHENOTYPE_BIG));
		SendMessageToPC(oPC, " PHENOTYPE_CUSTOM1: " + IntToString(PHENOTYPE_CUSTOM1));
		SendMessageToPC(oPC, " PHENOTYPE_CUSTOM2: " + IntToString(PHENOTYPE_CUSTOM2));
		SendMessageToPC(oPC, " PHENOTYPE_CUSTOM3: " + IntToString(PHENOTYPE_CUSTOM3));
		SendMessageToPC(oPC, " PHENOTYPE_CUSTOM4: " + IntToString(PHENOTYPE_CUSTOM4));
		SendMessageToPC(oPC, " PHENOTYPE_CUSTOM5: " + IntToString(PHENOTYPE_CUSTOM5));
	}

	if ( sArg == "creature" ) {
		SendMessageToPC(oPC, " CREATURE_PART_BELT: " + IntToString(CREATURE_PART_BELT));
		SendMessageToPC(oPC, " CREATURE_PART_HEAD: " + IntToString(CREATURE_PART_HEAD));
		SendMessageToPC(oPC, " CREATURE_PART_LEFT_BICEP: " + IntToString(CREATURE_PART_LEFT_BICEP));
		SendMessageToPC(oPC, " CREATURE_PART_LEFT_FOOT: " + IntToString(CREATURE_PART_LEFT_FOOT));
		SendMessageToPC(oPC, " CREATURE_PART_LEFT_FOREARM: " + IntToString(CREATURE_PART_LEFT_FOREARM));
		SendMessageToPC(oPC, " CREATURE_PART_LEFT_HAND: " + IntToString(CREATURE_PART_LEFT_HAND));
		SendMessageToPC(oPC, " CREATURE_PART_LEFT_SHIN: " + IntToString(CREATURE_PART_LEFT_SHIN));
		SendMessageToPC(oPC, " CREATURE_PART_LEFT_SHOULDER: " + IntToString(CREATURE_PART_LEFT_SHOULDER));
		SendMessageToPC(oPC, " CREATURE_PART_LEFT_THIGH: " + IntToString(CREATURE_PART_LEFT_THIGH));
		SendMessageToPC(oPC, " CREATURE_PART_NECK: " + IntToString(CREATURE_PART_NECK));
		SendMessageToPC(oPC, " CREATURE_PART_PELVIS: " + IntToString(CREATURE_PART_PELVIS));
		SendMessageToPC(oPC, " CREATURE_PART_RIGHT_BICEP: " + IntToString(CREATURE_PART_RIGHT_BICEP));
		SendMessageToPC(oPC, " CREATURE_PART_RIGHT_FOOT: " + IntToString(CREATURE_PART_RIGHT_FOOT));
		SendMessageToPC(oPC, " CREATURE_PART_RIGHT_FOREARM: " + IntToString(CREATURE_PART_RIGHT_FOREARM));
		SendMessageToPC(oPC, " CREATURE_PART_RIGHT_HAND: " + IntToString(CREATURE_PART_RIGHT_HAND));
		SendMessageToPC(oPC, " CREATURE_PART_RIGHT_SHIN: " + IntToString(CREATURE_PART_RIGHT_SHIN));
		SendMessageToPC(oPC, " CREATURE_PART_RIGHT_SHOULDER: " + IntToString(CREATURE_PART_RIGHT_SHOULDER));
		SendMessageToPC(oPC, " CREATURE_PART_RIGHT_THIGH: " + IntToString(CREATURE_PART_RIGHT_THIGH));
		SendMessageToPC(oPC, " CREATURE_PART_TORSO: " + IntToString(CREATURE_PART_TORSO));
	}

	if ( sArg == "tail" ) {
		SendMessageToPC(oPC, " CREATURE_TAIL_TYPE_NONE: " + IntToString(CREATURE_TAIL_TYPE_NONE));
		SendMessageToPC(oPC, " CREATURE_TAIL_TYPE_BONE: " + IntToString(CREATURE_TAIL_TYPE_BONE));
		SendMessageToPC(oPC, " CREATURE_TAIL_TYPE_DEVIL: " + IntToString(CREATURE_TAIL_TYPE_DEVIL));
		SendMessageToPC(oPC, " CREATURE_TAIL_TYPE_LIZARD: " + IntToString(CREATURE_TAIL_TYPE_LIZARD));
	}

	if ( sArg == "wing" ) {
		SendMessageToPC(oPC, " CREATURE_WING_TYPE_NONE: " + IntToString(CREATURE_WING_TYPE_NONE));
		SendMessageToPC(oPC, " CREATURE_WING_TYPE_ANGEL: " + IntToString(CREATURE_WING_TYPE_ANGEL));
		SendMessageToPC(oPC, " CREATURE_WING_TYPE_BAT: " + IntToString(CREATURE_WING_TYPE_BAT));
		SendMessageToPC(oPC, " CREATURE_WING_TYPE_BIRD: " + IntToString(CREATURE_WING_TYPE_BIRD));
		SendMessageToPC(oPC, " CREATURE_WING_TYPE_BUTTERFLY: " + IntToString(CREATURE_WING_TYPE_BUTTERFLY));
		SendMessageToPC(oPC, " CREATURE_WING_TYPE_DEMON: " + IntToString(CREATURE_WING_TYPE_DEMON));
		SendMessageToPC(oPC, " CREATURE_WING_TYPE_DRAGON: " + IntToString(CREATURE_WING_TYPE_DRAGON));
	}

	if ( sArg == "weather" ) {
		SendMessageToPC(oPC, " WEATHER_CLEAR: " + IntToString(WEATHER_CLEAR));
		SendMessageToPC(oPC, " WEATHER_RAIN: " + IntToString(WEATHER_RAIN));
		SendMessageToPC(oPC, " WEATHER_SNOW: " + IntToString(WEATHER_SNOW));
		SendMessageToPC(oPC, " WEATHER_USE_AREA_SETTINGS: " + IntToString(WEATHER_USE_AREA_SETTINGS));
	}


	if ( sArg == "polymorph" ) {
		SendMessageToPC(oPC, " POLYMORPH_TYPE_ANCIENT_BLUE_DRAGON: " +
			IntToString(POLYMORPH_TYPE_ANCIENT_BLUE_DRAGON));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_ANCIENT_GREEN_DRAGON: " +
			IntToString(POLYMORPH_TYPE_ANCIENT_GREEN_DRAGON));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_ANCIENT_RED_DRAGON: " +
			IntToString(POLYMORPH_TYPE_ANCIENT_RED_DRAGON));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_BADGER: " + IntToString(POLYMORPH_TYPE_BADGER));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_BALOR: " + IntToString(POLYMORPH_TYPE_BALOR));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_BASILISK: " + IntToString(POLYMORPH_TYPE_BASILISK));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_BEHOLDER: " + IntToString(POLYMORPH_TYPE_BEHOLDER));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_BOAR: " + IntToString(POLYMORPH_TYPE_BOAR));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_BROWN_BEAR: " + IntToString(POLYMORPH_TYPE_BROWN_BEAR));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_CELESTIAL_AVENGER: " +
			IntToString(POLYMORPH_TYPE_CELESTIAL_AVENGER));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_CHICKEN: " + IntToString(POLYMORPH_TYPE_CHICKEN));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_COW: " + IntToString(POLYMORPH_TYPE_COW));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_DEATH_SLAAD: " + IntToString(POLYMORPH_TYPE_DEATH_SLAAD));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_DIRE_BADGER: " + IntToString(POLYMORPH_TYPE_DIRE_BADGER));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_DIRE_BOAR: " + IntToString(POLYMORPH_TYPE_DIRE_BOAR));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_DIRE_BROWN_BEAR: " + IntToString(POLYMORPH_TYPE_DIRE_BROWN_BEAR));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_DIRE_PANTHER: " + IntToString(POLYMORPH_TYPE_DIRE_PANTHER));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_DIRE_WOLF: " + IntToString(POLYMORPH_TYPE_DIRE_WOLF));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_DIRETIGER: " + IntToString(POLYMORPH_TYPE_DIRETIGER));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_DOOM_KNIGHT: " + IntToString(POLYMORPH_TYPE_DOOM_KNIGHT));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_DRIDER: " + IntToString(POLYMORPH_TYPE_DRIDER));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL: " +
			IntToString(POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL: " +
			IntToString(POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL: " +
			IntToString(POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL: " +
			IntToString(POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_FEMALE_DROW: " + IntToString(POLYMORPH_TYPE_FEMALE_DROW));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_FIRE_GIANT: " + IntToString(POLYMORPH_TYPE_FIRE_GIANT));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_FROST_GIANT_FEMALE: " +
			IntToString(POLYMORPH_TYPE_FROST_GIANT_FEMALE));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_FROST_GIANT_MALE: " +
			IntToString(POLYMORPH_TYPE_FROST_GIANT_MALE));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_GARGOYLE: " + IntToString(POLYMORPH_TYPE_GARGOYLE));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_GIANT_SPIDER: " + IntToString(POLYMORPH_TYPE_GIANT_SPIDER));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_GOLEM_AUTOMATON: " + IntToString(POLYMORPH_TYPE_GOLEM_AUTOMATON));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_HARPY: " + IntToString(POLYMORPH_TYPE_HARPY));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_HEURODIS: " + IntToString(POLYMORPH_TYPE_HEURODIS));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_HUGE_AIR_ELEMENTAL: " +
			IntToString(POLYMORPH_TYPE_HUGE_AIR_ELEMENTAL));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_HUGE_EARTH_ELEMENTAL: " +
			IntToString(POLYMORPH_TYPE_HUGE_EARTH_ELEMENTAL));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_HUGE_FIRE_ELEMENTAL: " +
			IntToString(POLYMORPH_TYPE_HUGE_FIRE_ELEMENTAL));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_HUGE_WATER_ELEMENTAL: " +
			IntToString(POLYMORPH_TYPE_HUGE_WATER_ELEMENTAL));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_IMP: " + IntToString(POLYMORPH_TYPE_IMP));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_IRON_GOLEM: " + IntToString(POLYMORPH_TYPE_IRON_GOLEM));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_JNAH_GIANT_FEMAL: " +
			IntToString(POLYMORPH_TYPE_JNAH_GIANT_FEMAL));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_JNAH_GIANT_MALE: " + IntToString(POLYMORPH_TYPE_JNAH_GIANT_MALE));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_MALE_DROW: " + IntToString(POLYMORPH_TYPE_MALE_DROW));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_MANTICORE: " + IntToString(POLYMORPH_TYPE_MANTICORE));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_MEDUSA: " + IntToString(POLYMORPH_TYPE_MEDUSA));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_MINDFLAYER: " + IntToString(POLYMORPH_TYPE_MINDFLAYER));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_MINOTAUR: " + IntToString(POLYMORPH_TYPE_MINOTAUR));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_NULL_HUMAN: " + IntToString(POLYMORPH_TYPE_NULL_HUMAN));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_PANTHER: " + IntToString(POLYMORPH_TYPE_PANTHER));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_PENGUIN: " + IntToString(POLYMORPH_TYPE_PENGUIN));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_PIXIE: " + IntToString(POLYMORPH_TYPE_PIXIE));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_QUASIT: " + IntToString(POLYMORPH_TYPE_QUASIT));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_RED_DRAGON: " + IntToString(POLYMORPH_TYPE_RED_DRAGON));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_RISEN_LORD: " + IntToString(POLYMORPH_TYPE_RISEN_LORD));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_SPECTRE: " + IntToString(POLYMORPH_TYPE_SPECTRE));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_SUCCUBUS: " + IntToString(POLYMORPH_TYPE_SUCCUBUS));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_SUPER_CHICKEN: " + IntToString(POLYMORPH_TYPE_SUPER_CHICKEN));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_TROLL: " + IntToString(POLYMORPH_TYPE_TROLL));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_UMBER_HULK: " + IntToString(POLYMORPH_TYPE_UMBER_HULK));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_VAMPIRE_FEMALE: " + IntToString(POLYMORPH_TYPE_VAMPIRE_FEMALE));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_VAMPIRE_MALE: " + IntToString(POLYMORPH_TYPE_VAMPIRE_MALE));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_VROCK: " + IntToString(POLYMORPH_TYPE_VROCK));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_WERECAT: " + IntToString(POLYMORPH_TYPE_WERECAT));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_WERERAT: " + IntToString(POLYMORPH_TYPE_WERERAT));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_WEREWOLF: " + IntToString(POLYMORPH_TYPE_WEREWOLF));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_WOLF: " + IntToString(POLYMORPH_TYPE_WOLF));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_WYRMLING_BLACK: " + IntToString(POLYMORPH_TYPE_WYRMLING_BLACK));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_WYRMLING_BLUE: " + IntToString(POLYMORPH_TYPE_WYRMLING_BLUE));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_WYRMLING_GREEN: " + IntToString(POLYMORPH_TYPE_WYRMLING_GREEN));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_WYRMLING_RED: " + IntToString(POLYMORPH_TYPE_WYRMLING_RED));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_WYRMLING_WHITE: " + IntToString(POLYMORPH_TYPE_WYRMLING_WHITE));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_YUANTI: " + IntToString(POLYMORPH_TYPE_YUANTI));
		SendMessageToPC(oPC, " POLYMORPH_TYPE_ZOMBIE: " + IntToString(POLYMORPH_TYPE_ZOMBIE));
	}

	if ( sArg == "tile" ) {
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_AQUA: " + IntToString(TILE_MAIN_LIGHT_COLOR_AQUA));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_BLACK: " + IntToString(TILE_MAIN_LIGHT_COLOR_BLACK));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_BLUE: " + IntToString(TILE_MAIN_LIGHT_COLOR_BLUE));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_BRIGHT_WHITE));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_DARK_AQUA: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_DARK_AQUA));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_DARK_BLUE: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_DARK_BLUE));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_DARK_GREEN: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_DARK_GREEN));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_DARK_ORANGE: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_DARK_ORANGE));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_DARK_PURPLE: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_DARK_PURPLE));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_DARK_RED: " + IntToString(TILE_MAIN_LIGHT_COLOR_DARK_RED));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_DARK_YELLOW: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_DARK_YELLOW));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_DIM_WHITE: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_DIM_WHITE));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_GREEN: " + IntToString(TILE_MAIN_LIGHT_COLOR_GREEN));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_ORANGE: " + IntToString(TILE_MAIN_LIGHT_COLOR_ORANGE));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_PALE_AQUA: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_PALE_AQUA));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_PALE_BLUE: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_PALE_BLUE));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_PALE_DARK_AQUA));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_PALE_DARK_BLUE));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_PALE_DARK_GREEN));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_PALE_DARK_PURPLE: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_PALE_DARK_PURPLE));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_PALE_DARK_RED: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_PALE_DARK_RED));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_PALE_GREEN: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_PALE_GREEN));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_PALE_ORANGE: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_PALE_ORANGE));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_PALE_PURPLE: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_PALE_PURPLE));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_PALE_RED: " + IntToString(TILE_MAIN_LIGHT_COLOR_PALE_RED));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_PALE_YELLOW: " +
			IntToString(TILE_MAIN_LIGHT_COLOR_PALE_YELLOW));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_PURPLE: " + IntToString(TILE_MAIN_LIGHT_COLOR_PURPLE));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_RED: " + IntToString(TILE_MAIN_LIGHT_COLOR_RED));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_WHITE: " + IntToString(TILE_MAIN_LIGHT_COLOR_WHITE));
		SendMessageToPC(oPC, " TILE_MAIN_LIGHT_COLOR_YELLOW: " + IntToString(TILE_MAIN_LIGHT_COLOR_YELLOW));
		SendMessageToPC(oPC, "--");
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_BLACK: " + IntToString(TILE_SOURCE_LIGHT_COLOR_BLACK));
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_PALE_AQUA: " +
			IntToString(TILE_SOURCE_LIGHT_COLOR_PALE_AQUA));
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_PALE_BLUE: " +
			IntToString(TILE_SOURCE_LIGHT_COLOR_PALE_BLUE));
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_PALE_DARK_AQUA: " +
			IntToString(TILE_SOURCE_LIGHT_COLOR_PALE_DARK_AQUA));
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_PALE_DARK_BLUE: " +
			IntToString(TILE_SOURCE_LIGHT_COLOR_PALE_DARK_BLUE));
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_PALE_DARK_GREEN: " +
			IntToString(TILE_SOURCE_LIGHT_COLOR_PALE_DARK_GREEN));
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE: " +
			IntToString(TILE_SOURCE_LIGHT_COLOR_PALE_DARK_ORANGE));
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_PALE_DARK_PURPLE: " +
			IntToString(TILE_SOURCE_LIGHT_COLOR_PALE_DARK_PURPLE));
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_PALE_DARK_RED: " +
			IntToString(TILE_SOURCE_LIGHT_COLOR_PALE_DARK_RED));
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_PALE_DARK_YELLOW: " +
			IntToString(TILE_SOURCE_LIGHT_COLOR_PALE_DARK_YELLOW));
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_PALE_GREEN: " +
			IntToString(TILE_SOURCE_LIGHT_COLOR_PALE_GREEN));
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_PALE_ORANGE: " +
			IntToString(TILE_SOURCE_LIGHT_COLOR_PALE_ORANGE));
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_PALE_PURPLE: " +
			IntToString(TILE_SOURCE_LIGHT_COLOR_PALE_PURPLE));
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_PALE_RED: " +
			IntToString(TILE_SOURCE_LIGHT_COLOR_PALE_RED));
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_PALE_YELLOW: " +
			IntToString(TILE_SOURCE_LIGHT_COLOR_PALE_YELLOW));
		SendMessageToPC(oPC, " TILE_SOURCE_LIGHT_COLOR_WHITE: " + IntToString(TILE_SOURCE_LIGHT_COLOR_WHITE));
	}

	if ( sArg == "disease" ) {
		SendMessageToPC(oPC, " DISEASE_BLINDING_SICKNESS: " + IntToString(DISEASE_BLINDING_SICKNESS));
		SendMessageToPC(oPC, " DISEASE_BURROW_MAGGOTS: " + IntToString(DISEASE_BURROW_MAGGOTS));
		SendMessageToPC(oPC, " DISEASE_CACKLE_FEVER: " + IntToString(DISEASE_CACKLE_FEVER));
		SendMessageToPC(oPC, " DISEASE_DEMON_FEVER: " + IntToString(DISEASE_DEMON_FEVER));
		SendMessageToPC(oPC, " DISEASE_DEVIL_CHILLS: " + IntToString(DISEASE_DEVIL_CHILLS));
		SendMessageToPC(oPC, " DISEASE_DREAD_BLISTERS: " + IntToString(DISEASE_DREAD_BLISTERS));
		SendMessageToPC(oPC, " DISEASE_FILTH_FEVER: " + IntToString(DISEASE_FILTH_FEVER));
		SendMessageToPC(oPC, " DISEASE_GHOUL_ROT: " + IntToString(DISEASE_GHOUL_ROT));
		SendMessageToPC(oPC, " DISEASE_MINDFIRE: " + IntToString(DISEASE_MINDFIRE));
		SendMessageToPC(oPC, " DISEASE_MUMMY_ROT: " + IntToString(DISEASE_MUMMY_ROT));
		SendMessageToPC(oPC, " DISEASE_RED_ACHE: " + IntToString(DISEASE_RED_ACHE));
		SendMessageToPC(oPC, " DISEASE_RED_SLAAD_EGGS: " + IntToString(DISEASE_RED_SLAAD_EGGS));
		SendMessageToPC(oPC, " DISEASE_SHAKES: " + IntToString(DISEASE_SHAKES));
		SendMessageToPC(oPC, " DISEASE_SLIMY_DOOM: " + IntToString(DISEASE_SLIMY_DOOM));
		SendMessageToPC(oPC, " DISEASE_SOLDIER_SHAKES: " + IntToString(DISEASE_SOLDIER_SHAKES));
		SendMessageToPC(oPC, " DISEASE_VERMIN_MADNESS: " + IntToString(DISEASE_VERMIN_MADNESS));
		SendMessageToPC(oPC, " DISEASE_ZOMBIE_CREEP: " + IntToString(DISEASE_ZOMBIE_CREEP));
	}

	if ( sArg == "ability" ) {
		SendMessageToPC(oPC, " ABILITY_STRENGTH: " + IntToString(ABILITY_STRENGTH));
		SendMessageToPC(oPC, " ABILITY_DEXTERITY: " + IntToString(ABILITY_DEXTERITY));
		SendMessageToPC(oPC, " ABILITY_CONSTITUTION: " + IntToString(ABILITY_CONSTITUTION));
		SendMessageToPC(oPC, " ABILITY_INTELLIGENCE: " + IntToString(ABILITY_INTELLIGENCE));
		SendMessageToPC(oPC, " ABILITY_WISDOM: " + IntToString(ABILITY_WISDOM));
		SendMessageToPC(oPC, " ABILITY_CHARISMA: " + IntToString(ABILITY_CHARISMA));
	}

	if ( sArg == "class" ) {
		SendMessageToPC(oPC, " CLASS_TYPE_ABERRATION: " + IntToString(CLASS_TYPE_ABERRATION));
		SendMessageToPC(oPC, " CLASS_TYPE_ANIMAL: " + IntToString(CLASS_TYPE_ANIMAL));
		SendMessageToPC(oPC, " CLASS_TYPE_ARCANE_ARCHER: " + IntToString(CLASS_TYPE_ARCANE_ARCHER));
		SendMessageToPC(oPC, " CLASS_TYPE_ASSASSIN: " + IntToString(CLASS_TYPE_ASSASSIN));
		SendMessageToPC(oPC, " CLASS_TYPE_BARBARIAN: " + IntToString(CLASS_TYPE_BARBARIAN));
		SendMessageToPC(oPC, " CLASS_TYPE_BARD: " + IntToString(CLASS_TYPE_BARD));
		SendMessageToPC(oPC, " CLASS_TYPE_BEAST: " + IntToString(CLASS_TYPE_BEAST));
		SendMessageToPC(oPC, " CLASS_TYPE_BLACKGUARD: " + IntToString(CLASS_TYPE_BLACKGUARD));
		SendMessageToPC(oPC, " CLASS_TYPE_CLERIC: " + IntToString(CLASS_TYPE_CLERIC));
		SendMessageToPC(oPC, " CLASS_TYPE_COMMONER: " + IntToString(CLASS_TYPE_COMMONER));
		SendMessageToPC(oPC, " CLASS_TYPE_CONSTRUCT: " + IntToString(CLASS_TYPE_CONSTRUCT));
		SendMessageToPC(oPC, " CLASS_TYPE_DIVINECHAMPION: " + IntToString(CLASS_TYPE_DIVINECHAMPION));
		SendMessageToPC(oPC, " CLASS_TYPE_DRAGON: " + IntToString(CLASS_TYPE_DRAGON));
		SendMessageToPC(oPC, " CLASS_TYPE_DRAGONDISCIPLE: " + IntToString(CLASS_TYPE_DRAGONDISCIPLE));
		SendMessageToPC(oPC, " CLASS_TYPE_DRUID: " + IntToString(CLASS_TYPE_DRUID));
		SendMessageToPC(oPC, " CLASS_TYPE_DWARVENDEFENDER: " + IntToString(CLASS_TYPE_DWARVENDEFENDER));
		SendMessageToPC(oPC, " CLASS_TYPE_ELEMENTAL: " + IntToString(CLASS_TYPE_ELEMENTAL));
		SendMessageToPC(oPC, " CLASS_TYPE_FEY: " + IntToString(CLASS_TYPE_FEY));
		SendMessageToPC(oPC, " CLASS_TYPE_FIGHTER: " + IntToString(CLASS_TYPE_FIGHTER));
		SendMessageToPC(oPC, " CLASS_TYPE_GIANT: " + IntToString(CLASS_TYPE_GIANT));
		SendMessageToPC(oPC, " CLASS_TYPE_HARPER: " + IntToString(CLASS_TYPE_HARPER));
		SendMessageToPC(oPC, " CLASS_TYPE_HUMANOID: " + IntToString(CLASS_TYPE_HUMANOID));
		SendMessageToPC(oPC, " CLASS_TYPE_INVALID: " + IntToString(CLASS_TYPE_INVALID));
		SendMessageToPC(oPC, " CLASS_TYPE_MAGICAL_BEAST: " + IntToString(CLASS_TYPE_MAGICAL_BEAST));
		SendMessageToPC(oPC, " CLASS_TYPE_MONK: " + IntToString(CLASS_TYPE_MONK));
		SendMessageToPC(oPC, " CLASS_TYPE_MONSTROUS: " + IntToString(CLASS_TYPE_MONSTROUS));
		SendMessageToPC(oPC, " CLASS_TYPE_OUTSIDER: " + IntToString(CLASS_TYPE_OUTSIDER));
		SendMessageToPC(oPC, " CLASS_TYPE_PALADIN: " + IntToString(CLASS_TYPE_PALADIN));
		SendMessageToPC(oPC, " CLASS_TYPE_PALEMASTER: " + IntToString(CLASS_TYPE_PALEMASTER));
		SendMessageToPC(oPC, " CLASS_TYPE_RANGER: " + IntToString(CLASS_TYPE_RANGER));
		SendMessageToPC(oPC, " CLASS_TYPE_ROGUE: " + IntToString(CLASS_TYPE_ROGUE));
		SendMessageToPC(oPC, " CLASS_TYPE_SHADOWDANCER: " + IntToString(CLASS_TYPE_SHADOWDANCER));
		SendMessageToPC(oPC, " CLASS_TYPE_SHAPECHANGER: " + IntToString(CLASS_TYPE_SHAPECHANGER));
		SendMessageToPC(oPC, " CLASS_TYPE_SHIFTER: " + IntToString(CLASS_TYPE_SHIFTER));
		SendMessageToPC(oPC, " CLASS_TYPE_SORCERER: " + IntToString(CLASS_TYPE_SORCERER));
		SendMessageToPC(oPC, " CLASS_TYPE_UNDEAD: " + IntToString(CLASS_TYPE_UNDEAD));
		SendMessageToPC(oPC, " CLASS_TYPE_VERMIN: " + IntToString(CLASS_TYPE_VERMIN));
		SendMessageToPC(oPC, " CLASS_TYPE_WEAPON_MASTER: " + IntToString(CLASS_TYPE_WEAPON_MASTER));
		SendMessageToPC(oPC, " CLASS_TYPE_WIZARD: " + IntToString(CLASS_TYPE_WIZARD));
	}

	if ( sArg == "duration" ) {
		SendMessageToPC(oPC, " DURATION_TYPE_INSTANT: " + IntToString(DURATION_TYPE_INSTANT));
		SendMessageToPC(oPC, " DURATION_TYPE_PERMANENT: " + IntToString(DURATION_TYPE_PERMANENT));
		SendMessageToPC(oPC, " DURATION_TYPE_TEMPORARY: " + IntToString(DURATION_TYPE_TEMPORARY));
	}

	if ( sArg == "damage" ) {
		SendMessageToPC(oPC, " DAMAGE_TYPE_ACID: " + IntToString(DAMAGE_TYPE_ACID));
		SendMessageToPC(oPC, " DAMAGE_TYPE_BLUDGEONING: " + IntToString(DAMAGE_TYPE_BLUDGEONING));
		SendMessageToPC(oPC, " DAMAGE_TYPE_COLD: " + IntToString(DAMAGE_TYPE_DIVINE));
		SendMessageToPC(oPC, " DAMAGE_TYPE_DIVINE: " + IntToString(DAMAGE_TYPE_DIVINE));
		SendMessageToPC(oPC, " DAMAGE_TYPE_ELECTRICAL: " + IntToString(DAMAGE_TYPE_ELECTRICAL));
		SendMessageToPC(oPC, " DAMAGE_TYPE_FIRE: " + IntToString(DAMAGE_TYPE_FIRE));
		SendMessageToPC(oPC, " DAMAGE_TYPE_MAGICAL: " + IntToString(DAMAGE_TYPE_MAGICAL));
		SendMessageToPC(oPC, " DAMAGE_TYPE_NEGATIVE: " + IntToString(DAMAGE_TYPE_NEGATIVE));
		SendMessageToPC(oPC, " DAMAGE_TYPE_PIERCING: " + IntToString(DAMAGE_TYPE_PIERCING));
		SendMessageToPC(oPC, " DAMAGE_TYPE_POSITIVE: " + IntToString(DAMAGE_TYPE_POSITIVE));
		SendMessageToPC(oPC, " DAMAGE_TYPE_SLASHING: " + IntToString(DAMAGE_TYPE_SLASHING));
		SendMessageToPC(oPC, " DAMAGE_TYPE_SONIC: " + IntToString(DAMAGE_TYPE_SONIC));
	}

	return OK;
}
