#!/bin/bash

for pkg in `dpkg --get-selections | awk '{print $1}' | egrep -v '(dpkg|apt|mysql|mythtv)'` ; do apt-get -y --allow install --reinstall $pkg ; done
