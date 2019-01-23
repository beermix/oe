#!/bin/sh
################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-present Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

. /storage/.cache/services/acerun.conf

[ "$ACETTV_UPD" == "1" ] && /usr/bin/live-ttv novdrepg

exit 0
