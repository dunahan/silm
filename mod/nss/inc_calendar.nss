#include "_mnx"

string FormatDate(string sFormatString, int nYear, int nMonth, int nDayOfMonth, int nHour, int nMinute,
				  int nSecond);


string GetMonthName(int nMonth);

string GetMonthName(int nMonth) {
	switch ( nMonth ) {
		case 1: return "Hammer";

		case 2: return "Alturiak";

		case 3: return "Ches";

		case 4: return "Tarsakh";

		case 5: return "Mirtul";

		case 6: return "Kythorn";

		case 7: return "Flamerule";

		case 8: return "Elesias";

		case 9: return "Eleint";

		case 10: return "Marpenoth";

		case 11: return "Uktar";

		case 12: return "Nightal";
	}

	return "Unbekannter Monat (Bug)";
}




string FormatDate(string sFormatString, int nYear, int nMonth, int nDayOfMonth, int nHour, int nMinute,
				  int nSecond) {
	struct mnxRet r = mnxCmd("formatdate", sFormatString, IntToString(nYear), IntToString(nMonth),
						  IntToString(nDayMonth),
						  IntToString(nHour), IntToString(nMinute), IntToString(nSecond));
	if ( r.error )
		return "Error";
	else
		return r.ret;
}
