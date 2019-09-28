# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="gettext-tiny"
PKG_VERSION="a76f8ad"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/sabotage-linux/gettext-tiny"
PKG_URL="https://github.com/sabotage-linux/gettext-tiny/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host"

make_host() {
  make LIBINTL=FLAVOR
}

makeinstall_host() {
  make LIBINTL=FLAVOR DESTDIR=$TOOLCHAIN prefix=/ all install
}
