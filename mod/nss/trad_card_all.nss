#include "inc_summon"

int StartingConditional() {
	return ( DetermineClassStructure(GetPCSpeaker()) & 7 ) == 0;

}
