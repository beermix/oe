# -*- coding: utf-8 -*-

from itertools import izip
import re

from jsondict import JSONDict
from util_str import strtr

instruments = JSONDict("argyll_instruments.json")

vendors = [
	"ColorVision",
	"Datacolor",
	"GretagMacbeth",
	"Hughski",
	"Image Engineering",
	"JETI",
	"Klein",
	"X-Rite",
	"Xrite"
]

def get_canonical_instrument_name(instrument_name, replacements=None,
								  inverse=False):
	replacements = replacements or {}
	if inverse:
		replacements = dict(izip(replacements.itervalues(),
								 replacements.iterkeys()))
	return strtr(remove_vendor_names(instrument_name), replacements)

def remove_vendor_names(txt):
	for vendor in vendors:
		txt = re.sub(re.compile(re.escape(vendor) + r"\s*", re.I), "", txt)
	txt = txt.strip()
	return txt
