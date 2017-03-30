CC=gcc
MODCFLAGS := -O2 -fomit-frame-pointer -Wall -DMODULE -D__KERNEL__ -DLINUX -I/usr/src/linux/include

hwd.o: hwd.c /usr/include/linux/version.h idtables/pci_mod_list.ids idtables/isapnp_mod_list.ids idtables/usb_mod_list.ids idtables/mca_mod_list.ids
	$(CC) $(MODCFLAGS) -c hwd.c

debug: hwd.c /usr/include/linux/version.h idtables/pci_mod_list.ids idtables/isapnp_mod_list.ids idtables/usb_mod_list.ids idtables/mca_mod_list.ids
	$(CC) -ggdb -DHWDEBUG -DMODULE -D__KERNEL__ -DLINUX  -I/usr/src/linux/include -c hwd.c

clean:
	rm -f hwd.o

cleanids:
	rm -f idtables/*.ids

idtables/pci_mod_list.ids:
		( cd idtables/datasrc; ./gen-pcimodlist )

idtables/isapnp_mod_list.ids:
		( cd idtables/datasrc; ./gen-isapnpmodlist )

idtables/usb_mod_list.ids:
		( cd idtables/datasrc ; ./gen-usbmodlist )

idtables/mca_mod_list.ids:
		( cd idtables/datasrc ; ./gen-mcamodlist )

dep:
	modprobe isa-pnp
	modprobe usb-uhci
	modprobe parport_pc

on: hwd.o
	insmod hwd.o

off:
	rmmod hwd
