#include "inc_mnx_temp"
// hb script run every hour that sets the actual weather for all areas


void UpdateForPlayer(object oPlayer) {
	object oArea = GetArea(oPlayer);

	if ( !GetIsObjectValid(oArea) || GetIsAreaInterior(oArea) )
		return;

	struct Weather w = GetWeatherFor(oArea, GetCalendarYear(), GetCalendarMonth(), GetCalendarDay(),
						   GetTimeHour(), GetTimeMinute());
	SetEngineWeatherFromWeather(oArea, w);
}

void main() {
	object oPC = GetFirstPC();
	while ( GetIsObjectValid(oPC) ) {
		UpdateForPlayer(oPC);

		oPC = GetNextPC();
	}

}
