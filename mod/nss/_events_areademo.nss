/*
 * File: _events_areademo
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
		case EVENT_AREA_ENTER:
			/* Here be code to handle when some object enters this area */
			break;
		case EVENT_AREA_EXIT:
			/* etc */
			break;
		case EVENT_AREA_HB:
			break;
		case EVENT_AREA_UDEF:
			break;

		default: /* You might want to leave this stub intact,
				  *   for debugging purposes. */
			SendMessageToAllDMs("Warning in event system: Unhandled event.");
			SendMessageToAllDMs(" Script: " + GetTag(OBJECT_SELF));
			SendMessageToAllDMs(" Event : " + IntToString(GetEvent()));
			break;
	}

}
