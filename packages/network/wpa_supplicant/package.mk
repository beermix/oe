# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv) -I$PKG_BUILD/src/crypto

PKG_NAME="wpa_supplicant"
#PKG_VERSION="2.8"
#PKG_SHA256="a689336a12a99151b9de5e25bfccadb88438f4f4438eb8db331cd94346fd3d96"
PKG_LICENSE="GPL"
PKG_SITE="https://w1.fi/releases/?C=M;O=D"
PKG_URL="https://w1.fi/releases/$PKG_NAME-$PKG_VERSION.tar.gz"
#PKG_VERSION="c2c6c01bb8b6fafc2074b46a53c4eab2c145ac6f"
#PKG_SHA256="8647512bab9c47b8404ee085464ebdb01c4b718244354a3e5aecf46be0a4a676"
PKG_VERSION="3b726df827c0b0bdf126b0c6c8d1fdafd451377d"
PKG_URL="https://w1.fi/cgit/hostap/snapshot/hostap-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib dbus libnl-tiny openssl"
#PKG_DEPENDS_TARGET="toolchain dbus libnl openssl"
PKG_LONGDESC="A free software implementation of an IEEE 802.11i supplicant."
PKG_TOOLCHAIN="make"
#PKG_BUILD_FLAGS="+lto-parallel"
#LTO_SUPPORT="yes"
#GOLD_SUPPORT="yes"

PKG_MAKE_OPTS_TARGET="-C wpa_supplicant V=1 LIBDIR=/usr/lib BINDIR=/usr/bin"
PKG_MAKEINSTALL_OPTS_TARGET="-C wpa_supplicant V=1 LIBDIR=/usr/lib BINDIR=/usr/bin"

configure_target() {
  export LIBS="$LIBS -lpthread -lm"
#  export CFLAGS="$CFLAGS -D_GNU_SOURCE -DCONFIG_LIBNL20 -I$SYSROOT_PREFIX/usr/include/libnl-tiny"

#  LDFLAGS="$LDFLAGS -lpthread -lm"
  export CFLAGS="$CFLAGS -D_GNU_SOURCE -DCONFIG_LIBNL20 -I$SYSROOT_PREFIX/usr/include/libnl-tiny"

  export CFLAGS="$CFLAGS -ffunction-sections -fdata-sections"
  export LDFLAGS="$LDFLAGS -Wl,--gc-sections"

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
