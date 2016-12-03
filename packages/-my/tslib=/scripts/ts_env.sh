#!/bin/sh
################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2015 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2015 Peter Vicman
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

. /etc/profile

if [ ! -f /storage/.config/ts/ts.conf-generic ]; then
  mkdir -p /storage/.config/ts
  cp /usr/config/ts/* /storage/.config/ts
fi

# run automatically only for ldb screen
LDB=""
if grep -iq ":dev=ldb" /proc/cmdline; then
  LDB="yes"
  # maybe 7"LVDs display
  modprobe st1232 >/dev/null 2>&1
fi

if [ -f /storage/.config/ts/ts_env.sh ]; then
  # use user supplied script
  . /storage/.config/ts/ts_env.sh
elif [ -n "$LDB" ]; then
  # find event# with command
  #  ls -l /dev/input/by-id
  # or using evtest program

  # st1232 module is always loaded so check for 3M first
  TS_DEVICE_1="3M 3M USB Touchscreen - EX II"
  TS_DEVICE_2="st1232-touchscreen"
  TS_DEVICE_CONF_1="ts.conf-udoo_15_6"
  TS_DEVICE_CONF_2="ts.conf-udoo_7"
  TS_DEVICE_CONF_GENERIC="ts.conf-generic"

  #TS_DEVICE="$TS_DEVICE_1" # use specified one, should exist ts.conf for it
  TS_DEVICE=""  # find one automatically

  #TS_DEVICE="$TS_DEVICE_1"
  #echo "device: $TS_DEVICE"

  TS_DEVICE_CONF=""
  if [ -n "$TS_DEVICE" ]; then
    TSLIB_TSDEVICE=$(echo 999 | evtest 2>&1 >/dev/null | awk -F':' -v TS_DEVICE="$TS_DEVICE" '$0 ~ TS_DEVICE {print $1}')
    TS_DEVICE_CONF="$TS_DEVICE_CONF_GENERIC"
  else
    TSLIB_TSDEVICE=$(echo 999 | evtest 2>&1 >/dev/null | awk -F':' -v TS_DEVICE="$TS_DEVICE_1" '$0 ~ TS_DEVICE {print $1}')
    if [ -n "$TSLIB_TSDEVICE" ]; then
      TS_DEVICE_CONF="$TS_DEVICE_CONF_1"
      rmmod st1232 >/dev/null 2>&1    # it's not
    else
      TSLIB_TSDEVICE=$(echo 999 | evtest 2>&1 >/dev/null | awk -F':' -v TS_DEVICE="$TS_DEVICE_2" '$0 ~ TS_DEVICE {print $1}')
      if [ -n "$TSLIB_TSDEVICE" ]; then
        TS_DEVICE_CONF="$TS_DEVICE_CONF_2"
      fi
    fi
  fi

  if [ ! -f /storage/.config/ts/ts.conf -a -n "$TS_DEVICE_CONF" ]; then
    cp "/storage/.config/ts/$TS_DEVICE_CONF" /storage/.config/ts/ts.conf
  fi

  export TSLIB_TSDEVICE="$TSLIB_TSDEVICE"
  export TSLIB_PLUGINDIR=/usr/lib/ts
  export TSLIB_CONSOLEDEVICE=none
  export TSLIB_FBDEVICE=/dev/fb0
  export TSLIB_CALIBFILE=/storage/.config/ts/pointercal
  export TSLIB_CONFFILE=/storage/.config/ts/ts.conf

  #export TSLIB_RES_X=800
  #export TSLIB_RES_Y=480
fi
