#include "inc_collectboxes"

void main() {
	if ( INVENTORY_DISTURB_TYPE_ADDED == GetInventoryDisturbType() )
		OnCollectboxDisturb(GetLastDisturbed(), GetInventoryDisturbItem());
}
