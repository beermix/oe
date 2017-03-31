#!/usr/bin/python
#:  kbuildparser.py : parser of kbuild infrastructure
#
#  Copyright (c) 2007  Giacomo A. Catenazzi <cate@cateee.net>
#  This is free software, see GNU General Public License v2 for details

# parse kbuild files (Makefiles) and extract the file dependencies


import sys, os, os.path, re

logfile=sys.stdout
def log(str):
    logfile.write("kbuildparser: "+str+"\n")

# --- --- --- --- #
# parse Makefile for file dependencies

# dictionary of CONFIG_ dependencies on files (from Makefile)
# format: filename.c: (CONFIG_FOO, CONFIG_BAR)
dependencies = {}
# format: filename.c: (virtual-filename-objs.c, ...)
dep_aliases = {}

kbuild_normalize = re.compile(r"(#.*$|\\[ \t]*\n)", re.MULTILINE)
kbuild_includes = re.compile(r"^include\s+\$\{srctree\}/(.*)$", re.MULTILINE)
ignore_rules_set = frozenset(
    ("init", "drivers", "net", "libs", "core", "obj", "lib",
     "cflags", "cpuflags"))

def parse_kbuild(kerneldir, subdir, deps=None):
    filename=subdir
    mk = os.path.join(kerneldir, subdir, "Makefile")
    if not os.path.isfile(mk):
	mk2 = mk
	mk = os.path.join(kerneldir, subdir, "Kbuild")
	if not os.path.isfile(mk):
	    log("parse_kbuild: could not find file: %s, recursing" % mk2)
	    if deps == None:
                for dir in os.listdir(os.path.join(kerneldir, subdir)):
		    if os.path.isdir(os.path.join(kerneldir, subdir, dir)):
                        parse_kbuild(kerneldir, os.path.join(subdir, dir))
	    return
    f = open(mk)
    src = kbuild_normalize.sub(" ", f.read())
    f.close()
    for incl in kbuild_includes.findall(src):
	mk2 = os.path.join(kerneldir, incl)
	if not os.path.isfile(mk2):
	    log("parse_kbuild: could not find included file (from %s): %s" % (mk, mk2))
	    return
	f = open(mk2)
	src += " " + kbuild_normalize.sub(" ", f.read())
	f.close()
    if deps == None:
	deps = set()
    if subdir.startswith("arch/")  and  subdir.count("/") == 1  and  deps == None:
	base_subdir = ""
    else:
	base_subdir = subdir
    parse_kbuild_lines(kerneldir, base_subdir, deps, src)


def parse_kbuild_alias(kerneldir, subdir, deps, rule, dep, files):
   for f in files.split():
	fn = os.path.join(subdir, f)
	if f[-2:] == ".o":
	    fc = fn[:-2]+".c"
	    virt = [ os.path.join(subdir, rule+".c") ]
            if dep_aliases.has_key(fc):
                virt.extend(dep_aliases[fc])
            dep_aliases[fc] = virt
	elif f[-1] == "/":
	    parse_kbuild(kerneldir, fn, dep)

kbuild_rules = re.compile(r"^([A-Za-z0-9-_]+)-([^+=: \t\n]+)\s*[:+]?=[ \t]*(.*)$", re.MULTILINE)

def parse_kbuild_lines(kerneldir, subdir, deps, src):
    for (rule, dep, files) in kbuild_rules.findall(src):
	d = deps.copy()
	if not files:
	    pass
	# rule-$(dep): file.o
        if dep in ("y", "m"):
            pass
        elif dep[:9] == '$(CONFIG_' and dep[-1] == ')':
            d.add(dep[2:-1])
	elif dep == "objs":
	    parse_kbuild_alias(kerneldir, subdir, deps, rule, dep, files)
	    continue
        else:
            log("parse_kbuild: unknow dep in %s: '%s'" % (subdir, dep))
            continue

        for f in files.split():
            fn = os.path.join(subdir, f)
            if f[-1] == "/":
                parse_kbuild(kerneldir, fn, d)
            elif f[-2:] == ".o":
                fc = fn[:-2]+".c"
		v = d.copy()
                if dependencies.has_key(fc):
		    v.update(dependencies[fc])
                dependencies[fc] = v
            else:
                log("parse_kbuild: unknow 'make target' in %s: '%s'" % (subdir, f))

        if not rule in ignore_rules_set:
	    parse_kbuild_alias(kerneldir, subdir, deps, rule, d, files)


def list_dep_rec(fn, dep, passed):
    if dep == None:
	dep = set()
    if dependencies.has_key(fn):
        dep.update(dependencies[fn])
    if dep_aliases.has_key(fn):
	for alias in dep_aliases[fn]:
	    if alias in passed:
		continue
	    else:
		passed.add(alias)
	    dep.update(list_dep_rec(alias, dep, passed))
    return dep


def list_dep(fn):
    dep = set()
    passed = set([fn])
    list_dep_rec(fn, dep, passed)
    if not dep:
        return set( ["CONFIG__UNKNOW__"] )
    return dep

