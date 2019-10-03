# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="gettext-tiny"
PKG_VERSION="a76f8ad"
PKG_SITE="https://github.com/sabotage-linux/gettext-tiny"
PKG_URL="https://github.com/sabotage-linux/gettext-tiny/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host"

make_host() {
#  make LIBINTL=FLAVOR
  make CFLAGS="$HOST_CFLAGS -fPIC" LIBINTL=NONE
}

makeinstall_host() {
#  make LIBINTL=NONE DESTDIR=$TOOLCHAIN prefix=/ all install
#  make DESTDIR=$TOOLCHAIN LIBINTL=NONE install
  make LIBINTL=NONE DESTDIR=$TOOLCHAIN prefix=/ install
}
