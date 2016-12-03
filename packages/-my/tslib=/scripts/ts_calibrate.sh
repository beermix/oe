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

echo "touchscreen device: $TSLIB_TSDEVICE"

if [ "$1" = "service" ]; then
  # recalibrate from service if required
  SETTINGS_XML="$HOME/.kodi/userdata/addon_data/plugin.program.ts_calibration/settings.xml"
  if [ -f "$SETTINGS_XML" ]; then
    mkdir -p /var/config
    cat "$SETTINGS_XML" | awk -F\" '{print $2"=\""$4"\""}' | sed '/^=/d' > /var/config/ts_calibration_addon.conf
    . /var/config/ts_calibration_addon.conf

    if [ "$TS_RECALIBRATE" = "true" ]; then
      sed -i 's|id="TS_RECALIBRATE"[ ]*value="true"|id="TS_RECALIBRATE" value="false"|g' "$SETTINGS_XML"
      touch /storage/.config/ts/recalibrate
    fi
  fi

  if [ -f /storage/.config/ts/recalibrate ]; then
    echo "recalibrating..."
    rm -f /storage/.config/ts/recalibrate
    ts_calibrate
  fi
else
  echo "Stopping Kodi and touchscreen daemon..."
  systemctl stop kodi
  systemctl stop ts_uinput_touch

  while pidof kodi.bin >/dev/null; do
    sleep 0.3
  done

  killall ts_uinput_touch >/dev/null 2>&1

  ts_calibrate

  # restart both if argument was set
  if [ "$1" = "run" ]; then
    echo "Starting touchscreen daemon and Kodi..."
    systemctl start ts_uinput_touch
    systemctl start kodi
  fi
fi
