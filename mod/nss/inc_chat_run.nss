#include "inc_chat"
#include "_gen"
#include "inc_target"
#include "inc_chatcommand"
#include "inc_getopt"
#include "inc_chat_lib"
#include "inc_mnx_lib"
#include "inc_pgsql"

const string
COMMAND_SPLIT = "&&",
COMMAND_SPLIT_RX = "\s*&&\s*";



string
LastCommand;



int CommandModSet(object oPC, int iMode, int nRunLevel);
int CommandModSelf(object oPC, int iMode, int nRunLevel);
int CommandModRadius(object oPC, int iMode, int nRunLevel);
int CommandModRectangle(object oPC, int iMode, int nRunLevel);
int CommandModLine(object oPC, int iMode, int nRunLevel);
int CommandModArea(object oPC, int iMode, int nRunLevel);
int CommandModServer(object oPC, int iMode, int nRunLevel);
int CommandModOnline(object oPC, int iMode, int nRunLevel);


int CommandSQL(object oPC, int iMode);


// This evaluates a string of commands, not prefixed with the
// command character.
// Example:  "ta self && app 298 && restore"
int CommandEval(object oPC, int iMode, string sText, int bRunMacro, int bRunAlias, int nRunModLevel);

// Runs a single command.  Usually called by CommandEval.
int RunCommand(object oPC, int iMode, string sText, int bRunMacro, int bRunAlias, int nRunModLevel);



int OnCommand(object oPC, string sCommand, string sArg, int iMode, int bRunMacro , int bRunAlias, int nRunModLevel);

void RunMacro(object oPC, int iMode, string sMacro);
int CommandMacro(object oPC, int iMode);


int GetIsMacro(object oPC, string sMacroName);

// Run this on module startup
void RegisterAllCommands();

void RegisterCommand(string sCommandName, string sOptions, int nMinArg = -1, int nMaxArg = -1);
void RegisterAlias(string sAlias, string sAliasValue);

void RegisterHelp(string sText, int nAMask = AMASK_ANY);

void RegisterAccessFlags(int nFlags);



int RunCommand(object oPC, int iMode, string sText, int bRunMacro, int bRunAlias, int nRunModLevel) {
	nRunModLevel = u(nRunModLevel);
	string sCommand, sRest;

	sText = GetStringTrim(sText);

	// Now split up between command and the rest of arguments
	int iWhite = FindSubString(sText, " ");

	if ( iWhite > -1 ) {

		sCommand = GetStringLowerCase(GetSubString(sText, 0, iWhite));

		int i = 1;
		while ( GetSubString(sText, iWhite + i, 1) == " " )
			i++;

		sRest = GetSubString(sText, iWhite + i, GetStringLength(sText));

	} else {

		sCommand = GetStringLowerCase(GetSubString(sText, 0, 1024));
		sRest = "";

	}

	SetLocalString(oPC, "last_chat_command", sCommand);

	sCommand = GetStringTrim(sCommand);
	sRest = GetStringTrim(sRest);

	if (gvGetInt("chat_debug")) {
		SendMessageToAllDMs("chat> run(RunCommand): '" + sCommand + "':'" + sRest + "'::" + IntToString(iMode) + "::" + 
			IntToString(bRunMacro) + ":" + IntToString(bRunAlias) + ":" + IntToString(nRunModLevel));
	}

	switch ( OnCommand(oPC, sCommand, sRest, iMode, bRunMacro, bRunAlias, nRunModLevel) ) {
		case ACCESS:
			ToPC("Ihr habt nicht die noetigen Rechte, um diesen Befehl auszufuehren.", oPC);
			return FALSE;

		case SYNTAX:
			// ToPC(sCommand + ": Syntaxfehler, bitte ueberpruefen.", oPC);
			return FALSE;

		case NOTFOUND:
			if (gvGetInt("chat_debug")) {
				SendMessageToAllDMs("chat> NOTFOUND(RunCommand): '" + sCommand + "':'" + sRest + "'::" + IntToString(iMode) + "::" + 
					IntToString(bRunMacro) + ":" + IntToString(bRunAlias) + ":" + IntToString(nRunModLevel));
			}
			ToPC("Befehl nicht gefunden.", oPC);
			break;

		case FAIL:
			return FALSE;

		case OK:
			// Continue
			// break;
	}

	if ( GetLocalInt(oPC, "chat_suppress_audit") == 0 ) {
		string sData = GetLocalString(oPC, "chat_data_audit");
		audit(sCommand, oPC, audit_fields("args", ( sData ==
												   "" ? sRest : sData ), "mode", IntToString(iMode)),
			"command", GetTarget());
	}
	return 1;
}


int CommandEval(object oPC, int iMode, string sText, int bRunMacro, int bRunAlias, int nRunModLevel) {
	nRunModLevel = u(nRunModLevel);
	int i = 0;
	string sCmd = "";

	int nCommandCount = mCommandSplit(sText, COMMAND_SPLIT);

	if (gvGetInt("chat_debug")) {
		SendMessageToAllDMs("chat> CommandEval(): '" + sText + "'::" + IntToString(iMode) + "::" + 
			IntToString(nCommandCount) + "::" +
			IntToString(bRunMacro) + ":" + IntToString(bRunAlias) + ":" + IntToString(nRunModLevel));
	}

	for ( i = 0; i < nCommandCount; i++ ) {
		sCmd = mCommandSplitGet(i);
		if ( !RunCommand(oPC, iMode, sCmd, bRunMacro, bRunAlias, nRunModLevel) )
			return FALSE;
	}
	return TRUE;
}




void RegisterAlias(string sAlias, string sAliasValue) {
	SetLocalString(GetModule(), "alias_" + sAlias, sAliasValue);
}

