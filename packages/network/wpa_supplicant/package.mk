# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv) -I$PKG_BUILD/src/crypto

PKG_NAME="wpa_supplicant"
PKG_VERSION="2.9"
PKG_SHA256="fcbdee7b4a64bea8177973299c8c824419c413ec2e3a95db63dd6a5dc3541f17"
PKG_LICENSE="GPL"
PKG_SITE="https://w1.fi/releases/?C=M;O=D"
PKG_URL="https://w1.fi/releases/$PKG_NAME-$PKG_VERSION.tar.gz"
#PKG_VERSION="c2c6c01bb8b6fafc2074b46a53c4eab2c145ac6f"
#PKG_SHA256="8647512bab9c47b8404ee085464ebdb01c4b718244354a3e5aecf46be0a4a676"
#PKG_VERSION="cb28bd5"
#PKG_URL="https://w1.fi/cgit/hostap/snapshot/hostap-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib dbus libnl-tiny openssl"
#PKG_DEPENDS_TARGET="toolchain dbus libnl openssl"
PKG_LONGDESC="A free software implementation of an IEEE 802.11i supplicant."
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET="-C wpa_supplicant V=1 LIBDIR=/usr/lib BINDIR=/usr/bin"
PKG_MAKEINSTALL_OPTS_TARGET="-C wpa_supplicant V=1 LIBDIR=/usr/lib BINDIR=/usr/bin"

configure_target() {
  export LIBS="$LIBS -lm -lpthread -lnl-tiny"

  export CFLAGS="$CFLAGS -DCONFIG_LIBNL20 -D_GNU_SOURCE -I$SYSROOT_PREFIX/usr/include/libnl-tiny"

#  export CFLAGS="$CFLAGS -ffunction-sections -fdata-sections -flto"
#  export LDFLAGS="$LDFLAGS -Wl,--gc-sections -flto -fuse-linker-plugin"

#  export CFLAGS="$CFLAGS -ffunction-sections -fdata-sections"
#  export LDFLAGS="$LDFLAGS -Wl,--gc-sections"

  cp $PKG_DIR/config/makefile.config wpa_supplicant/.config
}

post_makeinstall_target() {
  rm -r $INSTALL/usr/bin/wpa_cli

  mkdir -p $INSTALL/etc/dbus-1/system.d
    cp wpa_supplicant/dbus/dbus-wpa_supplicant.conf $INSTALL/etc/dbus-1/system.d

  mkdir -p $INSTALL/usr/lib/systemd/system
    cp wpa_supplicant/systemd/wpa_supplicant.service $INSTALL/usr/lib/systemd/system

  mkdir -p $INSTALL/usr/share/dbus-1/system-services
    cp wpa_supplicant/dbus/fi.w1.wpa_supplicant1.service $INSTALL/usr/share/dbus-1/system-services
}
