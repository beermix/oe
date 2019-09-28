# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libinput"
PKG_VERSION="1.14.1"
PKG_SHA256="e333a3242835c019ca37d2cef8b51a87d3138eb47444119c0153dc7a8656ee70"
PKG_LICENSE="GPL"
PKG_SITE="https://www.freedesktop.org/software/libinput/?C=M;O=D"
PKG_URL="http://www.freedesktop.org/software/libinput/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain systemd libevdev mtdev"
PKG_LONGDESC="libinput is a library to handle input devices in Wayland compositors and to provide a generic X.Org input driver."

PKG_MESON_OPTS_TARGET="-Dlibwacom=false \
                       -Ddebug-gui=false \
                       -Dtests=false \
                       -Ddocumentation=false"
