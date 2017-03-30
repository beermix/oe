/*
 * Carlos E. Gorges <carlos@techlinux.com.br 
 *
 *  PCI Vendor, Device IDs, type and module.
 * 
*/

/* Types */
char pci_mod_type[][16] =
{
#include "idtables/pci_mod_type.ids"
};

/* Modules */
char pci_mod_module[][16] =
{
#include "idtables/pci_mod_module.ids"
};

/* dev info */
static struct {
	unsigned short	vendor,		/* PCI Vendor */
			device;		/* Device ID */
	char		*type,		/* type pointer */
			*module;	/* module pointer */
} pci_mod_list[] __initdata =
{
#include "idtables/pci_mod_list.ids"
};

