#!/bin/sh
#      Copyright (C) 2008-2013 Team XBMC
#      http://xbmc.org
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.

. /etc/profile

trap cleanup TERM

SAVED_ARGS="$@"

cleanup() {
  # make systemd happy by not exiting immediately but
  # wait for kodi to exit
  while killall -0 kodi.bin &>/dev/null; do
    sleep 0.5
  done
}

# clean up any stale cores. just in case
find /storage/.cache/cores -type f -delete

# clean zero-byte database files that prevent migration/startup
for file in /storage/.kodi/userdata/Database/*.db; do
  [ -s $file ] || rm -f $file
done

/usr/lib/kodi/kodi.bin $SAVED_ARGS
RET=$?

exit $RET
