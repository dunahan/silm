// user has to pay for this fetch

#include "inc_horse"
#include "inc_currency"

int StartingConditional() {
	struct Rideable r = GetRideable(GetPCSpeaker());


	float fRent = GetLocalFloat(OBJECT_SELF, "rent_per_day");
	if ( 0.0 == fRent )
		fRent = DAILY_RENT;

	int n = GetRideableRentCost(r, fRent);

	if ( n > 0 )
		SendMessageToPC(GetPCSpeaker(), "Die aktuellen Mietskosten fuer Euer Reittier belaufen sich auf " +
			MoneyToString(Value2Money(n)) + ".");


	return n > 0;
}
