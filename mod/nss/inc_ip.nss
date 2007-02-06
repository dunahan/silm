#include "inc_2dacache"

string GetItemPropertyName(itemproperty itemp);


string GetItemPropertyName(itemproperty itemp) {
	int nType = GetItemPropertyType(itemp);
	int nRef = StringToInt(Get2DACached("itemprops", "StringRef", nType));
	if ( nRef == 0 )
		return "Unbekannt/Bug/Nicht in 2da";

	return GetStringByStrRef(nRef);
}



