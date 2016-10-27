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

. /usr/bin/ts_env.sh

params=$*

if [ "$1" = "service" ]; then
  # skip service parameter and daemonize
  params="-d"
else
  # started from command line
  systemctl stop ts_uinput_touch >/dev/null 2>&1
  killall ts_uinput_touch >/dev/null 2>&1
fi

echo "    touchscreen device: '$TSLIB_TSDEVICE'"

if [ -n "$TSLIB_RES_X" -a -n "$TSLIB_RES_Y" ]; then
  echo "touchscreen resolution: '${TSLIB_RES_X}x${TSLIB_RES_Y}'"
  params="-x $TSLIB_RES_X -y $TSLIB_RES_Y $params"
fi

echo "params: .$params."
if [ ! -x /storage/ts_uinput_touch ]; then
  ts_uinput_touch $params
else
  echo "Using /storage/ts_uinput_touch"
  /storage/ts_uinput_touch $params
fi
