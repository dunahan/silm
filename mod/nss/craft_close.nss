#include "inc_craft"

void main() {
	object oPC = GetLastClosedBy();
	object oWorkPlace = OBJECT_SELF;

	OnClose(oPC, OBJECT_SELF);
}
