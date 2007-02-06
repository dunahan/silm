/*
 * File: _events_itemdemo
 * A tag-execution based event system.
 * Copyright Bernard 'elven' Stoeckner.
 *
 * This code is licenced under the
 *  GNU/GPLv2 General Public Licence.
 */

/*
 * 	This is a DEMONSTRATION file. Copy
 * 	and edit to suit your needs.
 */

#include "_events"

void main() {
	switch ( GetEvent() ) {
		case EVENT_ITEM_ACTIVATE:
			/* Here be code to handle Item Activation */
			break;
		case EVENT_ITEM_EQUIP:
			/* etc */
			break;
		case EVENT_ITEM_UNEQUIP:
			break;
		case EVENT_ITEM_ONHITCAST:
			break;
		case EVENT_ITEM_ACQUIRE:
			break;
		case EVENT_ITEM_UNACQUIRE:
			break;
		case EVENT_ITEM_SPELLCAST_AT:
			break;

		default: /* You might want to leave this stub intact,
				  *   for debugging purposes. */
			SendMessageToAllDMs("Warning in event system: Unhandled event.");
			SendMessageToAllDMs(" Script: " + GetTag(OBJECT_SELF));
			SendMessageToAllDMs(" Event : " + IntToString(GetEvent()));
			break;
	}

}
