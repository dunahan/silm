/* Debugging Stuff */

void PC(string s);
void DM(string s);
void l(string s, string sSection = "log");



void DM(string s) {
	SendMessageToAllDMs(s);
}

void PC(string s) {
	object pc = GetFirstPC();
	while ( GetIsObjectValid(pc) ) {
		SendMessageToPC(pc, s);
		pc = GetNextPC();
	}
}

void l(string s, string sSection = "log") {
	DM(sSection + "> " + s);
	PC(sSection + "> " + s);
	WriteTimestampedLogEntry(sSection + "> " + s);
}
