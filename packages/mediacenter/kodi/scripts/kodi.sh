#!/bin/sh
################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-present Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

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
