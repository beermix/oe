# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017 Escalade
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="cups"
PKG_VERSION="2.3.0"
PKG_SHA256="7476fb18ba1cc8213505e337aecde265159c67bae668a3116fd95516fad223d8"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/apple/cups/releases"
PKG_URL="https://github.com/apple/cups/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl zlib"
PKG_LONGDESC="CUPS printing system."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--libdir=/usr/lib \
                           --disable-gssapi \
                           --disable-avahi \
                           --disable-systemd \
                           --disable-launchd \
                           --disable-unit-tests"

pre_configure_target() {
  cd ..
  rm -rf .$TARGET_NAME
}

makeinstall_target() {
  make BUILDROOT="$INSTALL/../.INSTALL_PKG"
}
