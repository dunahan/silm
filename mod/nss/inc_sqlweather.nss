#include "inc_mysql"

const string
WEATHER_TABLE = "weather";


// Queries the SQL DB and updates the visuals in oArea
void UpdateEngineAreaForWeather(object oArea);



// Consults the local variables in oArea and shows the weather for oPlayer.
void ShowWeatherForPlayer(object oPlayer, object oArea = OBJECT_INVALID);



void UpdateEngineAreaForWeather(object oArea) {
	int nYear = GetCalendarYear();
	int nMonth = GetCalendarMonth();
	int nDay = GetCalendarDay();
	int nHour = GetTimeHour();

	int nCurrentWeather = GetLocalInt(oArea, "cweather");


	SQLQuery("select id,wthis,textkey,fogv,fogc,engine from " + WEATHER_TABLE + " where year = "
		+ IntToString(nYear) +
		" and month = " + IntToString(nMonth) + " and day = " + IntToString(nDay) + " and hour = "
		+ IntToString(nHour) + " order by id desc limit 1"
	);

	int nID = StringToInt(SQLGetData(1));
	string sTextKey = SQLGetData(3);
	int nFogV = StringToInt(SQLGetData(4));
	int nFogC = StringToInt(SQLGetData(5));

	string sWeather = SQLGetData(6);
	int nWeather = 0;
	if ( "clear" == sWeather )
		nWeather = WEATHER_CLEAR;
	if ( "rain" == sWeather )
		nWeather = WEATHER_RAIN;
	if ( "snow" == sWeather )
		nWeather = WEATHER_SNOW;

	if ( GetWeather(oArea) != nEngine )
		SetWeather(oArea, nEngine);

	SetFogAmount(FOG_TYPE_ALL, nFogV, oArea);
	SetFogColor(FOG_TYPE_ALL, nFogC, oArea);

	SetLocalInt(oArea, "w_id", nID);
	SetLocalInt(oArea, "w_this", nThis);
	SetLocalInt(oArea, "w_fogv", nFogV);
	SetLocalInt(oArea, "w_fogc", nFogC);
	SetLocalInt(oArea, "w_key", nTextKey);
}
