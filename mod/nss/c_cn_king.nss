int StartingConditional() {
	int l_iResult;

	l_iResult = ( GetTag(OBJECT_SELF) == "c_king_w" || GetTag(OBJECT_SELF) == "c_king_b" );
	return l_iResult;
}
