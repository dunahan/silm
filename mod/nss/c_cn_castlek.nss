#include "c_chessinc"

int StartingConditional() {
	int l_iResult;

	l_iResult = ( GetLocalInt(OBJECT_SELF, "castlekingside") == 1 );
	return l_iResult;
}