void RA(string sAlias, string sAliasValue) {
	RegisterAlias(sAlias, sAliasValue);
}

void RegisterCommand(string sCommandName, string sOptions, int nMinArg = -1, int nMaxArg = -1) {
	object oM = GetModule();
	LastCommand = GetStringLowerCase(sCommandName);

	string sAllCommands = GetLocalString(oM, "cmds_all");
	if ( sAllCommands != "" )
		sAllCommands += ", ";
	sAllCommands += LastCommand;
	SetLocalString(oM, "cmds_all", sAllCommands);

	SetLocalInt(oM, "cmd_" + LastCommand, 1);
	SetLocalString(oM, "cmd_" + LastCommand + "_opt", sOptions);
	SetLocalInt(oM, "cmd_" + LastCommand + "_argc_min", nMinArg);
	SetLocalInt(oM, "cmd_" + LastCommand + "_argc_max", nMaxArg);

	SetLocalInt(oM, "cmd_" + LastCommand + "_amask", AMASK_GLOBAL_GM);
}

void RH(string sText, int nAMask = AMASK_ANY) {
	RegisterHelp(sText);
}

// Cough up a syntax helper
void RHs(string s = "", int bAddTarget = FALSE, int nAMask = AMASK_ANY) {
	RH("Syntax: " +
		LastCommand + " " + ( bAddTarget == TRUE ? "[-t=1.." + IntToString(TARGET_MAX) + "] " : "" ) + s);
}

// Display an example
void RHe(string s = "", int nAMask = AMASK_ANY) {
	RH("Example: " + LastCommand + " " + s);
}

void RegisterHelp(string sText, int nAMask = AMASK_ANY) {
	int nCount = GetLocalInt(GetModule(), "cmd_" + LastCommand + "_h");

	SetLocalString(GetModule(), "cmd_" + LastCommand + "h_" + IntToString(nCount), sText);
	SetLocalInt(GetModule(), "cmd_" + LastCommand + "_ham_" + IntToString(nCount), nAMask);

	nCount++;
	SetLocalInt(GetModule(), "cmd_" + LastCommand + "_h", nCount);
}

void RAF(int n) {
	RegisterAccessFlags(n);
}

void RegisterAccessFlags(int nFlags) {
	object oM = GetModule();
	SetLocalInt(oM, "cmd_" + LastCommand + "_amask", nFlags);
}


