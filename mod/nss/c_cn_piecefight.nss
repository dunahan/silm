int StartingConditional() {
	int l_iResult;

	l_iResult = ( GetLocalInt(GetNearestObjectByTag("c_gamemaster"), "piecefight") == 1 );
	return l_iResult;
}
