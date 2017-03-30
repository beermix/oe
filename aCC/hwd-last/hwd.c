/*
 *	hwd.c, Sun Aug 26 00:33:28 BRT 2001
 *
 *	HardWare Detection tool
 *
 *	Copyright (C) 2001 
 *	Carlos E. Gorges <carlos@techlinux.com.br>
 *
 *      This program is free software; you can redistribute it and/or modify
 *      it under the terms of the GNU General Public License as published by
 *      the Free Software Foundation; either version 2 of the License, or
 *      (at your option) any later version.
 *
 *      This program is distributed in the hope that it will be useful,
 *      but WITHOUT ANY WARRANTY; without even the implied warranty of
 *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *      GNU General Public License for more details.
 *
 *      You should have received a copy of the GNU General Public License
 *      along with this program; if not, write to the Free Software
 *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
*/

/* 
TODO:
- PCMCIA detection/driver table
- use MODULE_DEVICE_TABLE macro
- use PCI Class
- better USB detection method
- some EISA/VL/ISA (non-PnP) cards detection \ 
	( ex. sb-like, isa scsi devs, etc )
- some PARPORT specific detection ( ex. Iomega ZIP )

Changelog:
* Sun Aug 26 2001 Carlos E. Gorges <carlos@techlinux.com.br> 
- v0.1
- PCI and ISA PnP dev. tables/detection
- ProcFS support

* Thu Aug 30 2001 Carlos E. Gorges <carlos@techlinux.com.br>
- v0.2
- USB dev. table/detection 

* Mon Sep  3 2001 Carlos E. Gorges <carlos@techlinux.com.br>
- v0.3
- PARPORT dev. detection

* Wed Sep  5 2001 Carlos E. Gorges <carlos@techlinux.com.br>
- v0.4
- rewrite [de]allocation of device struct for better [un]plugable \
  devices support
- Use usb_device->bus->busnum instead d.id/v.id in USB disconnect

* Tue Sep 18 2001 Carlos E. Gorges <carlos@techlinux.com.br>
- PSAUX(PS/2) port detection
- first SERIAL modem/mouse detection code
- show Identify

* Fri Sep 21 2001 Carlos E. Gorges <carlos@techlinux.com.br>
- v.0.5
- SERIAL modem/mouse detection
- MCA dev. detection ( tanks for David Weinehall <tao@acc.umu.se> )
*/
    
#define VERSION		"0.5"
#define PROC_ENTRY	"devmod"

#include <linux/version.h>
#include <linux/config.h>

// TODO 

#undef CONFIG_MCA
#undef CONFIG_PSMOUSE
#undef CONFIG_SERIAL
#undef PCMCIA

#include <linux/module.h>
#include <linux/init.h>

#ifdef CONFIG_PROC_FS
#include <linux/proc_fs.h>
#endif

#ifdef CONFIG_PCI
#include <linux/pci.h>
#include "pci_mod.h"
#endif

#if defined(CONFIG_ISAPNP) || defined(CONFIG_ISAPNP_MODULE)
#include <linux/isapnp.h>
#include "isapnp_mod.h"
#endif

#if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)
#include <linux/usb.h>
#include "usb_mod.h"
#endif

#if defined(CONFIG_PARPORT_PC) || defined(CONFIG_PARPORT_PC_MODULE)
#include <linux/parport.h>
#endif

#if defined(CONFIG_MCA)
#include "mca_mod.h"
#endif

MODULE_AUTHOR("Carlos E. Gorges (carlos@techlinux.com.br)");
MODULE_DESCRIPTION("Hardware Detection Tool");
MODULE_LICENSE("GPL");

#ifdef CONFIG_PROC_FS
static struct proc_dir_entry *hwd_proc_entry = NULL;
#endif

/* dev. info */
struct devices {
	struct devices *next,*prev;
	char *bus, *type, *module, *name;
	unsigned short vid,did;
	char *isavid;
	int busnum; // for USB disconnect/probe
};

static struct devices 	*lastdev = NULL,
			*firstdev = NULL;

