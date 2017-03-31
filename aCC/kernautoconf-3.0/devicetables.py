#!/usr/bin/python
#:  devicetables.py : device tables template for source scanning and reporting
#
#  Copyright (c) 2000,2001,2007  Giacomo A. Catenazzi <cate@cateee.net>
#  This is free software, see GNU General Public License v2 for details


# this file has contains:
# - short definition of strucure
# - registration of various tables
# - convertes for a pretty output

import sys, re
import srcparser, kbuildparser

dbfile = open("drivers-db", "w")
def add_db(string):
    dbfile.write("drv "+string+"\n")
def db_comment(string):
    dbfile.write("#"+string+"\n")

devices=[]

tables=[]
def register_table(table):
    tables.append(table)


class table:
    def __init__(self, name):
	self.name = name
    def set_struct(self, struct_name, regex_template):
	self.struct_name = struct_name
	self.regex = re.compile(regex_template % struct_name, re.DOTALL)
    def set_fields(self, field_list):
	self.fields = field_list
    def set_writer(self, writer):
	self.writer = writer

# note: it can contain an annotation before the =
array_of_drivers = r"\b%s\s+\w+\[\d*\]\s*\w*\s*=\s*\{(.*?)\}\w*;"
single_driver    = r"\b%s\s+\w+\s*\w*\s*=\s*(\{.*?\})\w*;"

# PCI , pci_device_id include/linux/mod_devicetable.h drivers/pci/pci.h

pci = table("pci")
pci.set_struct("pci_device_id", array_of_drivers)
pci.set_fields(
    ("vendor", "device", "subvendor", "subdevice", "class", "class_mask", "driver_data")
)

def pci_writer(dict, dep, filename):
    v0 = value("vendor",    dict)
    v1 = value("device",    dict)
    cl = value("class",     dict)
    if v0 == 0  and  v1 == 0  and  cl == 0:
        return
    v2 = value("subvendor", dict)
    v3 = value("subdevice", dict)
    cm = value("class_mask",dict)

    v0 = str_value(v0, -1, 4)
    v1 = str_value(v1, -1, 4)
    v2 = str_value(v2, -1, 4)
    v3 = str_value(v3, -1, 4)
    cl = str_value(cl, -1, 6).replace("......", "ffffff") ### really needed ?????????
    cm = str_value(cm, -1, 6).replace("......", "ffffff")
    v4 = mask(cl, cm, 6)
    add_db("pci '%s %s %s %s %s' %s # %s" %
        (v0, v1, v2, v3, v4, dep, filename) )

pci.set_writer(pci_writer)
register_table(pci)


# USB , usb_device_id include/linux/mod_devicetable.h drivers/usb/core/driver.c


usb = table("usb")
usb.set_struct("usb_device_id", array_of_drivers)
usb.set_fields(
  ("match_flags", "idVendor", "idProduct", "bcdDevice_lo", "bcdDevice_hi",
   "bDeviceClass", "bDeviceSubClass", "bDeviceProtocol",
   "bInterfaceClass", "bInterfaceSubClass", "bInterfaceProtocol",
   "driver_info")
)

USB_DEVICE_ID_MATCH_VENDOR       = 0x0001
USB_DEVICE_ID_MATCH_PRODUCT      = 0x0002
USB_DEVICE_ID_MATCH_DEV_LO       = 0x0004
USB_DEVICE_ID_MATCH_DEV_HI       = 0x0008
USB_DEVICE_ID_MATCH_DEV_CLASS    = 0x0010
USB_DEVICE_ID_MATCH_DEV_SUBCLASS = 0x0020
USB_DEVICE_ID_MATCH_DEV_PROTOCOL = 0x0040
USB_DEVICE_ID_MATCH_INT_CLASS    = 0x0080
USB_DEVICE_ID_MATCH_INT_SUBCLASS = 0x0100
USB_DEVICE_ID_MATCH_INT_PROTOCOL = 0x0200

