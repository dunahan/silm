void _DestNonDrop(object oOb) {
	if ( GetIsObjectValid(oOb) && !GetDroppableFlag(oOb) )
		DestroyObject(oOb);
}

void _CleanInv() {
	int i;
	object oOb;

	for ( i = 0; i < NUM_INVENTORY_SLOTS; i++ )
		_DestNonDrop(GetItemInSlot(i));
	oOb = GetFirstItemInInventory();
	while ( GetIsObjectValid(oOb) ) {
		_DestNonDrop(oOb);
		oOb = GetNextItemInInventory();
	}
	return;
}