void RegisterAllCommands() {
	/* modifiers */
	RegisterCommand("g", "");

	RegisterCommand("self", "");
	
	RegisterCommand("online", "dms");

	RegisterCommand("area", "type=");
	
	RegisterCommand("rect", "x= y= type=");

	RegisterCommand("radius", "r= type=");
	
	RegisterCommand("line", "c=");
	
	RegisterCommand("server", "type=");
	RAF(AMASK_CAN_DO_BACKEND);


	/* public commands */
	RegisterCommand("m", "i d l", 1, 2);
	RHs("MacroName [MacroCode] >> Creates and executes macros");
	RHs("-l >> List all your macros");
	RHs("-d MacroName >> Delete a macro");
	RHs("-i MacroName >> Create a macroitem");

	RegisterCommand("afk", "");
	RHs(">> Sets/unsets AFK mode (with flashy visuals!).");
	RAF(AMASK_ANY);

	RegisterCommand("write", "");
	RHs("text to write >> Writes text onto any parchment.");
	RAF(AMASK_ANY);
	RegisterCommand("password", "");
	RHs("password >> Sets a new password.");
	RAF(AMASK_ANY);
	RegisterCommand("status", "");
	RH("Shows various server-related information.");
	RAF(AMASK_ANY);
	RegisterCommand("ignore", "", 1, 1);
	RAF(AMASK_ANY);
	RegisterCommand("unignore", "", 1, 1);
	RAF(AMASK_ANY);
	RegisterCommand("dice", "", 1, 1);
	RHs("<Anzahl Wuerfel> <Augenzahl Wuerfel> ( Beispiel: /d 3 6 = > 3d6 )");
	RAF(AMASK_ANY);

	RegisterCommand("uptime", "");
	RAF(AMASK_ANY);

	RegisterCommand("weather", "", 0, 0);
	RHs("Shows the current weather.");
	RAF(AMASK_ANY);

	RegisterCommand("v", "");
	RAF(AMASK_ANY);

	RegisterCommand("a", "");
	RA("sit", "a sit");
	RA("sitcross", "a sitcross");
	RA("lieleft", "a lieleft");
	RA("lieright", "a lieright");
	RA("kneel", "a kneel");
	RAF(AMASK_ANY);

	RegisterCommand("rt", "");
	RHs("Reads tracks.");
	RAF(AMASK_ANY);

	/* public-GM hybrids */

	RegisterCommand("follow", "");
	RH("Follow the PC standing next to you.", AMASK_ANY);
	RHs("[target_0] [target_1]", AMASK_GM);
	RHe(">> Follow current target", AMASK_GM);
	RHe("[target_0] >> Make t_0 follow you", AMASK_GM);
	RHe("[target_0] [target_1] >> Make t_0 follow t_1", AMASK_GM);
	RAF(AMASK_ANY);

	RegisterCommand("lastlog", "count=");
	RHs("Zeigt die letzten Zeilen des Gebietschats an, soweit sie dich betreffen.", AMASK_ANY);
	RHs("[-count=20] >> Retrieves the last 15 lines of text spoken.", AMASK_GM);
	RAF(AMASK_CAN_SEE_CHATLOGS);

	/* GM commands */

	RegisterCommand("gi", "", 1, 1);
	RHs("setname >> create item for setname");

	RegisterCommand("gs", "", 0, 1);
	RHs("[setname] >> get/set current set");

	RegisterCommand("ga", "s=", 0, 0);
	RHs("[-s=setname] >> add target to current/setname set");

	RegisterCommand("gc", "s=", 0, 0);
	RHs("[-s=setname] >> clear current/setname set");

	RegisterCommand("n", "x= y= z=", 0, 0);
	RHs("[-x=float] [-y=float] [-z=float] >> nudge current target in direction");


	RegisterCommand("go", "", 1, 1);
	RHs("loc >> Go to location.");
	RegisterCommand("re", "", 0, 0);
	RHs("Return to from whence you came.");

	RegisterCommand("shun", "");
	RegisterCommand("unshun", "");

	RegisterCommand("fix", "", 1, 1);
	RHs("Fixes things.");

	RegisterCommand("obj", "plot= destroyable=");

	RegisterCommand("tag", "", 0, 1);
	RegisterCommand("description", "", 0, 1);

	RegisterCommand("it", "charges=");

	RegisterCommand("charges", "", 0, 1);
	RHs("Gets/Sets the charges of the current item", 1);


	RegisterCommand("cr", "i= c= a= phenotype= subrace= wings= tail= bp= portrait= race= faction= inv", 0, 0);
	RH("ToDo.");

	RegisterCommand("app", "", 0, 1);
	RegisterCommand("phenotype", "", 0, 1);
	RegisterCommand("subrace", "d", 0, 1);
	RHs("[-d] [subr] >> Gets/Sets the subrace", 1);
	RegisterCommand("bp", "", 1, 2);
	RHs("creature_part_const [newvalue] >> Sets a bodypart on the selected target", 1);
	RH("Check /showconst creature for a list of CREATURE_PARTs");

	RegisterCommand("wings", "", 0, 1);
	RHs("[wing_type] >> Gets/Sets the wings on the selected target", 1);

	RegisterCommand("tail", "", 0, 1);
	RHs("[tail_type] >> Gets/Sets the tail on the selected target", 1);
	RegisterCommand("portrait", "", 0, 1);
	RHs("[new_portrait_resref] >> Gets/Sets the portrait", 1);

	RegisterCommand("it", "droppable= weight= value=", 0, 0);
	RH("Shows/sets various item related things.");
	RHs("[--droppable=bool] [--weight=int] [--value=int]");

	RegisterCommand("pl", "useable= persist= plot=", 0, 1);
	RH("Shows/sets various placeable related things.");
	RHs("[--persist=bool] [--useable=bool] [--plot=bool] [placeable scene text]");

	RegisterCommand("rotate", "", 0, 1);
	RHs("[deg] >> Sets gets the rotation either as relative or absolute value.", 1);

	RegisterCommand("castspell", "c f m= c i loc", 1, 1);
	RH("Casts a spell on the current target");
	RHs("[--caster=TARGET (omit for self)] [--fake] [--meta=METAMAGIC] [-c] [-i] [--loc] SpellID", 1);
	RHs("--fake >> Just do the flashy visuals, do not call the spellscript");
	RHs("-i >> Instant cast.  Do not progress action queue, go directly to jail.");
	RHs("-c >> Do not require the spell to be memorised");
	RHs("--loc >> Cast spell on location instead of target");

	RegisterCommand("getdyepot", "", 1, 2);

	RegisterCommand("bloodyhell", "", 0, 0);
	RH("For escapism");



	RegisterCommand("hp", "", 0, 1);
	RHs("[hp] >> Gets/Sets HP.", 1);

//	RegisterCommand("stat", "", 1, 1);
//	RHs("type >> type of (mentor, xp_dist)", 0);
//	RAF(AMASK_AUDIT);

	RegisterCommand("say", "");

	RegisterCommand("ta", "n= tag= area= f= d l m=", 0, 1);
	RHs("[-f 1.." +
		IntToString(TARGET_MAX) +
		"] [-n n] type_of_target(one of: a(ny), ar(ea), pc, n(pc), h(ostile creature), p(laceable), d(oor), i(tem), w(aypoint), st(ore), t(rigger), aoe(area of effect), s(elf), pci(iterate all players), oi(iterate all objects in the area selected by --area), l(ocation, current))",
		1);
	RHs(
		"[-n n] [--area tag] [-m mask] oi >> Find nth object in Area designated by --area (or the current area) where the tag matches mask",
		1);
	RHs("[-n n] --tag Tag a >> Find nth object that has 'Tag' for tag", 1);
	RHs("-d new_default_slot >> Sets your default slot");
	RHs("-l >> List all currently selected targets");
	RAF(AMASK_GM);

	RegisterCommand("time", "yr= mo= dy= hr= mn= sc=");
	RAF(AMASK_CAN_EDIT_GV);

	RegisterCommand("rehash", "", 0, 0);
	RAF(AMASK_CAN_EDIT_GV);

	RegisterCommand("sql", "", 1, 1);
	RAF(AMASK_CAN_DO_BACKEND);
	RegisterCommand("psql", "", 1, 1);
	RAF(AMASK_CAN_DO_BACKEND);

	RegisterCommand("createkey", "app=", 1, 2);
	RHs("[--app=x] key_tag [name]", 0);


	RegisterCommand("lock", "lockable= locked= keytag= keyreq= lockdc= unlockdc=");
	RHs(
		"[--locked bool] [--lockable bool] [--keytag tag] [--keyreq bool] [--lockdc n] [--unlockdc n] >> Shows/sets options on a lock.",
		1);

	RegisterCommand("planewalk", "plane= duration=");
	RHs(
		"[--duration f] [--plane plane] >> Makes the current target planewalk a random plane, or 'plane' for duration seconds, or 120.",
		1);


	RegisterCommand("help", "");
	RAF(AMASK_ANY);

	RegisterCommand("getrecipe", "", 1, 1);
	RHs("id >> Returns recipe with id", 0);
	RAF(AMASK_GLOBAL_GM);

	RegisterCommand("event", "", 0, 2);
	RH("Shows/sets event handlers.");
	RHs(">> Shows events.");
	RHs("eventname script >> Sets script for eventname.");
	RAF(AMASK_GLOBAL_GM);

	RegisterCommand("rmnx", "", 1);
	RAF(AMASK_CAN_DO_BACKEND);

	RegisterCommand("remind", "");



	RegisterCommand("ooc", "");
	RHs("Gibt einen Text in OOC-Farbe aus.");
	RAF(AMASK_ANY);

	RegisterCommand("effect", "durtype= duration= loc e s r", 1, 50);
	RHs("[-durtype=] [-duration=] [-l] effectname >> Applys a effect on the selected target", 1);
	RHs(
		"[-durtype=] [-duration=] [-l] [-e] effectname >> Applys an extraordinary effect on the selected target (can be removed by resting, but not by dispel magic)",
		1);
	RHs(
		"[-durtype=] [-duration=] [-l] [-s] effectname >> Applys a supernatural effect on the selected target (can't be removed by resting or dispel magic)",
		1);
	RHs(" (Setting duration automagically sets durtype to 'temporary'.)");
	RHs("-r >> remove all effects from the selected target", 1);
	RH("Available Effects: ");
	RH(
		"vfx(val) blind() damage(amount, type) deaf() dazed() death() confused() ethereal() knockdown() slow() stunned() timestop() "
		+
		"frightened() haste() curse(str, dex, con, int, wis, chr) polymorph(type locked=bool) acincrease(val) acdecrease(val) disease(type) "
		+
		"abilityincrease(ability, +) abilitydecrease(ability, -) seeinvis() trueseeing() ultravision() speedincrease(val) speeddecrease(val) "
		+
		"skillincrease(skill, val) skilldecrease(skill, val), cutsceneghost()");

	RegisterCommand("_xp", "levelup cap");
	RAF(AMASK_CAN_DO_BACKEND);

	RegisterCommand("info", "");


	RegisterCommand("ar", "rsl tli= tsi= explore");
	RHs("-rsl >> RecomputeStaticLighting() for the current area.");
	RHs("-explore >> Explores the area for the current target.");
	RHs("-tli [new_colour_1] [new_colour_2] >> Gets/Sets MainLight colour for the current tile.");
	RHs("-tsi [new_colour_1] [new_colour_2] >> Gets/Sets SourceLight colour for the current tile.");

	RegisterCommand("inspect", "pl", 0, 0);
	RHs("-pl >> Show persistent placeables.");
	RAF(AMASK_CAN_SET_PERSISTENCY);


	RegisterCommand("so", "type= m=");
	RegisterCommand("ko", "type= m=");

	RegisterCommand("setname", "");

	RegisterCommand("f2s", "");

	RegisterCommand("s2f", "");

	RegisterCommand("fixfactions", "");

	RegisterCommand("limbo", "");

	RegisterCommand("gettargetchooser", "");

	RegisterCommand("restore", "s e? l r");
	RHs("[-e? ID] [-l] -[r] >> Restores a creature to working condition", 1);
	RHs("-r >> Allow immediate resting", 1);
	RHs("-l >> Heal fully", 1);
	RHs("-e [ID] >> Remove all effects, or effects of type ID", 1);
	RHs("-s >> Removes all effects, including supernatural effects.", 1);

	RegisterCommand("set", "");
	RegisterCommand("get", "");

	RegisterCommand("showconst", "");
	RHs(
		"type >> type of (mode, object, phenotype, creature, tail, wing, weather, polymorph, disease, class, duration, damage)");

	RegisterCommand("kill", "d");
	RegisterCommand("create", "");

	RegisterCommand("kick", "");
	RAF(AMASK_GLOBAL_GM);

	RegisterCommand("vfx", "x= y= z=");


	RegisterCommand("fetch", "");
	RHs("[t1] [t2] [tn] >> Fetch those target slots, or fetch the current target to your location.");
	RegisterCommand("jump", "loc");
	RHs("[--loc] >> Jumps to target object or location", 1);
	RegisterCommand("cp", "limbo newslot=");
	RHs("[-newslot=slot] [-limbo]", 1);

	RegisterCommand("cpm", "", 3, 3);
	RHs("a b c >> CopyItemAndModify(Target, a, b, c, TRUE);");

	RegisterCommand("caq", "");
	RHs(">> Clears the action queue.", 1);
	RegisterCommand("wwp", "");
	RHs(">> Makes a creature walk its designated day/night waypoints, or none if none were placed.", 1);
	RegisterCommand("rwalk", "");
	RHs(">> Makes a creature walk randomly.", 1);
}



