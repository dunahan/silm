#include "inc_corpse_def"

int StartingConditional() {
	return GetLocalInt(OBJECT_SELF, "Item_IncompleteList") & ( CRP_LIST_MISSED );
}