def usb_writer(dict, dep, filename):
    match = value("match_flags", dict)
    if not match:
        return
    v0 = "...." ; v1 = "...."
    v2 = 0
    v3 = 65535
    v4 = ".." ; v5 = ".." ; v6 = ".."
    v7 = ".." ; v8 = ".." ; v9 = ".."
    if match & USB_DEVICE_ID_MATCH_VENDOR:
        v0 = str_value(value("idVendor", dict), -1, 4)
    if match & USB_DEVICE_ID_MATCH_PRODUCT:
        v1 = str_value(value("idProduct", dict), -1, 4)
    if match & USB_DEVICE_ID_MATCH_DEV_LO:
        v2 = value("bcdDevice_lo", dict)
    if match & USB_DEVICE_ID_MATCH_DEV_HI:
        v3 = value("bcdDevice_hi", dict)
    if match & USB_DEVICE_ID_MATCH_DEV_CLASS:
        v4 = str_value(value("bDeviceClass", dict), -1, 2)
    if match & USB_DEVICE_ID_MATCH_DEV_SUBCLASS:
        v5 = str_value(value("bDeviceSubClass", dict), -1, 2)
    if match & USB_DEVICE_ID_MATCH_DEV_PROTOCOL:
        v6 = str_value(value("bDeviceProtocol", dict), -1, 2)
    if match & USB_DEVICE_ID_MATCH_INT_CLASS:
        v7 = str_value(value("bInterfaceClass", dict), -1, 2)
    if match & USB_DEVICE_ID_MATCH_INT_SUBCLASS:
        v8 = str_value(value("bInterfaceSubClass", dict), -1, 2)
    if match & USB_DEVICE_ID_MATCH_INT_PROTOCOL:
        v9 = str_value(value("bInterfaceProtocol", dict), -1, 2)
    add_db("usb '%s %s %s%s%s %s%s%s ....' %s %s %s # %s" %
        (v0, v1, v4,v5,v6, v7,v8,v9, v2, v3, dep, filename) )

usb.set_writer(usb_writer)
register_table(usb)


# IEEE1394 ieee1394_device_id include/linux/mod_devicetable.h

ieee1394 = table("ieee1394")
ieee1394.set_struct("ieee1394_device_id", array_of_drivers)
ieee1394.set_fields(
  ("match_flags", "vendor_id", "model_id", "specifier_id", "version", "driver_data")
)

IEEE1394_MATCH_VENDOR_ID    = 0x0001
IEEE1394_MATCH_MODEL_ID     = 0x0002
IEEE1394_MATCH_SPECIFIER_ID = 0x0004
IEEE1394_MATCH_VERSION      = 0x0008

def ieee1394_writer(dict, dep, filename):
    match = value("match_flags", dict)
    if not match:
        return
    v0 = "......" ; v1 = "......"
    v2 = "......" ; v3 = "......"
    if match & IEEE1394_MATCH_VENDOR_ID:
        v0 = str_value(value("vendor_id", dict), -1, 6)
    if match & IEEE1394_MATCH_MODEL_ID:
        v1 = str_value(value("model_id", dict), -1 , 6)
    if match & IEEE1394_MATCH_SPECIFIER_ID:
        v2 = str_value(value("specifier_id", dict), -1, 6)
    if match & IEEE1394_MATCH_VERSION:
        v3 = str_value(value("version", dict), -1, 6)
    add_db( "ieee1394 '%s %s %s %s' %s # %s" %
        (v0, v1, v2, v3, dep, filename) )

ieee1394.set_writer(ieee1394_writer)
register_table(ieee1394)


# s390 CCW ccw_device_id include/linux/mod_devicetable.h


ccw = table("ccw")
ccw.set_struct("ccw_device_id", array_of_drivers)
ccw.set_fields(
  ("match_flags", "cu_type", "dev_type", "cu_model", "dev_model", "driver_info")
)

CCW_DEVICE_ID_MATCH_CU_TYPE      = 0x01
CCW_DEVICE_ID_MATCH_CU_MODEL     = 0x02
CCW_DEVICE_ID_MATCH_DEVICE_TYPE  = 0x04
CCW_DEVICE_ID_MATCH_DEVICE_MODEL = 0x08

def ccw_writer(dict, dep, filename):
    match = value("match_flags", dict)
    if not match:
        return
    v0 = "...." ; v1 = ".."
    v2 = "...." ; v3 = ".."
    if match & CCW_DEVICE_ID_MATCH_CU_TYPE:
        v0 = str_value(value("cu_type", dict), -1, 4)
    if match & CCW_DEVICE_ID_MATCH_CU_MODEL:
        v1 = str_value(value("cu_model", dict), -1, 2)
    if match & CCW_DEVICE_ID_MATCH_DEVICE_TYPE:
        v2 = str_value(value("dev_type", dict), -1, 4)
    if match & CCW_DEVICE_ID_MATCH_DEVICE_MODEL:
        v3 = str_value(value("dev_model", dict), -1, 2)
    add_db("ccw '%s %s %s %s' %s # %s" %
        (v0, v1, v2, v3, dep, filename) )

