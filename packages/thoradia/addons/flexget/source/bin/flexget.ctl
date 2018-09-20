#!/bin/sh

. /etc/profile
oe_setup_addon service.flexget

if [ ! -f "$ADDON_HOME/config.yml" ]; then
  cp "$ADDON_DIR/config/config.yml" "$ADDON_HOME"
fi

PYTHONUSERBASE="$ADDON_DIR" \
nice -n "$fg_nice" \
python "$ADDON_DIR/bin/flexget_vanilla.py" \
       -c "$ADDON_HOME/config.yml" \
       "$@"