int OnCommand(object oPC, string sCommand, string sArg, int iMode, int bRunMacro, int bRunAlias, int nRunModLevel) {
	nRunModLevel = u(nRunModLevel);

	// No need for that MODE flag, we know already it is a command.
	if (iMode & MODE_COMMAND)
		iMode -= MODE_COMMAND;

	if (gvGetInt("chat_debug")) {
		SendMessageToAllDMs("chat> run: '" + sCommand + "':'" + sArg + "'::" + IntToString(iMode) + "::" + 
			IntToString(bRunMacro) + ":" + IntToString(bRunAlias) + ":" + IntToString(nRunModLevel));
		SendMessageToAllDMs("chat> runs on: " + GetName(oPC) + " / " + GetName(OBJECT_SELF));
	}

	string sOpt = "";
	int nArgMin = 0;
	int nArgMax = 0;

	if ( bRunAlias ) {
		string sAlias = GetLocalString(GetModule(), "alias_" + sCommand);
		if ( "" != sAlias ) {
			return RunCommand(oPC, iMode, sAlias + " " + sArg, bRunMacro, FALSE, nRunModLevel);
		}
	}

	if ( GetLocalInt(GetModule(), "cmd_" + sCommand) ) {
		sOpt = GetLocalString(GetModule(), "cmd_" + sCommand + "_opt");
		nArgMin = GetLocalInt(GetModule(), "cmd_" + sCommand + "_argc_min");
		nArgMax = GetLocalInt(GetModule(), "cmd_" + sCommand + "_argc_max");
	} else {
		if (gvGetInt("chat_debug")) {
			SendMessageToAllDMs("chat> NOTFOUND(register): '" + sCommand + "':'" + sArg + "'::'" + IntToString(iMode) + "::" + 
				IntToString(bRunMacro) + ":" + IntToString(bRunAlias) + ":" + IntToString(nRunModLevel));
		}
		return NOTFOUND;
	}

	int nAMask = GetLocalInt(GetModule(), "cmd_" + sCommand + "_amask");

	if ( !GetLocalInt(GetModule(), "no_new_acl") && nAMask > 0 && !amask(oPC, nAMask) ) {
		if (gvGetInt("chat_debug")) {
			SendMessageToAllDMs("chat> NOACCESS(): " + sCommand + " " + sArg + IntToString(iMode) + "::" + 
				IntToString(bRunMacro) + ":" + IntToString(bRunAlias) + ":" + IntToString(nRunModLevel));
		}
		return ACCESS;
	}

	getoptreset(oPC);

	getopt(sArg, "h t= sleep= " + sOpt, oPC);

	if ( !opt("h") && GetLocalInt(GetModule(), "cmd_" + sCommand) && (
			( nArgMin > -1 && argc() < nArgMin )
			|| ( nArgMax > -1 && argc() > nArgMax )
		) ) {
		ToPC("Falsche Anzahl an Parametern: Mindestens " +
			IntToString(nArgMin) + " und maximal " + IntToString(nArgMax));
		ToPC("Gib '/" + sCommand + " -h' ein fuer eine Hilfestellung zu diesem Befehl.");
		return SYNTAX;
	}

	if ( opt("h") ) {

		int nCount = GetLocalInt(GetModule(), "cmd_" + sCommand + "_h");
		int nDisp = 0;
		int i = 0;
		for ( i = 0; i < nCount; i++ ) {
			int nMask = GetLocalInt(GetModule(), "cmd_" + sCommand + "ham_" + IntToString(i));
			if ( amask(oPC, nMask) || nMask == 0 ) {
				ToPC(GetLocalString(GetModule(), "cmd_" + sCommand + "h_" + IntToString(i)));
				nDisp++;
			}
		}
		if ( !nDisp )
			ToPC("No help available for this command.");
		return SYNTAX;
	}


	float fWait = 0.0;

	if ( opt("sleep") ) {
		// Wait for w
		fWait = StringToFloat(optv("sleep"));
		fWait = fWait < 0.0 ? 0.0 : fWait;
		fWait = fWait > 120.0 ? 120.0 : fWait;
	}

	setsleep(fWait);

	int ret = 0;

	SetLocalString(GetModule(), "chat_current_command_name", sCommand);

	if ( "m" == sCommand && bRunMacro )
		ret = CommandMacro(oPC, iMode);

	if ( nRunModLevel > 0 ) {
		if ("g" == sCommand)
			ret = CommandModSet(oPC, iMode, nRunModLevel);

		if ("self" == sCommand)
			ret = CommandModSelf(oPC, iMode, nRunModLevel);

		if ("online" == sCommand)
			ret = CommandModOnline(oPC, iMode, nRunModLevel);

		if ("radius" == sCommand)
			ret = CommandModRadius(oPC, iMode, nRunModLevel);

		if ("area" == sCommand)
			ret = CommandModArea(oPC, iMode, nRunModLevel);

		if ("server" == sCommand)
			ret = CommandModServer(oPC, iMode, nRunModLevel);
	}


	// Set management
	if ( "gi" == sCommand )
		ret = CommandManageSetItem(oPC, iMode);
	if ( "gs" == sCommand )
		ret = CommandManageSetSet(oPC, iMode);
	if ( "gc" == sCommand )
		ret = CommandManageSetClear(oPC, iMode);
	if ( "ga" == sCommand )
		ret = CommandManageSetAdd(oPC, iMode);

	if ( "event" == sCommand )
		ret = CommandEventHandler(oPC, iMode);

	if ( "it" == sCommand )
		ret = CommandItem(oPC, iMode);

	if ( "n" == sCommand )
		ret = CommandNudge(oPC, iMode);

	if ( "go" == sCommand )
		ret = CommandGo(oPC, iMode);
	
	if ( "re" == sCommand )
		ret = CommandGoReturn(oPC, iMode);
	
	if ( "sql" == sCommand )
		ret = CommandSQL(oPC, iMode);
	if ( "psql" == sCommand )
		ret = CommandpSQL(oPC, iMode);
	
	if ( "inspect" == sCommand )
		ret = CommandInspect(oPC, iMode);

	if ( "rehash" == sCommand )
		ret = CommandRehash(oPC, iMode);

	if ( "fix" == sCommand )
		ret = CommandFix(oPC, iMode);

	if ( "rt" == sCommand )
		ret = CommandReadTracks(oPC, iMode);

	if ( "afk" == sCommand )
		ret = CommandAFK(oPC, iMode);

	if ( "cr" == sCommand )
		ret = CommandCreature(oPC, iMode);

	if ( "obj" == sCommand )
		ret = CommandObject(oPC, iMode);

	if ( "pl" == sCommand )
		ret = CommandPlaceable(oPC, iMode);

	if ( "weather" == sCommand )
		ret = CommandShowWeather(oPC, iMode);

	if ( "tag" == sCommand )
		ret = CommandTag(oPC, iMode);

	if ( "description" == sCommand )
		ret = CommandDescription(oPC, iMode);

	if ( "castspell" == sCommand )
		ret = CommandCastSpell(oPC, iMode);

	if ( "getdyepot" == sCommand )
		ret = CommandGetDyePot(oPC, iMode);

	if ( "bloodyhell" == sCommand )
		ret = CommandOhHellBang(oPC, iMode);

	if ( "rotate" == sCommand )
		ret = CommandRotate(oPC, iMode);

	if ( "hp" == sCommand )
		ret = CommandHP(oPC, iMode);

//	if ( "stat" == sCommand )
//		ret = CommandStat(oPC, iMode);

	if ( "createkey" == sCommand )
		ret = CommandCreateKey(oPC, iMode);

	if ( "say" == sCommand )
		ret = CommandSay(oPC, iMode);

	if ( "write" == sCommand )
		ret = CommandWrite(oPC, iMode);


	if ( "time" == sCommand )
		ret = CommandTime(oPC, iMode);

	if ( "lock" == sCommand )
		ret = CommandLock(oPC, iMode);

	if ( "planewalk" == sCommand )
		ret = CommandPlaneWalk(oPC, iMode);


	if ( "getrecipe" == sCommand )
		ret = CommandGetRecipe(oPC, iMode);

	if ( "rmnx" == sCommand )
		ret = CommandRMNX(oPC, iMode);

	if ( "remind" == sCommand )
		ret = CommandRemind(oPC, iMode);

	if ( "lastlog" == sCommand )
		ret = CommandLastLog(oPC, iMode);

	if ( "uptime" == sCommand )
		ret = CommandUptime(oPC, iMode);

	if ( "charges" == sCommand )
		ret = CommandCharges(oPC, iMode);

	if ( "ooc" == sCommand )
		ret = CommandOOC(oPC, iMode);

	if ( "effect" == sCommand )
		ret = CommandEffect(oPC, iMode);

	if ( "_xp" == sCommand )
		ret = CommandXP(oPC, iMode);

	if ( "info" == sCommand )
		ret = CommandInfo(oPC, iMode);

	if ( "password" == sCommand )
		ret = CommandPassword(oPC, iMode);

	if ( "status" == sCommand )
		ret = CommandStatus(oPC, iMode);

	if ( "ta" == sCommand )
		ret = CommandTarget(oPC, iMode);

	if ( "portrait" == sCommand )
		ret = CommandPortrait(oPC, iMode);

	if ( "bp" == sCommand )
		ret = CommandBodyPart(oPC, iMode);

	if ( "wings" == sCommand )
		ret = CommandWing(oPC, iMode);

	if ( "tail" == sCommand )
		ret = CommandTail(oPC, iMode);

	if ( "subrace" == sCommand )
		ret = CommandSubRace(oPC, iMode);

	if ( "ar" == sCommand )
		ret = CommandArea(oPC, iMode);


	if ( "shun" == sCommand )
		ret = CommandShunUnshun(oPC, iMode, 1);

	if ( "unshun" == sCommand )
		ret = CommandShunUnshun(oPC, iMode, 0);

	if ( "ignore" == sCommand )
		ret = CommandIgnoreList(oPC, iMode, 1);

	if ( "unignore" == sCommand )
		ret = CommandIgnoreList(oPC, iMode, 0);

	if ( "so" == sCommand )
		ret = CommandShowObj(oPC, iMode);

	if ( "ko" == sCommand )
		ret = CommandKillObj(oPC, iMode);

	if ( "setname" == sCommand )
		ret = CommandSetName(oPC, iMode);

	if ( "app" == sCommand )
		ret = CommandSetAppearance(oPC, iMode);

	if ( "pht" == sCommand )
		ret = CommandSetPhenotype(oPC, iMode);

	if ( "f2s" == sCommand )
		ret = CommandFleshToStone(oPC, iMode);

	if ( "s2f" == sCommand )
		ret = CommandStoneToFlesh(oPC, iMode);

	if ( "fixfactions" == sCommand )
		ret = CommandFixFactions(oPC, iMode);

	if ( "limbo" == sCommand )
		ret = CommandLimbo(oPC, iMode);

	if ( "gettargetchooser" == sCommand )
		ret = CommandGetTargetChooser(oPC, iMode);

	if ( "restore" == sCommand )
		ret = CommandRestore(oPC, iMode);

	if ( "set" == sCommand )
		ret = CommandSetVar(oPC, iMode);

	if ( "get" == sCommand )
		ret = CommandGetVar(oPC, iMode);


	if ( "showconst" == sCommand )
		ret = CommandShowConst(oPC, iMode);

	if ( "kill" == sCommand )
		ret = CommandKill(oPC, iMode);

	if ( "create" == sCommand )
		ret = CommandCreate(oPC, iMode);

	if ( "v" == sCommand )
		ret = CommandVoiceChat(oPC, getoptargs(), iMode);

	if ( "a" == sCommand )
		ret = CommandAnimation(oPC, getoptargs(), iMode);

	/* aliases for anim */
	if ( "sit" == sCommand )
		ret = CommandAnimation(oPC, "sit", iMode);

	if ( "meditate" == sCommand )
		ret = CommandAnimation(oPC, "meditate", iMode);

	if ( "sitcross" == sCommand )
		ret = CommandAnimation(oPC, "sitcross", iMode);

	if ( "dance" == sCommand )
		ret = CommandAnimation(oPC, "dance", iMode);

	if ( "kneel" == sCommand )
		ret = CommandAnimation(oPC, "kneel", iMode);

	if ( "lieleft" == sCommand )
		ret = CommandAnimation(oPC, "lieleft", iMode);

	if ( "lieright" == sCommand )
		ret = CommandAnimation(oPC, "lieright", iMode);

	/* end of alias list */

	if ( "kick" == sCommand )
		ret = CommandKick(oPC, iMode);

	if ( "vfx" == sCommand )
		ret = CommandVFX(oPC, iMode);

	if ( "fx" == sCommand )
		ret = CommandFX(oPC, iMode);

	if ( "die" == sCommand || "dice" == sCommand )
		ret = CommandDice(oPC, iMode);


	if ( "fetch" == sCommand )
		ret = CommandFetch(oPC, iMode);

	if ( "jump" == sCommand )
		ret = CommandJump(oPC, iMode);

	if ( "cp" == sCommand )
		ret = CommandCopyObject(oPC, iMode);

	if ( "cpm" == sCommand )
		ret = CommandCopyMod(oPC, iMode);

	if ( "follow" == sCommand )
		ret = CommandFollow(oPC, iMode);

	if ( "caq" == sCommand )
		ret = CommandCAQ(oPC, iMode);


	if ( "wwp" == sCommand )
		ret = CommandWWP(oPC, iMode);


	if ( "rwalk" == sCommand )
		ret = CommandRandomWalk(oPC, iMode);
	
	SetLocalString(GetModule(), "chat_current_command_name", "");

	// SendMessageToAllDMs("chat> NOTFOUND(call): " + sCommand + " " + sArg + IntToString(iMode) + "::" + 
	//	IntToString(bRunMacro) + ":" + IntToString(bRunAlias) + ":" + IntToString(nRunModLevel));

	return ret;
}





