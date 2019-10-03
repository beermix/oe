# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="gettext-tiny"
PKG_VERSION="c6dcdcdef801127549d3906d153c061880d25a73"
PKG_SITE="https://github.com/sabotage-linux/gettext-tiny"
PKG_URL="https://github.com/sabotage-linux/gettext-tiny/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host"

make_host() {
  make LIBINTL=NONE
}

makeinstall_host() {
  make LIBINTL=NONE DESTDIR=$TOOLCHAIN prefix=/ all install
}
