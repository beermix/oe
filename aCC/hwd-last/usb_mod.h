/*
 * Carlos E. Gorges <carlos@techlinux.com.br 
 *
 *  PCI Vendor, Device IDs, type and module.
 * 
*/

/* Types */
char usb_mod_type[][16] =
{
#include "idtables/usb_mod_type.ids"
};

/* Modules */
char usb_mod_module[][16] =
{
#include "idtables/usb_mod_module.ids"
};

static struct {
	unsigned short	vendor,		/* USB Vendor */
			device;		/* USB Device ID */
	char		*type,		/* type pointer */
			*module,	/* module pointer */
			*descr;		/* descr. */
} usb_mod_list[] __initdata =
{
#include "idtables/usb_mod_list.ids"
};

