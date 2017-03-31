#
# This modules vaguely simulate a C preprocessor
#
# It is not a good preprocessor, but it is enough for the
# most uses: Usually preprocessors hacks are done for code
# and not data.
#
# Copyright (c) 2007 by Giacomo A. Catenazzi <cate@cateee.net>
# This is free software, distributed with the GPL version 2


# the file is divided in:
# - parse haders for #define
# - parse (detection) block, and expand macros


import sys, re, os.path


# global dictionaries

# filename -> set(filename..) of direct includes
includes_direct = {}
# filename -> frozenset(filename..) of includes (recursive)
includes_unwind = {}
# token -> [ filename -> expanded , .. ]
defines_pln = {}
# token -> [ filename -> (args, expanded) , .. ]
defines_fnc = {}


# specia cases:
print "with special cases"
includes_direct["drivers/char/synclink_gt.c"] = set(["include/linux/synclink.h"])
includes_unwind["drivers/char/synclink_gt.c"] = set([])

logfile=sys.stdout
def log(str):
    logfile.write("LOG: " + str + "\n")


# Comments and join lines
comment_re = re.compile(
    r"(/\*.*?\*/|//.*?$|\\\n)", re.DOTALL | re.MULTILINE)
# Find #defines without arguments (ignore empty define: we don't care)
define_re = re.compile(r"^\s*#\s*define\s+([A-Za-z_0-9]+)[ \t]+(.+)$",
        re.MULTILINE)
# Find #defines with arguments
define_fn_re = re.compile(r"^\s*#\s*define\s+([A-Za-z_0-9]+)\(([^)]*)\)[ \t]+(.+)$",
        re.MULTILINE)
# includes directive
include_re = re.compile(r'^\s*#\s*include\s+(.*)$', re.MULTILINE)


def parse_header(src, kerneldir, dir, filename):
    "parse a single header file for #define, without recurse into other includes"
    src = comment_re.sub(" ", src)
    if not includes_direct.has_key(filename):
	includes_direct[filename] = set()
	includes_unwind[filename] = set([filename])
    for incl in include_re.findall(src):
	incl = incl.strip()
	if incl[0] == '"'  and  incl[-1] == '"':
	    if not incl.endswith('.h"'):
		fn = os.path.join(kerneldir, dir, incl[1:-1])
		if not os.path.isfile(fn):
		    log("preprocessor: parse_header(): unknow c-include in %s: %s" % (
			filename, incl))
		    continue
		f = open(fn)
		src2 = f.read()
		f.close()
		src2 = src.replace(incl, "$"+incl[1:-1]+"$\n"+src2) 
		return parse_header(src2, kerneldir, dir, filename)
	    else:
		includes_direct[filename].add(os.path.join(dir, incl[1:-1]))
	elif incl[0] == '<'  and  incl[-1] == '>':
	    includes_direct[filename].add(os.path.join("include", incl[1:-1]))
	elif incl[0] == '$'  and  incl[-1] == '$':
	    # it is a non .h recursive include (set called, from above
	    continue
	else:
	    pass
	    log("preprocessor: parse_header(): unknow include in %s: '%s'" % (
		filename, incl))
    for id, defs in define_re.findall(src):
	if not defines_pln.has_key(id):
	    defines_pln[id] = {}
	defines_pln[id][filename] = defs.strip()
    for id, args, defs in define_fn_re.findall(src):
	if not defines_fnc.has_key(id):
	    defines_fnc[id] = {}
        defines_fnc[id][filename] = (args, defs.strip())
    return src

def unwind_include_rec(filename, known):
    incls = set([filename])
    if includes_direct.has_key(filename):
	incls.update(includes_direct[filename])
        known.update(includes_unwind[filename])
    for incl in incls.difference(known):
	known.add(incl)
	known.update(unwind_include_rec(incl, known))
    return known

def unwind_include(filename):
    known = set()
    res = unwind_include_rec(filename, known)
    includes_unwind[filename].update(res)

def unwind_include_all():
    for header in includes_direct.iterkeys():
	unwind_include(header)


def search_define(token, filename, defines):
    if not defines.has_key(token):
        return None
    defs = defines[token]
    for header in defs.iterkeys():
	if header == filename:
	    return defs[header]
	if header in includes_unwind[filename]:
	    return defs[header]
    return None

    