char *hwd_buses[] = 
{ "PCI", "ISAPNP", "USB", "PARPORT", "PSAUX", "SERIAL", "MCA", "PCMCIA" };

/***************************************************************************/

static void hwd_allocdata (char* bus, char* name, char* type, 
			char* module, short vid, short did,
			char* isavid, int busnum) {

	struct devices *currdev = NULL;
	
#ifdef HWDEBUG
	printk("hwd: hwd_allocdata()\nalloc: %s,%s,%s,%s,%d,%d,%s,%d\n",
				bus,name,type,module,vid,did,
				isavid!=NULL?isavid:"NULL",busnum);
#endif	
	if(!firstdev) {
		if( ( firstdev = (struct devices *) 
			kmalloc(sizeof(struct devices), GFP_KERNEL)) != NULL )
		{
			firstdev->name=name;
			firstdev->bus=bus;
			firstdev->type=type;
			firstdev->module=module;
			firstdev->busnum=busnum;
			if(isavid!=NULL) 
				firstdev->isavid=isavid;
			else {				
				firstdev->vid=vid;
				firstdev->isavid=NULL;
			}
			firstdev->did=did;
			firstdev->next=NULL;
			firstdev->prev=NULL;
		
			lastdev=firstdev;
		}
	} else {
		if( ( currdev = (struct devices*)
			kmalloc(sizeof(struct devices), GFP_KERNEL)) != NULL )
		{
			lastdev->next=currdev;
		
			currdev->name=name;
			currdev->bus=bus;
			currdev->type=type;
			currdev->module=module;
			currdev->busnum=busnum;
			if(isavid!=NULL)
				currdev->isavid=isavid;
			else {
				currdev->vid=vid;
				currdev->isavid=NULL;
			}				
			currdev->did=did;
			currdev->next=NULL;
			currdev->prev=lastdev;
		
			lastdev=currdev;
		}
	}
}

static void hwd_deallocdata (struct devices* dev) {
		struct devices *newdev;
			
#ifdef HWDEBUG
	printk("hwd: hwd_deallocdata()\ndealloc: %s,%s,%s,%s,%d,%d,%s,%d\n",
				dev->bus,dev->name,dev->type,
				dev->module,dev->vid,dev->did,
				dev->isavid!=NULL?dev->isavid:"NULL",
				dev->busnum);
#endif	
		if( lastdev && (dev == lastdev) ) {
			newdev = lastdev->prev;
			newdev->next = NULL;
			kfree(dev);
			lastdev = newdev;
		} else if( firstdev && (dev == firstdev) ) {
			newdev = firstdev->next;
			newdev->prev = NULL;
			kfree(firstdev);
			firstdev = newdev;
		} else {
			dev->prev->next=dev->next;
			dev->next->prev=dev->prev;
			kfree(dev);
		}
}

/****************************
* PCI Probe 
*/
#ifdef CONFIG_PCI
static void hwd_pciprobe(void)
{
	unsigned int i=0;
	struct pci_dev *pcidev = NULL;

#ifdef HWDEBUG
	printk("hwd: hwd_pciprobe()\n");
#endif

      for (i=0; i < sizeof(pci_mod_list) / sizeof(pci_mod_list[0]); i++) 
	if( ( pcidev = pci_find_device( pci_mod_list[i].vendor, 
 			pci_mod_list[i].device, pcidev ) ) != NULL)

		 	   	hwd_allocdata( hwd_buses[0], 
 			   		pcidev->name[0]?pcidev->name:NULL,
					pci_mod_list[i].type,
					pci_mod_list[i].module,
					pcidev->vendor,
					pcidev->device,
					NULL,
					0 );
     if(pcidev) kfree(pcidev);
}
#endif

