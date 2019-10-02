# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="keyutils"
PKG_VERSION="1.6.1"
PKG_SHA256="3c71dcfc6900d07b02f4e061d8fb218a4ae6519c1d283d6a57b8e27718e2f557"
PKG_LICENSE="GPL"
PKG_SITE="https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git"
PKG_URL="https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/snapshot/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Keyutils is a set of utilities for managing the key retention facility in the kernel."
PKG_BUILD_FLAGS="+pic"

PKG_MAKE_OPTS_TARGET="NO_ARLIB=0 NO_SOLIB=1 BINDIR=/usr/bin SBINDIR=/usr/sbin LIBDIR=/usr/lib USRLIBDIR=/usr/lib"
PKG_MAKEINSTALL_OPTS_TARGET="$PKG_MAKE_OPTS_TARGET"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share
  rmdir $INSTALL/etc/request-key.d
  ln -sf /storage/.config/request-key.d $INSTALL/etc/request-key.d
}
