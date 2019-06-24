# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libinput"
PKG_VERSION="1.13.3"
PKG_SHA256="f3ff113023a28631d83971c059c1f3057d51a90aa3746428776f3b3462131092"
PKG_LICENSE="GPL"
PKG_SITE="https://www.freedesktop.org/software/libinput/?C=M;O=D"
PKG_URL="http://www.freedesktop.org/software/libinput/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain systemd libevdev mtdev"
PKG_LONGDESC="libinput is a library to handle input devices in Wayland compositors and to provide a generic X.Org input driver."

PKG_MESON_OPTS_TARGET="-Dlibwacom=false \
                       -Ddebug-gui=false \
                       -Dtests=false \
                       -Ddocumentation=false"