/****************************
* ISA PnP Probe 
*/
#if defined(CONFIG_ISAPNP) || defined(CONFIG_ISAPNP_MODULE)
static void hwd_isapnpprobe(void)
{
	unsigned int i=0;
	struct pci_bus *bus = NULL;

#ifdef HWDEBUG
	printk("hwd: hwd_isapnpprobe()\n");
#endif
      for (i=0; i < sizeof(isapnp_mod_list) / sizeof(isapnp_mod_list[0]); i++)
	   if ( (bus = isapnp_find_card(
	   ISAPNP_VENDOR(isapnp_mod_list[i].vendor[0],isapnp_mod_list[i].vendor[1],isapnp_mod_list[i].vendor[2]),
	   ISAPNP_DEVICE(isapnp_mod_list[i].device), bus )) )

		 	   	hwd_allocdata( hwd_buses[1], 
					bus->name[0]?bus->name:NULL,
					isapnp_mod_list[i].type,
					isapnp_mod_list[i].module,
					0,
					ISAPNP_DEVICE(bus->device),
					isapnp_mod_list[i].vendor,
					0 );
     if(bus) kfree(bus);
}
#endif

/****************************
* USB Probe 
*/
#if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)

static unsigned short usb_registered=0;

static void hwd_usb_disconnect(struct usb_device *udev, void *ptr)
{
	struct devices *currdev = NULL;

#ifdef HWDEBUG
	printk("hwd: usb disconnect %02x:%02x busnum: %d\n",
			udev->descriptor.idVendor,udev->descriptor.idProduct,
			udev->bus->busnum
			);
#endif
	// clean USB entry
	for(currdev=firstdev;currdev;currdev=currdev->next)
		if(( currdev->busnum == udev->bus->busnum ) &&
			( currdev->bus == hwd_buses[2] ) ) 
					hwd_deallocdata(currdev);
}

static void * hwd_usb_update(struct usb_device *udev, unsigned int ifnum, const struct usb_device_id *id)
{
	unsigned int i=0;
	unsigned short found=0;
	struct devices *currdev = NULL;

#ifdef HWDEBUG
	printk("hwd: usb update %02x:%02x busnum: %d\n",
		udev->descriptor.idVendor,udev->descriptor.idProduct,
		udev->bus->busnum);
#endif

	for(currdev=firstdev;currdev;currdev=currdev->next)
		if(currdev->busnum == udev->bus->busnum) {
// ????!!
#ifdef HWDEBUG
	printk("hwd: usb_update: device %02x:%02x busnum:%d aready added !\n",
			udev->descriptor.idVendor,udev->descriptor.idProduct,
			udev->bus->busnum);
#endif
					found++;
		}

    // update USB -> devices
    if(!found) 
	for (i=0; i < sizeof(usb_mod_list) / sizeof(usb_mod_list[0]); i++)
	   if ( ( usb_mod_list[i].vendor == udev->descriptor.idVendor ) &&
		  ( usb_mod_list[i].device == udev->descriptor.idProduct ) )

			hwd_allocdata( hwd_buses[2], 
				usb_mod_list[i].descr[0]?usb_mod_list[i].descr:NULL,
				usb_mod_list[i].type,
				usb_mod_list[i].module,
				udev->descriptor.idVendor,
				udev->descriptor.idProduct,
				NULL,
				udev->bus->busnum);

}

/* usb object to register w/ the usb subsystem */
static struct usb_driver hwd_usbdriver = {
	name:		"hwd",
	probe:		hwd_usb_update,
	disconnect:	hwd_usb_disconnect,
};

static void hwd_usbprobe(void)
{
#ifdef HWDEBUG
	printk("hwd: hwd_usbprobe()\n");
#endif
	if( usb_register(&hwd_usbdriver) >= 0) {
		usb_registered++;
#ifdef HWDEBUG
		printk("hwd: usb_register ok\n");
#endif
	} else {
		printk("kwd: usb_register failed !\n");
	}
}
#endif

/****************************
* PARPORT Probe 
*/
#if defined(CONFIG_PARPORT_PC) || defined(CONFIG_PARPORT_PC_MODULE)

#include <linux/ctype.h>

