#include "inc_mysql"
#include "_gen"


const string CACHEPREFIX = "hsc_",
			 TABLE = "hidden_spawns";


struct HiddenSpawn {
	string type;

	int dc_lore;
	int dc_search;

	string resref;

	int spawn_probability;
	int spawn_delay;

	int max_per_area;
	int max_in_search_distance;

	float search_distance;


	string location_bonus;
//    int location_bonus;
};



string HiddenSpawnToString(struct HiddenSpawn hsH);


int GetIsHiddenSpawnValid(struct HiddenSpawn hsH);

// Do NOT do other sql queries while looping with these.
struct HiddenSpawn GetFirstHiddenSpawnForType(string sType);

// Do NOT do other sql queries while looping with these.
struct HiddenSpawn GetNextHiddenSpawnForType(string sType);

struct HiddenSpawn GetHiddenSpawn(string sType, int nNth = 0);

// Returns the number of hiddenspawns for sType in the DB.
int GetHiddenSpawnCount(string sType);

int GetLocationBonus(object oPC, struct HiddenSpawn hsH);

int BuildCache();

void InvalidateCache();

int HasCache();



string HiddenSpawnToString(struct HiddenSpawn hsH) {
	return "HS2(" +
		   hsH.type +
		   " = " +
		   hsH.resref + ", Lore=" + IntToString(hsH.dc_lore) + " Search=" + IntToString(hsH.dc_search) +
		   " SpawnProb=" +
		   IntToString(hsH.spawn_probability) +
		   " MPA=" + IntToString(hsH.max_per_area) + " MISD=" + IntToString(hsH.max_in_search_distance) +
		   " SD= " + FloatToString(hsH.search_distance) + ")";

}

int GetLocationBonus(object oPC, struct HiddenSpawn hsH) {
	if (
		"natur" == hsH.location_bonus &&

		(
			GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 3
			|| GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 3
		)
	)
		return 4;

	if (
		"stein" == hsH.location_bonus &&

		(
			GetRacialType(oPC) == RACIAL_TYPE_DWARF
		)
	)
		return 4;

	return 0;
}


int HasCache() {
	return GetLocalInt(GetModule(), CACHEPREFIX + "cache");
}


int BuildCache() {
	if ( HasCache() )
		InvalidateCache();

	SendMessageToAllDMs("Building hiddenspawn cache ..");
	int nLoaded = 0;

	object oM = GetModule();

	int nThisType = 0,
		nTypeCount = 0;

	string sThisType = "";

	SQLQuery(
		"select type, resref, location, dc_search, dc_lore, max_per_area, max_in_search_distance, search_distance, spawn_probability, spawn_delay from `"
		+ TABLE + "` order by type asc, resref asc, dc_search asc;");
	while ( SQLFetch() ) {
		string sType = SQLGetData(1);

		// Start new type.
		if ( sType != sThisType ) {
			nThisType = 0;
			sThisType = sType;

			SetLocalString(oM, CACHEPREFIX + "type_" + IntToString(nTypeCount), sType);

			nTypeCount++;
			SetLocalInt(oM, CACHEPREFIX + "type_count", nTypeCount);
		}


		// hsc_type_wald_0_(resref,location)
		SetLocalString(oM, CACHEPREFIX +
			"type_" + sType + "_" + IntToString(nThisType) + "_resref", SQLGetData(2));
		SetLocalString(oM, CACHEPREFIX +
			"type_" + sType + "_" + IntToString(nThisType) + "_location", SQLGetData(3));

		// hsc_type_wald_0_(dc_search, dc_lore)
		SetLocalInt(oM, CACHEPREFIX +
			"type_" + sType + "_" + IntToString(nThisType) + "_dc_search", StringToInt(SQLGetData(4)));
		SetLocalInt(oM, CACHEPREFIX +
			"type_" + sType + "_" + IntToString(nThisType) + "_dc_lore", StringToInt(SQLGetData(5)));
		SetLocalInt(oM, CACHEPREFIX +
			"type_" + sType + "_" + IntToString(nThisType) + "_mpa", StringToInt(SQLGetData(6)));
		SetLocalInt(oM, CACHEPREFIX +
			"type_" + sType + "_" + IntToString(nThisType) + "_misd", StringToInt(SQLGetData(7)));

		// hsc_type_wald_0_(search_distance, spawn_probability)
		SetLocalFloat(oM, CACHEPREFIX +
			"type_" + sType + "_" + IntToString(nThisType) + "_search_distance", StringToFloat(SQLGetData(8)));
		int nSP = StringToInt(SQLGetData(9));
		nSP = nSP > 100 ? 100 : nSP < 1 ? 1 : nSP;
		SetLocalInt(oM, CACHEPREFIX +
			"type_" + sType + "_" + IntToString(nThisType) + "_spawn_probability", nSP);
		SetLocalInt(oM, CACHEPREFIX +
			"type_" + sType + "_" + IntToString(nThisType) + "_spawn_delay", StringToInt(SQLGetData(10)));

		nThisType++;
		SetLocalInt(oM, CACHEPREFIX + "type_" + sType, nThisType);
		nLoaded++;
	}

	SetLocalInt(oM, CACHEPREFIX + "cache", 1);
	SendMessageToAllDMs(".. done: " + IntToString(nLoaded) + " loaded.");
	return nLoaded;
}