int GetIsMacro(object oPC, string sMacroName) {
	string sAID = IntToString(GetAccountID(oPC));
	pQ("select id from macro where account = " +
		sAID + " and macro = " + pE(sMacroName) + " limit 1;");
	return pF();
}


void RunMacro(object oPC, int iMode, string sMacro) {
	ToPC("Executing macro '" + sMacro + "'.");

	int nSlot = TARGET_MACRO_SLOT;

	if ( opt("t") )
		nSlot = GetTargetSlot();

	int nOldTarget = GetDefaultSlot();

	SetDefaultSlot(nSlot);

	CommandEval(oPC, iMode, sMacro, FALSE, TRUE, gvGetInt("s_modlevel_macro"));

	SetDefaultSlot(nOldTarget);

	ToPC("Done.");


}

int CommandMacro(object oPC, int iMode) {
	if ( !amask(oPC, AMASK_CAN_USE_MACROS) )
		return ACCESS;

	// create/update: macro "macroname" "macrovalue"
	// run: macro "macroname"
	// create item: macro -i "macroname"
	// delete: macro -d "macroname"


	string sAID = IntToString(GetAccountID(oPC));
	if ( "0" == sAID ) {
		ToPC("You have no Account ID.");
		return OK;
	}

	string sMacroName = GetStringLowerCase(arg(0));
	string sMacro = arg(1);


	if ( opt("d") ) {
		pQ("select id from macro where account = " +
			sAID + " and macro = " + pE(sMacroName) + " order by account desc limit 1;");
		if ( pF() ) {
			// Delete the macro
			pQ("delete from macro where account = " +
				sAID + " and macro = " + pE(sMacroName) + " limit 1;");
			ToPC("Macro '" + sMacroName + "' deleted.");
		} else {
			ToPC("Macro '" + sMacroName + "' not found (or not yours).");
			return FAIL;
		}

		return OK;
	}

	if ( opt("l") ) {
		pQ("select id,macro,command from macro where (account = " +
			sAID + " or account = 0) order by account desc;");
		int n = 0;
		while ( pF() ) {
			sMacroName = pG(2);
			sMacro = pG(3);
			ToPC(sMacroName + ": " + sMacro);
			n++;
		}
		ToPC(IntToString(n) + " macros displayed.");
		return OK;

	}

	if ( opt("i") ) {
		pQ("select command from macro where (account = " +
			sAID +
			" or account = 0) and macro = " + pE(sMacroName) + " order by account desc limit 1;");
		if ( !pF() ) {
			ToPC("Macro not found.");
			return FAIL;
		} else {
			sMacro = pG(1);
			object oI = CreateItemOnObject("macro", oPC, 1);
			SetName(oI, "Macro: " + sMacroName);
			SetLocalString(oI, "macro", sMacro);
			SetLocalInt(oI, "aid", StringToInt(sAID));
		}

		return OK;
	}


	if ( argc() == 1 ) {
		pQ("select command from macro where (account = " +
			sAID +
			" or account = 0) and macro = " + pE(sMacroName) + " order by account desc limit 1;");
		if ( !pF() ) {
			ToPC("Macro not found.");
			return FAIL;
		} else {
			sMacro = pG(1);
			DelayCommand(getsleep(), RunMacro(oPC, iMode, sMacro));
		}

	} else {
		// save new personal macro
		SetLocalString(oPC, "macro_" + sMacroName, sMacro);
		pQ("select id from macro where account = " +
			sAID + " and macro = " + pE(sMacroName) + " limit 1;");
		if ( pF() ) {
			string sID = pG(1);
			pQ("update macro set command = " + pE(sMacro) + " where id = " + sID + ";");
			ToPC(sMacroName + " updated.");
		} else {
			pQ("insert into macro (account, macro, command) values(" +
				sAID + ", " + pE(sMacroName) + ", " + pE(sMacro) + ");");
			ToPC(sMacroName + " saved.");
		}



	}

	return OK;
}



