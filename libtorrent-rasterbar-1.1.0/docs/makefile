#!/usr/bin/make -f
# Upstream Author: Arvid Norberg - Modified by: Cristian Greco
# This file has been downloaded from upstream svn and simplified in order to
# generate an html documentation suitable for offline browsing.
# This makefile assumes that you have python-docutils installed.

TARGETS = \
    index \
	udp_tracker_protocol \
	dht_rss \
	dht_store \
	client_test \
	building \
	features \
	troubleshooting \
	contributing\
	examples \
	extension_protocol \
	dht_extensions \
	dht_sec \
	python_binding \
	projects \
	utp \
	tuning \
	streaming \
	manual-ref

all: $(TARGETS:=_rst2html)

%_rst2html: %.rst
	rst2html --template=template.txt --stylesheet-path=style.css --link-stylesheet --no-toc-backlinks $? > $*.html

clean:
	@rm -f $(TARGETS:=.html)