ccw.set_writer(ccw_writer)
register_table(ccw)


# s390 AP bus devices ap_device_id include/linux/mod_devicetable.h


ap = table("ap")
ap.set_struct("ap_device_id", array_of_drivers)
ap.set_fields(
  ("match_flags", "dev_type", "pad1", "pad2", "driver_info")
)

AP_DEVICE_ID_MATCH_DEVICE_TYPE = 0x01

def ap_writer(dict, dep, filename):
    match = value("match_flags", dict)
    if not match:
        return
    if match & AP_DEVICE_ID_MATCH_DEVICE_TYPE:
        v0 = str_value(value("dev_type",   dict), -1, 2)
    else:
        v0 = ".."
    add_db("ap '%s' %s # %s" %
        ( v0, dep, filename) )

ap.set_writer(ap_writer)
register_table(ap)


# ACPI , acpi_device_id include/linux/mod_devicetable.h drivers/acpi/scan.c


acpi = table("acpi")
acpi.set_struct("acpi_device_id", array_of_drivers)
acpi.set_fields(
  ("id", "driver_data")
)

def acpi_writer(dict, dep, filename):
        v0 = strings("id",   dict, '""')
        if v0 == '""':
            return
        add_db("acpi %s %s # %s" %
            (v0, dep, filename) )

acpi.set_writer(acpi_writer)
register_table(acpi)


# PNP #1, pnp_device_id include/linux/mod_devicetable.h


pnp = table("pnp")
pnp.set_struct("pnp_device_id", array_of_drivers)
pnp.set_fields(
  ("id", "driver_data")
)

def pnp_writer(dict, dep, filename):
    v0 = strings("id",   dict, '""')
    if v0 == '""':
        return
    add_db("pnp %s %s # %s" %
        (v0, dep, filename) )

pnp.set_writer(pnp_writer)
register_table(pnp)


# PNP #2, pnp_card_device_id include/linux/mod_devicetable.h drivers/pnp/card.c


pnp_card = table("pnp_card")
pnp_card.set_struct("pnp_card_device_id", array_of_drivers)
pnp_card.set_fields(
  ("id", "driver_data", "devs")
)

def pnp_card_writer(dict, dep, filename):
    v0 = strings("id",   dict, '""')
    if v0 == '""':
        return
    s = ['""',]*8
    prods = nullstring_re.sub('""', dict["devs"])
    line = dev_lines(prods)[0]
    dict_prod = parse_line(None, unwind_array, line, None, filename, ret=True)
    for i in range(8):
        s[i] = strings("n%u"%(i+1), dict_prod, '""')
    add_db("pnp_card %s %s %s %s %s %s %s %s %s %s # %s" %
        (v0, s[0], s[1], s[2], s[3], s[4], s[5], s[6], s[7], dep, filename) )

pnp_card.set_writer(pnp_card_writer)
register_table(pnp_card)


# SERIO , serio_device_id include/linux/mod_devicetable.h drivers/input/serio/serio.c


serio = table("serio")
serio.set_struct("serio_device_id", array_of_drivers)
serio.set_fields(
 ( "type", "extra", "id", "proto")
)

def serio_writer(dict, dep, filename):
    v0 = value("type", dict)
    v1 = value("proto", dict)
    if v0 == 0  and  v1 == 0:
        return
    v0 = str_value(v0, 0xff, 2)
    v1 = str_value(v1, 0xff, 2)
    v2 = str_value(value("id", dict), 0xff, 2)
    v3 = str_value(value("extra", dict), 0xff, 2)
    add_db("serio '%s %s %s %s' %s # %s" %
        (v0, v1, v2, v3, dep, filename) )

serio.set_writer(serio_writer)
register_table(serio)


# OF , of_device_id include/linux/mod_devicetable.h


of = table("of")
of.set_struct("of_device_id", array_of_drivers)
of.set_fields(
  ("name", "type", "compatible", "data")
)

def of_writer(dict, dep, filename):
    v0 = strings("name",   dict, '""')
    v1 = strings("type",   dict, '""')
    v2 = strings("compat", dict, '""')
    if v0 == '""'  and  v1 == '""'  and  v2 == '""':
        return
    add_db("of '%s %s %s' %s # %s" %
        (v0, v1, v2, dep, filename) )