/* conversion table */
static struct {
	char *token;
	char *descr;
} hwd_parport_classes[] = {
	{ "",            "unknown" },
	{ "PRINTER",     "PRINTER" },
//	{ "MODEM",       "MODEM" },
	{ "NET",         "ETHERNET" },
	{ "HDC",       	 "HARDDISK" },
//	{ "PCMCIA",      "PCMCIA" },
	{ "MEDIA",       "MULTIMEDIA" },
	{ "FDC",         "FLOPPY" },
//	{ "PORTS",       "PORTS" },
//	{ "SCANNER",     "SCANNER" },
//	{ "DIGICAM",     "DIGICAM" },
//	{ "",            "unknown" },
//	{ "",            "unknown" },
	{ "SCSIADAPTER", "SCSI" },
};

struct hwd_parportdev_info {
	char *name,*type;
};

static char *strdup(char *str)
{
	int n = strlen(str)+1;
	char *s = kmalloc(n, GFP_KERNEL);
	if (!s) return NULL;
	return strcpy(s, str);
}

struct hwd_parportdev_info *hwd_parport_parsedata(char* data) {

	struct hwd_parportdev_info	*tmp;
	char *q,*p;
	unsigned short found_class=0;
	
	if((tmp=kmalloc(sizeof(struct hwd_parportdev_info), GFP_KERNEL)) == NULL) 
		return NULL;

	if((p=strdup(data)) == NULL) 
		return NULL;

	while (p) {
		char *sep;
		q = strchr(p, ';');
		if (q) *q = 0;
		sep = strchr(p, ':');

		if (sep) {
			char *u;
			*(sep++) = 0;
			/* Get rid of trailing blanks */
			u = sep + strlen (sep) - 1;
			while (u >= p && *u == ' ')
				*u-- = '\0';
			u = p;
			while (*u) {
				*u = toupper(*u);
				u++;
			}
			if (!strcmp(p, "CLS") || !strcmp(p, "CLASS")) {
				char *class=strdup(sep);
				unsigned int i;
				tmp->type=class;
				for (i = 0; i < sizeof(hwd_parport_classes) 
						/ sizeof(hwd_parport_classes[0]); i++ )
					if (!strcmp(hwd_parport_classes[i].token, class)) {
						tmp->type=hwd_parport_classes[i].descr;
						found_class++;
					}

			} else if (!strcmp(p, "DES") || !strcmp(p, "DESCRIPTION")) {
				tmp->name=strdup(sep);

			} else if (!found_class && (!strcmp(p, "CMD") ||
				   !strcmp(p, "COMMAND SET"))) {
				/* if it speaks printer language, it' probably a printer */
				if (strstr(sep, "PJL") || strstr(sep, "PCL"))
					 tmp->type = hwd_parport_classes[1].descr;
			}
		}
		if (q) p = q+1; else p=NULL;
	}
	return (tmp);
}

static void hwd_parportprobe(void)
{
	char *deviceid;
	struct hwd_parportdev_info *parport_dev_list;
	
#ifdef HWDEBUG
	printk("hwd: hwd_parportprobe()\n");
#endif

	if((deviceid = kmalloc (1000, GFP_KERNEL))) {
		if (parport_device_id (0, deviceid, 1000) > 2) {
		      parport_dev_list = hwd_parport_parsedata(deviceid);

				hwd_allocdata( hwd_buses[3],
					parport_dev_list->name[0]?parport_dev_list->name:NULL,
					parport_dev_list->type[0]?parport_dev_list->type:NULL,
					NULL,
					0,0,NULL,0 );
		}
	   kfree(deviceid);
	}
}
#endif

/****************************
* PSAUX Probe 
*/
#if defined(CONFIG_PSMOUSE)

extern int detect_auxiliary_port(void);

static void hwd_psauxprobe(void)
{
#ifdef HWDEBUG
	printk("hwd: hwd_psauxprobe()\n");
#endif

	if(detect_auxiliary_port()) {
#ifdef HWDEBUG
	printk("hwd: found psaux()\n");
#endif
 	   	hwd_allocdata( hwd_buses[4], 
	   		"PS/2 Mouse",
			"MOUSE",
			NULL,
			0,0,NULL, 0 );
	}
}
#endif

