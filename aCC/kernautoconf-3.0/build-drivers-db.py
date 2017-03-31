#!/usr/bin/python
#:  build-drivers-db.py : hardware database generator from kernel sources
#
#  Copyright (c) 2000,2001,2007  Giacomo A. Catenazzi <cate@cateee.net>
#  This is free software, see GNU General Public License v2 for details


# this files is divided in following parts:
# - parse sources, find and expand detection
# - expand parameters in the output form
# - parse the kernel tree

import sys, os, os.path, re, fnmatch

import srcparser, kbuildparser, devicetables


# generic parameters. gloabals for debuging
kerneldir  = sys.argv[1]
kerdir_len = len(kerneldir)

skeleton_files = frozenset(("drivers/video/skeletonfb.c", "drivers/net/isa-skeleton.c",
        "drivers/net/pci-skeleton.c", "drivers/pci/hotplug/pcihp_skeleton.c",
        "drivers/usb/usb-skeleton.c",
   # these are #included in other files:
        "drivers/usb/host/ohci-pci.c"
)
)


logfile=sys.stdout
def log(str):
    logfile.write("build-drivers-db.py: "+str+"\n")


# --- --- --- --- #
# main parse function

post_remove = re.compile(
    r"(^\s*#\s*define\s+.*?$)|(\{\s+\})", re.MULTILINE)

def parse_source(src, filename):
    "parse .c source file"
    dep = kbuildparser.list_dep(filename)
    srcparser.unwind_include(filename)
    for table in devicetables.tables:
        for block in table.regex.findall(src):
	    block = post_remove.sub(" ", block)
#	    testfilename="drivers/char/ipmi/ipmi_si_intf.c"
#	    if filename == testfilename:
#		print filename, kbuildparser.list_dep(filename), dep
#	        print "------------------------", filename
#	        print block
#	        print "++++++++++++++++++++++++", filename
	    block = srcparser.expand_block(block, filename)
#	    if filename == testfilename:
#	        print block
#	        print "==========================", filename
	    for line in devicetables.dev_lines(block):
		devicetables.parse_line(table, table.fields, line, dep, filename)

#-----------------------


kerneldir  = sys.argv[1]
kerdir_len = len(kerneldir)

skeleton_files = frozenset(("drivers/video/skeletonfb.c", "drivers/net/isa-skeleton.c",
	"drivers/net/pci-skeleton.c", "drivers/pci/hotplug/pcihp_skeleton.c",
	"drivers/usb/usb-skeleton.c",
   # these are #included in other files:
	"drivers/usb/host/ohci-pci.c"
)
)

if len(sys.argv) > 2:
    dirs = sys.argv[2:]
else:
    dirs = ("arch", "block", "crypto", "drivers", "fs", "init",
                "ipc", "kernel", "lib", "mm", "net", "security", "sound")

for root_full, d_, files in os.walk(os.path.join(kerneldir, "include")):
    if root_full.endswith("/asm")  or  root_full.endswith("/asm-um"):
	continue
    dir = root_full[kerdir_len:]
    if dir.startswith("include/config")  or  dir.startswith("include/asm/"):
	continue
    if dir.startswith("include/asm-")  and  dir != "include/asm-generic":
	p = dir.split("/")
	if len(p) == 2:
	    dir_i = "include/asm"
	elif p[2].startswith("arch-"):
	    dir_i = "include/asm/arch" + "/".join(p[3:])
	else:
            dir_i = "include/asm/" + "/".join(p[2:])
    else:
	dir_i = dir
    # print "including dir ", dir, dir_i
    for source in files:
        filename = os.path.join(dir, source)
	filename_i = os.path.join(dir_i, source)
        f = open(os.path.join(kerneldir, filename))
        src = f.read()
        f.close()
	# print "include: ", filename, filename_i, dir_i
	srcparser.parse_header(src, kerneldir, dir_i, filename_i)

srcparser.unwind_include_all()

for subdir in dirs:
    if subdir == "arch":
        for arch in os.listdir(os.path.join(kerneldir, "arch/")):
            mk2 = os.path.join("arch/", arch)
            kbuildparser.parse_kbuild(kerneldir, mk2)
    else:
	kbuildparser.parse_kbuild(kerneldir, subdir)

    for root_full, d_, files in os.walk(os.path.join(kerneldir, subdir)):
	dir = root_full[kerdir_len:]
	phase="header2"
        for source in fnmatch.filter(files, "*.h"):
            filename = os.path.join(dir, source)
#	    print "# Doing header", filename
            f = open(os.path.join(kerneldir, filename))
            src = f.read()
            f.close()
            srcparser.parse_header(src, kerneldir, dir, filename)

    for root_full, d_, files in os.walk(os.path.join(kerneldir, subdir)):
        dir = root_full[kerdir_len:]
        for source in fnmatch.filter(files, "*.c"):
            filename = os.path.join(dir, source)
	    if filename in skeleton_files:
		continue
#	    print "# Doing", filename
            f = open(os.path.join(kerneldir, filename))
            src = f.read()
            f.close()
	    src2 = srcparser.parse_header(src, kerneldir, dir, filename)
            parse_source(src2, filename)


for d in devicetables.devices:
    (table, res, dep, filename) = d
    dep = " ".join(dep)
    log("# Checking device: %s, %s, '%s' # %s" % (table.name, res, dep, filename))
    table.writer(res, dep, filename)