of.set_writer(of_writer)
register_table(of)


# VIO , vio_device_id include/linux/mod_devicetable.h


vio = table("vio")
vio.set_struct("vio_device_id", array_of_drivers)
vio.set_fields(
  ("type", "compat")
)

def vio_writer(dict, dep, filename):
    v0 = strings("name",   dict, '""')
    v1 = strings("compat", dict, '""')
    if v0 == '""'  and  v1 == '""':
        return
    add_db("vio %s %s %s # %s" %
        (v0, v1, dep, filename) )

vio.set_writer(vio_writer)
register_table(vio)


# PCMCIA , pcmcia_device_id include/linux/mod_devicetable.h drivers/pcmcia/ds.c


pcmcia = table("pcmcia")
pcmcia.set_struct("pcmcia_device_id", array_of_drivers)
pcmcia.set_fields(
  ("match_flags", "manf_id", "card_id", "func_id", "function",
   "device_no", "prod_id_hash", "prod_id", "driver_info", "cisfile")
)

PCMCIA_DEV_ID_MATCH_MANF_ID   = 0x0001
PCMCIA_DEV_ID_MATCH_CARD_ID   = 0x0002
PCMCIA_DEV_ID_MATCH_FUNC_ID   = 0x0004
PCMCIA_DEV_ID_MATCH_FUNCTION  = 0x0008
PCMCIA_DEV_ID_MATCH_PROD_ID1  = 0x0010
PCMCIA_DEV_ID_MATCH_PROD_ID2  = 0x0020
PCMCIA_DEV_ID_MATCH_PROD_ID3  = 0x0040
PCMCIA_DEV_ID_MATCH_PROD_ID4  = 0x0080
PCMCIA_DEV_ID_MATCH_DEVICE_NO = 0x0100
PCMCIA_DEV_ID_MATCH_FAKE_CIS  = 0x0200
PCMCIA_DEV_ID_MATCH_ANONYMOUS = 0x0400

def pcmcia_writer(dict, dep, filename):
    match = value("match_flags", dict)
    if not match:
        return
    v0 = "...."  ;  v1 = "...."
    v2 = ".."  ;  v3 = ".."  ;  v4 = ".."
    if match & PCMCIA_DEV_ID_MATCH_MANF_ID:
        v0 = str_value(value("manf_id", dict), -1, 4)
    if match & PCMCIA_DEV_ID_MATCH_CARD_ID:
        v1 = str_value(value("card_id", dict), -1, 4)
    if match & PCMCIA_DEV_ID_MATCH_FUNC_ID:
        v2 = str_value(value("func_id", dict), -1, 2)
    if match & PCMCIA_DEV_ID_MATCH_FUNCTION:
        v3 = str_value(value("function", dict), -1, 2)
    if match & PCMCIA_DEV_ID_MATCH_DEVICE_NO:
        v4 = str_value(value("device_no", dict), -1, 2)
    s1 = '""' ; s2 = '""'; s3 = '""' ;  s4 = '""'
    if match & ( PCMCIA_DEV_ID_MATCH_PROD_ID1 | PCMCIA_DEV_ID_MATCH_PROD_ID2 |
                 PCMCIA_DEV_ID_MATCH_PROD_ID3 | PCMCIA_DEV_ID_MATCH_PROD_ID4 ):
        prods = nullstring_re.sub('""', dict["prod_id"])
        line = dev_lines(prods)[0]
        dict_prod = parse_line(None, unwind_array, line, None, filename, ret=True)
        if match | PCMCIA_DEV_ID_MATCH_PROD_ID1:
            s1 = strings("n1", dict_prod, '""')
        if match | PCMCIA_DEV_ID_MATCH_PROD_ID2:
            s2 = strings("n2", dict_prod, '""')
        if match | PCMCIA_DEV_ID_MATCH_PROD_ID3:
            s3 = strings("n3", dict_prod, '""')
        if match | PCMCIA_DEV_ID_MATCH_PROD_ID4:
            s4 = strings("n4", dict_prod, '""')
    add_db("pcmcia '%s %s %s %s %s' %s %s %s %s %s # %s" %
        (v0, v1, v2, v3, v4, s1, s2, s3, s4, dep, filename) )

pcmcia.set_writer(pcmcia_writer)
register_table(pcmcia)


# input, input_device_id include/linux/mod_devicetable.h drivers/input/input.c