# ---------------


def expand_block(block, filename):
    ret = ""
    lbm = len(block)-1
    i = -1
    instr = False
    start_token = -1
    while (i < lbm):
	i += 1
	c = block[i]
	if c == '"':
	    instr = not instr
	    ret += c
	    continue
	if instr:
	    if c == '\\':
		ret += block[i:i+2]
		i += 1
	    else:
		ret += c
	    continue 
	if c.isalnum()  or  c == "_":
	    if start_token < 0:
		start_token = i
	elif start_token >= 0:
	    if block[start_token].isdigit():
		ret += expand_number(block[start_token:i])
	    else:
		idx, ret_add = expand_token(block, start_token, i, filename)
		ret += ret_add
		if idx > i:
		    i = idx # the next char after token and parenthesis is already parsed
		    c = ""
	    # now parse this character
	    start_token = -1
	    ret += c
	else:
	    ret += c
    return ret


def expand_number(str):
    return str.rstrip("uUlL")


def expand_token(block, start, end, filename):
    tok = block[start:end]
    df = search_define(tok, filename, defines_fnc)
    if df:
	pstart = 0
	pend = len(block)-1
        level = 0
	instr = False
	args = []
	i = end-1
	while(i<pend):	
	    i += 1		# end should be at last chat of token
	    c = block[i]
	    if c.isspace():
		continue
	    elif c == '"'  and  pstart > 0:
		instr = not instr
		continue
            elif instr:
                if c == '\\':
                    i += 1
                continue
	    elif c == "(":
		if pstart == 0:
		    pstart = i+1
		level += 1
		continue
            elif pstart == 0:
                break
	    elif c == ")":
		level -= 1
		if level == 0:
		    args.append(block[pstart:i].strip())
		    pend = i
		    break
		else:
		    continue
	    elif c == ","  and  level == 1:
		args.append(block[pstart:i].strip())
		pstart = i+1
#	    else:
#		print "unkow"
	if pstart:
	    return (pend, expand_macro(tok, df, args, filename) + " ")
    df = search_define(tok, filename, defines_pln)
    if df:
	return (0, expand_block(df+" ", filename) + " ")
    return (0, tok)


concatenate_re = re.compile(r"\s*##\s*")

def expand_macro(tok, def_fnc, args, filename):
    def_args, defs = def_fnc
    defs = defs[:]
    def_args = def_args.split(",")
    if len(def_args) != len(args):
	# I don't hope to parse debugging or "..." macros
	print "Wrong lenghts", len(def_args), len(args), def_args, args, tok, def_fnc
	raise "WrongLen"
    
    for i in range(len(args)):
	da = def_args[i].strip()
	defs = re.sub(r"[^#]#" +da+ r"\b", '"'+args[i]+'"', defs)
	defs = re.sub(r"\b"    +da+ r"\b",     args[i],     defs)
    defs = concatenate_re.sub("", defs) + " "
    return expand_block(defs, filename)

# -------------------


def parse_source(src, filename):
    "parse .c source file"
    dep = list_dep(filename)
    preprocessor.unwind_include(filename)
    for t in tables_block:
        regex = tables_block_re[t[0]]
        for block in regex.findall(src):
            block = post_remove.sub(" ", block)
#           testfilename="drivers/char/ipmi/ipmi_si_intf.c"
#           if filename == testfilename:
#               print filename, list_dep(filename), dep
#               print "------------------------", filename
#               print block
#               print "++++++++++++++++++++++++", filename
            block = preprocessor.expand_block(block, filename)
#           if filename == testfilename:
#               print block
#               print "==========================", filename
                #print preprocess[1]["MPI_MANUFACTPAGE_DEVICEID_FC909"]
                #print preprocess[0]["drivers/ieee1394/ieee1394_hotplug.h"]
                #print preprocess[2]["AVC_UNIT_SPEC_ID_ENTRY"]
                #raise "STOOOOPP!!!"
            for line in dev_lines(block):
                parse_line(t, line, dep, filename)

    for t in tables_line:
	###  join with above ..............
        regex = tables_line_re[t[0]]
        for block in regex.findall(src):
            block = post_remove.sub(" ", block)
            block = preprocessor.expand_block(block, filename)
            line = dev_lines(block)[0]
            parse_line(t, line, dep, filename)
	