/****************************
* SERIAL Probe 
*/
#if defined(CONFIG_SERIAL)

struct hwd_serial_info {
	short port;
	char *ext;
};

static short find_smodem(void) {

return 1;
}

static short find_smouse(void) {

return 1;
}

static short query_smodem(short port, char *comm) {

return 1;
}

static void readmodemcap(struct hwd_serial_info *tmp)
{
	static char scap[90];

	/* V.32 (9600 BPS) */
	if(query_smodem(tmp->port, "ATV1+MS=V32,1,0,0\r")) strcat(scap, "V.32/");
	/* V.32bis (14400 BPS) */
	if(query_smodem(tmp->port, "ATV1+MS=V32B,1,0,0\r")) strcat(scap, "V.32B/");
	/* V.34 (33600 BPS) */
	if(query_smodem(tmp->port, "ATV1+MS=V34,1,0,0\r")) strcat(scap, "V.34/");
	/* V.34S (symmetrical-only) */
	if(query_smodem(tmp->port, "ATV1+MS=V34S,1,0,0\r")) strcat(scap, "V.l34S/");
	/* V.34B (extended asymmetric) */
	if(query_smodem(tmp->port, "ATV1+MS=V34B,1,0,0\r")) strcat(scap, "V.34B/");
	/* V.34BS (extended symmetric) */
	if(query_smodem(tmp->port, "ATV1+MS=V34BS,1,0,0\r")) strcat(scap, "V.34BS/");
	/* V.X2 (TX 33600BPS RX 56k) */
	if(query_smodem(tmp->port, "ATV1+MS=VX2,1,0,0\r")) strcat(scap, "V.X2/");
	/* V.90 (56k) */
	if(query_smodem(tmp->port, "ATV1+MS=V90,1,0,0\r")) strcat(scap, "V.90/");
	/* FAX Class 1 */
	if(query_smodem(tmp->port, "ATV1+FCLASS=1\r")) strcat(scap, "FAX Class 1/");
	/* FAX Class 2 */
	if(query_smodem(tmp->port, "ATV1+FCLASS=2\r")) strcat(scap, "FAX Class 2/");
	/* MNP5 */
	if(query_smodem(tmp->port, "ATV1%C1\r")) strcat(scap, "MNP5/");
	/* V.42bis */
	if(query_smodem(tmp->port, "ATV1\\N3\r") ||
			 query_smodem(tmp->port, "ATV1\\N4\r"))
					        strcat(scap, "V.42bis/");
	scap[strlen(scap)-1] = 0;
	tmp->ext=scap;
}

static void hwd_serialprobe(void)
{
  struct hwd_serial_info *sinfo = NULL;

  if((sinfo=kmalloc(sizeof(struct hwd_serial_info), GFP_KERNEL)) != NULL ) {
	if((sinfo->port=find_smodem()) != -1 ) {
		char *sdescr;	
		readmodemcap(sinfo);
		
		if( (sdescr = kmalloc(sizeof(char) * strlen(sinfo->ext) +
				 sizeof(char) * 7, GFP_KERNEL)) != NULL ) {

			strcpy(sdescr, "MODEM ");
			strcat(sdescr, sinfo->ext);
			
			hwd_allocdata( hwd_buses[5], 
 			  		sdescr,
					"MODEM",
					NULL,
					0,0,NULL,0 );
		}
	}
	kfree(sinfo);
  }
  if((sinfo=kmalloc(sizeof(struct hwd_serial_info), GFP_KERNEL)) != NULL ) {
	if((sinfo->port=find_smouse()) != -1 ) {
		char *sdescr;	
		
		if( (sdescr = kmalloc(sizeof(char) * 13, GFP_KERNEL)) != NULL ) {

			strcpy(sdescr, "Serial MOUSE");
			//strcat(sdescr, sinfo->ext);
			
			hwd_allocdata( hwd_buses[5], 
 			  		sdescr,
					"MOUSE",
					NULL,
					0,0,NULL,0 );
		}
	}
	kfree(sinfo);
  }

}
#endif