input = table("input")
input.set_struct("input_device_id", array_of_drivers)
input.set_fields(
  ("flags", "bustype", "vendor", "product", "version",
   "evbit", "keybit", "relbit", "absbit", "mscbit", "ledbit", "sndbit", "ffbit", "swbit",
   "driver_info")
)

INPUT_DEVICE_ID_MATCH_BUS     = 1
INPUT_DEVICE_ID_MATCH_VENDOR  = 2
INPUT_DEVICE_ID_MATCH_PRODUCT = 4
INPUT_DEVICE_ID_MATCH_VERSION = 8
INPUT_DEVICE_ID_MATCH_EVBIT   = 0x0010
INPUT_DEVICE_ID_MATCH_KEYBIT  = 0x0020
INPUT_DEVICE_ID_MATCH_RELBIT  = 0x0040
INPUT_DEVICE_ID_MATCH_ABSBIT  = 0x0080
INPUT_DEVICE_ID_MATCH_MSCIT   = 0x0100
INPUT_DEVICE_ID_MATCH_LEDBIT  = 0x0200
INPUT_DEVICE_ID_MATCH_SNDBIT  = 0x0400
INPUT_DEVICE_ID_MATCH_FFBIT   = 0x0800
INPUT_DEVICE_ID_MATCH_SWBIT   = 0x1000

def input_writer(dict, dep, filename):
    match = value("flags", dict)
    if not match:
        return
    v0 = "...."  ;  v1 = "...."
    v2 = "...."  ;  v3 = "...."
    if match & INPUT_DEVICE_ID_MATCH_BUS:
        v0 = str_value(value("bustype", dict), -1, 4)
    if match & INPUT_DEVICE_ID_MATCH_VENDOR:
        v1 = str_value(value("vendor",  dict), -1, 4)
    if match & INPUT_DEVICE_ID_MATCH_PRODUCT:
        v2 = str_value(value("product", dict), -1, 4)
    if match & INPUT_DEVICE_ID_MATCH_VERSION:
        v3 = str_value(value("version", dict), -1, 4)

    b1 = 0xff
    b2 = 0xffff
    b3 = 0xff  ;  b4 = 0xff  ;  b5 = 0xff
    b6 = 0xff  ;  b7 = 0xff  ;  b8 = 0xff
    b9 = 0xff
    if match & INPUT_DEVICE_ID_MATCH_EVBIT:
        b1 = value("evbit",  dict)
    if match & INPUT_DEVICE_ID_MATCH_KEYBIT:
        b2 = value("keybit", dict)
    if match & INPUT_DEVICE_ID_MATCH_RELBIT:
        b3 = value("relbit", dict)
    if match & INPUT_DEVICE_ID_MATCH_ABSBIT:
        b4 = value("absbit", dict)
    if match & INPUT_DEVICE_ID_MATCH_MSCIT:
        b5 = value("mscbit", dict)
    if match & INPUT_DEVICE_ID_MATCH_LEDBIT:
        b6 = value("ledbit", dict)
    if match & INPUT_DEVICE_ID_MATCH_SNDBIT:
        b7 = value("sndbit", dict)
    if match & INPUT_DEVICE_ID_MATCH_FFBIT:
        b8 = value("ffbit",  dict)
    if match & INPUT_DEVICE_ID_MATCH_SWBIT:
        b9 = value("swbit",  dict)
    add_db("input '%s %s %s %s' %s %s %s %s %s %s %s %s %s %s # %s" %
        (v0, v1, v2, v3, b1, b2, b3, b4, b5, b6, b7, b8, b9, dep, filename) )

input.set_writer(input_writer)
register_table(input)


# EISA, input_device_id include/linux/mod_devicetable.h 

eisa = table("eisa")
eisa.set_struct("eisa_device_id", array_of_drivers)
eisa.set_fields(
  ("sig", "driver_data")
)

def eisa_writer(dict, dep, filename):
    v0 = strings("sig", dict, '""')
    if v0 == '""':
        return
    add_db("eisa %s %s # %s" %
        (v0, dep, filename) )

eisa.set_writer(eisa_writer)
register_table(eisa)


# parisc, parisc_device_id include/linux/mod_devicetable.h arch/parisc/kernel/drivers.c


parisc = table("parisc")
parisc.set_struct("parisc_device_id", array_of_drivers)
parisc.set_fields(
  ("class", "vendor", "device", "driver_data")
)

