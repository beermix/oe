# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

# libepoxy (actually) needs to be built shared, to avoid
# (EE) Failed to load /usr/lib/xorg/modules/libglamoregl.so:
# /usr/lib/xorg/modules/libglamoregl.so: undefined symbol: epoxy_eglCreateImageKHR
# in Xorg.log

PKG_NAME="libepoxy"
PKG_VERSION="1.5.3"
PKG_SHA256="002958c5528321edd53440235d3c44e71b5b1e09b9177e8daf677450b6c4433d"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/anholt/libepoxy/releases"
PKG_URL="https://github.com/anholt/libepoxy/releases/download/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain util-macros libX11 mesa"
PKG_LONGDESC="Epoxy is a library for handling OpenGL function pointer management for you."
PKG_TOOLCHAIN="meson"

PKG_MESON_OPTS_TARGET="-Ddocs=false \
			  -Dx11=true \
			  -Dglx=yes \
			  -Degl=yes"
