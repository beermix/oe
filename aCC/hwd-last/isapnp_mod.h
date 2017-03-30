/*
 * Carlos E. Gorges <carlos@techlinux.com.br 
 *
 *  ISA IDs, type and module.
 * 
*/

/* Types */
char isapnp_mod_type[][16] =
{
#include "idtables/isapnp_mod_type.ids"
};

/* Modules */
char isapnp_mod_module[][16] =
{
#include "idtables/isapnp_mod_module.ids"
};

static struct {
	
	char		vendor[3];	/* ISA Vendor */
	unsigned short	device;		/* Device ID */
	char		*type,		/* type pointer */
			*module;	/* module pointer */
} isapnp_mod_list[] __initdata =
{
#include "idtables/isapnp_mod_list.ids"
};

