# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="dbus-glib"
PKG_VERSION="0.110"
PKG_SHA256="7ce4760cf66c69148f6bd6c92feaabb8812dee30846b24cd0f7395c436d7e825"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://freedesktop.org/wiki/Software/dbus"
PKG_URL="https://dbus.freedesktop.org/releases/dbus-glib/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain dbus glib expat"
PKG_SECTION="devel"
PKG_SHORTDESC="dbus-glib: A message bus system"
PKG_LONGDESC="D-BUS is a message bus, used for sending messages between applications. Conceptually, it fits somewhere in between raw sockets and CORBA in terms of complexity."
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic +lto"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_have_abstract_sockets=yes \
                           ac_cv_func_posix_getpwnam_r=yes \
                           have_abstract_sockets=yes \
                           --disable-tests \
                           --disable-bash-completion \
                           --enable-asserts=no"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin/dbus-binding-tool
}
