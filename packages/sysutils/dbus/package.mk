# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="dbus"
PKG_VERSION="1.13.8"
PKG_SHA256="82a89f64e1b55e459725186467770995f33cac5eb8a050b5d8cbeb338078c4f6"
PKG_LICENSE="GPL"
PKG_SITE="https://dbus.freedesktop.org/releases/dbus/?C=M;O=D"
PKG_URL="https://dbus.freedesktop.org/releases/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain expat systemd"
PKG_LONGDESC="D-Bus is a message bus, used for sending messages between applications."

PKG_CONFIGURE_OPTS_TARGET="export ac_cv_have_abstract_sockets=yes \
                           --with-sysroot=$SYSROOT_PREFIX \
                           --libexecdir=/usr/lib/dbus \
                           --disable-verbose-mode \
                           --disable-asserts \
                           --enable-checks \
                           --disable-tests \
                           --disable-ansi \
                           --disable-xml-docs \
                           --disable-doxygen-docs \
                           --enable-abstract-sockets \
                           --disable-x11-autolaunch \
                           --disable-selinux \
                           --disable-libaudit \
                           --enable-systemd \
                           --enable-inotify \
                           --without-valgrind \
                           --without-x \
                           --with-dbus-user=dbus \
                           --runstatedir=/run \
                           --with-system-socket=/run/dbus/system_bus_socket"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fstack-protector-strong -mzero-caller-saved-regs=used "
  export CXXFLAGS="$CXXFLAGS -fstack-protector-strong -mzero-caller-saved-regs=used "
}

post_makeinstall_target() {
  rm -rf $INSTALL/etc/rc.d
  rm -rf $INSTALL/usr/lib/dbus-1.0/include
}

post_install() {
  add_user dbus x 81 81 "System message bus" "/" "/bin/sh"
  add_group dbus 81
  add_group netdev 497

  echo "chmod 4750 $INSTALL/usr/lib/dbus/dbus-daemon-launch-helper" >> $FAKEROOT_SCRIPT
  echo "chown 0:81 $INSTALL/usr/lib/dbus/dbus-daemon-launch-helper" >> $FAKEROOT_SCRIPT
}