void InvalidateCache() {
	SendMessageToAllDMs("Invalidating hiddenspawn cache ..");
	object oM = GetModule();
	SetLocalInt(oM, CACHEPREFIX + "cache", 0);

	int nCount = GetLocalInt(oM, CACHEPREFIX + "type_count");
	int i;
	string sType;
	for ( i = 0; i < nCount; i++ ) {
		sType = GetLocalString(oM, CACHEPREFIX + "type_" + IntToString(i));
		SetLocalInt(oM, CACHEPREFIX + "type_" + sType, 0);
	}
	SendMessageToAllDMs("done.");
}


int GetIsHiddenSpawnValid(struct HiddenSpawn hsH) {
	return hsH.type != "" && hsH.resref != "";
}

struct HiddenSpawn GetFirstHiddenSpawnForType(string sType) {
	if ( !HasCache() )
		BuildCache();

	SetLocalInt(OBJECT_SELF, CACHEPREFIX + sType + "_iter", 0);

	return GetNextHiddenSpawnForType(sType);
}


struct HiddenSpawn GetNextHiddenSpawnForType(string sType) {

	int nIter = GetLocalInt(OBJECT_SELF, CACHEPREFIX + sType + "_iter");
	SetLocalInt(OBJECT_SELF, CACHEPREFIX + sType + "_iter", nIter + 1);

	return GetHiddenSpawn(sType, nIter);
}


int GetHiddenSpawnCount(string sType) {
	if ( !HasCache() ) {
		SendMessageToAllDMs("Warning: GetHiddenSpawnCount() called without having a cache built.");
		return 0;
	}

	return GetLocalInt(GetModule(), CACHEPREFIX + "type_" + sType);
}

struct HiddenSpawn GetHiddenSpawn(string sType, int nNth = 0) {
	struct HiddenSpawn r;

	if ( !HasCache() ) {
		SendMessageToAllDMs("Warning: GetHiddenSpawnCount() called without having a cache built.");
		return r;
	}

	object oM = GetModule();
	string sNth = IntToString(nNth);

	if ( nNth >= GetLocalInt(oM, CACHEPREFIX + "type_" + sType) )
		return r;

	r.resref = GetLocalString(oM, CACHEPREFIX + "type_" + sType + "_" + sNth + "_resref");

	if ( r.resref == "" )
		return r;

	r.location_bonus = GetLocalString(oM, CACHEPREFIX + "type_" + sType + "_" + sNth + "_location");

	r.dc_search = GetLocalInt(oM, CACHEPREFIX + "type_" + sType + "_" + sNth + "_dc_search");
	r.dc_lore = GetLocalInt(oM, CACHEPREFIX + "type_" + sType + "_" + sNth + "_dc_lore");
	r.max_per_area = GetLocalInt(oM, CACHEPREFIX + "type_" + sType + "_" + sNth + "_mpa");
	r.max_in_search_distance = GetLocalInt(oM, CACHEPREFIX + "type_" + sType + "_" + sNth + "_misd");

	// hsc_type_wald_0_(search_distance, spawn_probability)
	r.search_distance = GetLocalFloat(oM, CACHEPREFIX + "type_" + sType + "_" + sNth + "_search_distance");
	r.spawn_probability = GetLocalInt(oM, CACHEPREFIX + "type_" + sType + "_" + sNth + "_spawn_probability");
	r.spawn_delay = GetLocalInt(oM, CACHEPREFIX + "type_" + sType + "_" + sNth + "_spawn_delay");

	r.type = sType;

	return r;
}
