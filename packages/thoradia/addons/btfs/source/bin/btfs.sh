#!/bin/sh

. /etc/profile
oe_setup_addon tools.btfs

LD_LIBRARY_PATH="$ADDON_DIR/lib" "$ADDON_DIR/bin/btfs" $@