/****************************
* MCA Probe 
*/
#ifdef CONFIG_MCA
static void hwd_mcaprobe(void)
{
	unsigned int i=0;

//628b == eexpress
//627c = 3c529	
//8efc = IBM SCSI-2 Fast/Wide

	unsigned short test=0xFFFF;

#ifdef HWDEBUG
	printk("hwd: hwd_mcaprobe()\n");
#endif

      for (i=0; i < sizeof(mca_mod_list) / sizeof(mca_mod_list[0]); i++) 
	if( mca_mod_list[i].id == test)

		 	   	hwd_allocdata( hwd_buses[6], 
 			   		mca_mod_list[i].desc[0]?mca_mod_list[i].desc:NULL,
					NULL,
					NULL,
					mca_mod_list[i].id,
					0x01,
					NULL,
					0 );
}
#endif


/****************************
* PCMCIA Probe 
*/
#if defined(PCMCIA)
static void hwd_pcmciaprobe(void)
{

}
#endif

/****************************
* ProcFS
*/
#ifdef CONFIG_PROC_FS

#define FFORMAT	"%-6s\t%-9s\t%-8s\t%-8s\t%s\n"

static ssize_t kwd_read_proc(char *buf, char **start, off_t off,
				int count, int *eof, void *data)
{
	unsigned int len=0;
	struct devices *currdev = NULL;
	char ID[10];
	
	len=sprintf(buf,FFORMAT,"Bus","Identify","Type","Module","Name");
	
	for(currdev=firstdev;currdev;currdev=currdev->next) {

		if( (currdev->vid || currdev->isavid!=NULL) && currdev->did)
			if(currdev->isavid!=NULL) 	// isa pnp entry
				sprintf(ID,"%3s%04x",currdev->isavid,currdev->did);
			else
				sprintf(ID,"%04x:%04x",currdev->vid,currdev->did);
		else	
			strcpy(ID,"unknown");
	
		len += sprintf(buf+len,FFORMAT,
				currdev->bus != NULL ? currdev->bus : "unknown",
				ID,
				currdev->type != NULL ? currdev->type : "unknown",
				currdev->module != NULL ? currdev->module : "unknown",
				currdev->name != NULL ? currdev->name : "unknown"
				);
	}
	return (len);
}
#endif


/***************************************************************************/

static int __init init_hwd()
{
printk(KERN_INFO "hwd: v %s Carlos E. Gorges (carlos@techlinux.com.br) \n", VERSION);

#ifdef CONFIG_PCI
	hwd_pciprobe();
#endif
#if defined(CONFIG_ISAPNP) || defined(CONFIG_ISAPNP_MODULE)
	hwd_isapnpprobe();
#endif
#if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)
	hwd_usbprobe();
#endif
#if defined(CONFIG_PARPORT_PC) || defined(CONFIG_PARPORT_PC_MODULE)
	hwd_parportprobe();
#endif
#if defined(CONFIG_PSMOUSE)
	hwd_psauxprobe();
#endif
#if defined(CONFIG_SERIAL)
	hwd_serialprobe();
#endif
#if defined(CONFIG_MCA)
	hwd_mcaprobe();
#endif
#if defined(PCMCIA)
	hwd_pcmciaprobe();
#endif

#ifdef CONFIG_PROC_FS
	if(!(hwd_proc_entry = create_proc_entry(PROC_ENTRY, 0, &proc_root)))
 	   return -ENOMEM;

	hwd_proc_entry->read_proc=kwd_read_proc;
#endif
   return 0;
}
                

static void __exit cleanup_hwd()
{
#ifdef CONFIG_PROC_FS
	remove_proc_entry(PROC_ENTRY, &proc_root);
#endif
#if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)
	if(usb_registered) usb_deregister(&hwd_usbdriver);
#endif
}

module_init(init_hwd);
module_exit(cleanup_hwd);