def parisc_writer(dict, dep, filename):
    v3 = value("sversion", dict)
    if v3 == 0:
        return
    v3 = str_value(v3, 0xffffffff, 8)
    v0 = str_value(value("hw_type", dict), 0xff, 2)
    v1 = str_value(value("hversion_rev", dict), 0xff, 2)
    v2 = str_value(value("hversion", dict), 0xffff, 4)
    add_db("parisc '%s %s %s %s' %s # %s" %
        (v0, v1, v2, v3, dep, filename) )

parisc.set_writer(parisc_writer)
register_table(parisc)


# SDIO, sdio_device_id include/linux/mod_devicetable.h drivers/mmc/core/sdio_bus.c 


sdio = table("sdio")
sdio.set_struct("sdio_device_id", array_of_drivers)
sdio.set_fields(
  ("class", "vendor", "device", "driver_data")
)

def sdio_writer(dict, dep, filename):
    v0 = value("class",  dict)
    v1 = value("vendor", dict)
    v2 = value("device", dict)
    if v0 == 0  and  v1 == 0  and  v2 == 0:
        return
    v0 = str_value(v0, -1, 2)
    v1 = str_value(v1, -1, 4)
    v2 = str_value(v2, -1, 4)
    add_db("sdio '%s %s %s' %s # %s" %
        (v0, v1, v2, dep, filename) )

sdio.set_writer(sdio_writer)
register_table(sdio)


# SBB, sdio_device_id include/linux/mod_devicetable.h drivers/ssb/main.c


sbb = table("sbb")
sbb.set_struct("ssb_device_id", array_of_drivers)
sbb.set_fields(
  ("vendor", "coreid", "revision")
)

def sbb_writer(dict, dep, filename):
    v0 = value("vendor",  dict)
    v1 = value("coreid",  dict)
    v2 = value("revision",dict)
    if v0 == 0  and  v1 == 0  and  v2 == 0:
        return
    v0 = str_value(v0, 0xffff, 4)
    v1 = str_value(v1, 0xffff, 4)
    v2 = str_value(v2, 0xff,   2)
    add_db("sbb '%s %s %s' %s # %s" %
        (v0, v1, v2, dep, filename) )

sbb.set_writer(sbb_writer)
register_table(sbb)


# virtio, sdio_device_id include/linux/mod_devicetable.h drivers/virtio/virtio.c

virtio = table("virtio")
virtio.set_struct("virtio_device_id", array_of_drivers)
virtio.set_fields(
  ("device", "vendor")
)

def virtio_writer(dict, dep, filename):
    v0 = value("device", dict)
    v1 = value("vendor", dict)
    if v0 == 0  and  v1 == 0:
        return
    v0 = str_value(v0, -1, 8)
    v1 = str_value(v1, 0xffffffff, 8)
    add_db("virtio '%s %s' %s # %s" %
        (v0, v1, dep, filename) )

virtio.set_writer(virtio_writer)
register_table(virtio)


# fs, file_system_type, include/linux/fs.h


fs = table("fs")
fs.set_struct("file_system_type", single_driver)
fs.set_fields(
  ("name", "fs_flags", "get_sb", "kill_sb", "owner", "next", "fs_supers",
   "s_lock_key", "s_umount_key", "i_lock_key", "i_mutex_key",
   "i_mutex_dir_key", "i_alloc_sem_key")
)

def fs_writer(dict, dep, filename):
    v0 = strings("name", dict, '""')
    add_db("fs %s %s # %s" % (v0, dep, filename) )

fs.set_writer(fs_writer)
register_table(fs)


# --------------------


# Unwind some arrays (i.e. in pcmcia_device_id):
unwind_array = ("n1", "n2", "n3", "n4", "n5", "n6", "n7", "n8", "n9")

# generic parameters. gloabals for debuging
kerneldir="."	# kernel main directory, stripped
filename=""	# actual filename, relative to kerneldir
phase="init"	# actual phase


logfile=sys.stdout
def log(str):
    logfile.write("LOG: %s %s\n" % (filename, phase))
    logfile.write(str)
    logfile.write("\n")


# --------------------

nullstring_re = re.compile(r"\([ \t]*void[ \t]*\*[ \t]*\)[ \t]*0")