int CommandModSet(object oPC, int iMode, int nRunModLevel) {
	string sRest = arg(0);
	
	if (gvGetInt("chat_debug")) {
		SendMessageToAllDMs("chat:mod:self> " + sRest);
	}
	
	int nOldTarget = GetDefaultSlot();
	SetDefaultSlot(TARGET_MACRO_SLOT);
	
	string sSetName = GetCurrentSet(oPC);

	int nSz = GetSetSize(sSetName, oPC);
	int i;
	int ret;
	object t;
	for (i = 0; i < nSz; i++) {
		t = GetFromSet(sSetName, i, oPC);
		SetTarget(t);
		ret = CommandEval(oPC, iMode, sRest, 1, 1, nRunModLevel - 1);
		if (!ret)
			return FAIL;
	}
	
	SetDefaultSlot(nOldTarget);

	return OK;
}


int CommandModSelf(object oPC, int iMode, int nRunModLevel) {
	string sRest = arg(0);
	
	int nOldTarget = GetDefaultSlot();
	SetDefaultSlot(TARGET_MACRO_SLOT);
	
	SetTarget(oPC);
	
	if (gvGetInt("chat_debug")) {
		SendMessageToAllDMs("chat:mod:self> " + sRest);
	}
	
	int ret = CommandEval(oPC, iMode, sRest, 1, 1, nRunModLevel - 1);

	SetDefaultSlot(nOldTarget);
	// ClearTarget(oPC, TARGET_MACRO_SLOT);
	//
	return ret ? OK : FAIL;
}

