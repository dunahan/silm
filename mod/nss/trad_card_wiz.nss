#include "inc_summon"

int StartingConditional() {
	return ( DetermineClassStructure(GetPCSpeaker()) & 3 ) > 0;

}
