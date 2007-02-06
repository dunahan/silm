void main() {

	int c = 0;
	object oItem = GetFirstItemInInventory();
	while ( GetIsObjectValid(oItem) ) {
		DestroyObject(oItem);
		c += 1;
		oItem = GetNextItemInInventory();
	}

	if ( c > 0 ) {
		switch ( Random(3) ) {
			case 1:
			case 0:
				AssignCommand(OBJECT_SELF, ActionSpeakString(
						"*Als ihr die Kiste schliesst leuchten die Runen am Schloss kurz auf, " +
						"und ihr vernehmt ein kurzes, aber heftiges Poltern und Rumpeln in der Kiste.*",
						TALKVOLUME_TALK)
				);
				break;
			case 2:
				AssignCommand(OBJECT_SELF, ActionSpeakString(
						"*Die Kiste gibt ein rumpelndes Ger�usch von sich. Wenn ihr es nicht " +
						"besser w�sstet, w�rdet ihr denken, sie h�tte ger�lpst.*", TALKVOLUME_TALK)
				);
				break;
		}
	} else {
		AssignCommand(OBJECT_SELF, ActionSpeakString("*Die Kiste seufzt entt�uscht.*", TALKVOLUME_TALK));
	}
}