int CommandModRadius(object oPC, int iMode, int nRunModLevel) {
	string sRest = arg(0);
	
	float radius = 6.0;
	int otype = OBJECT_TYPE_ALL;

	if (opt("r"))
		radius = StringToFloat(optv("r"));

	if (opt("type"))
		otype = StringToInt(optv("type"));

	if (gvGetInt("chat_debug"))
		SendMessageToAllDMs("chat:mod:radius> r = " + FloatToString(radius));
	
	int nOldTarget = GetDefaultSlot();
	SetDefaultSlot(TARGET_MACRO_SLOT);

	object oLoop = GetFirstObjectInShape(SHAPE_SPHERE, radius, GetLocation(oPC), FALSE, otype);
	while (GetIsObjectValid(oLoop)) {
		SetTarget(oLoop);
		if (!CommandEval(oPC, iMode, sRest, 1, 1, nRunModLevel - 1)) {
			if (gvGetInt("chat_debug"))
				SendMessageToAllDMs("chat:mod:radius> Eval() returned FALSE");
			return FAIL;
		}
		
		oLoop = GetNextObjectInShape(SHAPE_SPHERE, radius, GetLocation(oPC), FALSE, otype);
	}
	SetDefaultSlot(nOldTarget);

	return OK;
}

int CommandModRectangle(object oPC, int iMode, int nRunModLevel) {
	ToPC("mod:rect> Not in yet.");
	return FAIL;
}