tri_re  = re.compile(r"\(\s*\(([^\)]+)\)\s*\?([^:]*):([^\)]*)\)")
tri_re2 = re.compile(r"\(\s*([^\(\)\?]+)\?([^:]*):([^\)]*)\)")
tri_re3 = re.compile(r"\s+([-0-9A-Za-z]+)\s*\?([^:]*):\s*\(([^\)]*)\)")

def value_expand_tri(val):
    val = val.replace("(unsigned)", "")
    for r in (tri_re, tri_re2, tri_re3):
        m = r.search(val)
        while ( m != None):
	    cond, t, f = m.groups()
	    try:
	      if eval(cond):
		if t:
	            res = t
		else:
		    res = cond
	      else:
	        res = f
	    except:
		print "val:", val
		print "match:", cond, "---", t, "----", f
		raise
	    val = val[:m.start()] + res + val[m.end():]
	    m = r.search(val)
    return eval(val)
    

def value(field, dictionary):
    if dictionary.has_key(field):
	val = dictionary[field]
	if val[0] == "{"  and  val[-1] == "}":
	    val = val[1:-1].strip()
	try:
	    return eval(val)
	except SyntaxError:
	    if val[-2:] == "UL" or  val[-2:] == "ul":
		return eval(val[:-2] + "L")
	    elif val.find("?") >=0:
		return value_expand_tri(val)
	    elif val.find("=") >=0:
		log("input people smoke!, %s in '%s'" % (field, dictionary))
		return eval(val[val.find("=")+1:])
	    else:
		print "value():", field, dictionary
		print "'%s'" % val
		raise
	except NameError:
	    log("value error: expected number in field %s from %s" % (field, dictionary))
	    return -1
	except:
	    print "eval error", field, val, dictionary
	    raise
    else:
        return 0

def str_value(val, any, deep):
    ret = "." * deep
    if any < 0  and  val < 0:
	return ret
    elif val == any:
	return ret
    form = "%%%u.%ux" % (deep, deep)
    return form % val

def mask(v, m, len=6):
    ret = ""
    for i in range(len):
        if m[i] == "0":
            ret += "."
        elif m[i] == "f":
            ret += v[i]
        else:
	    print "Unknow mask", v, m, len
	    raise "KACerror"
    return ret

def chars(field, dictionary, lenght=4, default="...."):
    if dictionary.has_key(field):
        v = dictionary[field]
	l = len(v)
	if l == 2:
	    return default
	if v[0] == '"'  and  v[-1] == '"'  and  len(v) == lenght+2:
            return v[1:-1]
	else:
            print "Error on assumptions in translating chars:", field, dictionary, lenght, default, v
            raise "KACerror"
    else:
	return default

def strings(field, dictionary, default='""'):
    if dictionary.has_key(field):
        v = dictionary[field]
	if v[0] == '('  and  v[-1] == ')':
	    v = v[1:-1].strip()
	if v[0] == '{'  and  v[-1] == '}':
	    v = v[1:-1].strip()
        if v[0] == '"'  and  v[-1] == '"':
            return v
        else:
            print "Error on assumptions in translating strings:", field, dictionary, default, v
	    return default
    else:
	return default


# ---------------------------------


def dev_lines(block):
    lines = []
    level = 0
    open = 0
    params = []
    sparam = 0
    in_str = False
    for i in range(len(block)):
        c = block[i]
        if c == '"':
            in_str = not in_str
            continue
        if in_str:
            continue
        if c == "{":
            level += 1
            if level == 1:
                open = i+1
                sparam = i+1
                params = []
        elif level == 1  and  c == ",":
            params.append(block[sparam:i])
            sparam = i+1
        elif c == "}":
            level -= 1
            if level == 0:
                params.append(block[sparam:i])
                lines.append(params[:])
    return lines


field_init_re = re.compile(r"^\.([A-Za-z_][A-Za-z_0-9]*)\s*=\s*(.*)$", re.DOTALL)

def parse_line(table, fields, line, dep, filename, ret=False):
    #print "line--", filename, line
    res = {}
    nparam = 0
    for param in line:
        param = param.strip().replace("\n", " ")
        if not param:
            continue
        elif param[0] == ".":
            try:
                field, value = field_init_re.match(param).groups()
            except:
                print "parse_line(): ", filename, line, param
                raise
            res[field] = value
        else:
            try:
                res[fields[nparam]] = param
            except IndexError:
                print "Error: index error", table.name, fields, line, filename
                raise
        nparam += 1
    if res:
        if ret:
            return res
        # Maybe now we can call table.writer
        devices.append((table, res, dep, filename))

