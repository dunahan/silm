int Is_Billable(object oItem, int iDebting = FALSE) {
	return ( GetStringLeft(GetTag(oItem), 3)  == "CS_"
			|| GetStringLeft(GetTag(oItem), 13) == "NW_IT_MPOTION" )
		   && GetPlotFlag(oItem)
		   && ( !iDebting || !GetLocalInt(oItem, "NoBilling") );
}