int CommandModLine(object oPC, int iMode, int nRunModLevel) {
	ToPC("mod:line> Not in yet.");
	return FAIL;
}

int CommandModArea(object oPC, int iMode, int nRunModLevel) {
	string sRest = arg(0);
	int otype = OBJECT_TYPE_ALL;
	
	if (opt("type"))
		otype = StringToInt(optv("type"));
	
	int nOldTarget = GetDefaultSlot();
	SetDefaultSlot(TARGET_MACRO_SLOT);

	object oLoop = GetFirstObjectInArea(GetArea(oPC));
	while (GetIsObjectValid(oLoop)) {
		if (GetObjectType(oLoop) == otype) {
			SetTarget(oLoop);
			if (!CommandEval(oPC, iMode, sRest, 1, 1, nRunModLevel - 1)) {
				if (gvGetInt("chat_debug"))
					SendMessageToAllDMs("chat:mod:area> Eval() returned FALSE");
				return FAIL;
			}
		}

		oLoop = GetNextObjectInArea(GetArea(oPC));
	}
	SetDefaultSlot(nOldTarget);

	return OK;
return FAIL;
}

int CommandModServer(object oPC, int iMode, int nRunModLevel) {
	ToPC("mod:server> Not in yet.");
	return FAIL;
}

int CommandModOnline(object oPC, int iMode, int nRunModLevel) { 
	string sRest = arg(0);
	
	int bDoDM = opt("dms");

	int nOldTarget = GetDefaultSlot();
	SetDefaultSlot(TARGET_MACRO_SLOT);

	object oLoop = GetFirstPC();
	while (GetIsObjectValid(oLoop)) {

		SetTarget(oLoop);
		
		if (gvGetInt("chat_debug")) {
			SendMessageToAllDMs("chat:mod:online> " + sRest + ": " + GetName(oLoop));
		}

		if (!CommandEval(oPC, iMode, sRest, 1, 1, nRunModLevel - 1)) {
			if (gvGetInt("chat_debug"))
				SendMessageToAllDMs("chat:mod:online> Eval() returned FALSE");
			return FAIL;
		}
		
		if (gvGetInt("chat_debug"))
			SendMessageToAllDMs("chat:mod:online> continuing.");

		oLoop = GetNextPC();
	}

	SetDefaultSlot(nOldTarget);

	return OK;
}


