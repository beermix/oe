/*
 * Carlos E. Gorges <carlos@techlinux.com.br 
 *
 *  MCA IDs and desc.
 * 
*/

/* dev info */
static struct {
	unsigned short	id;		/* PCI Vendor */
	char		*desc;		/* type pointer */
} mca_mod_list[] __initdata =
{
#include "idtables/mca_mod_list.ids"
};

