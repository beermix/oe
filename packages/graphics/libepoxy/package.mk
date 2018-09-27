# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

# libepoxy (actually) needs to be built shared, to avoid
# (EE) Failed to load /usr/lib/xorg/modules/libglamoregl.so:
# /usr/lib/xorg/modules/libglamoregl.so: undefined symbol: epoxy_eglCreateImageKHR
# in Xorg.log

PKG_NAME="libepoxy"
PKG_VERSION="1.5.2"
PKG_VERSION="7b8a540"
#PKG_SHA256="a9562386519eb3fd7f03209f279f697a8cba520d3c155d6e253c3e138beca7d8"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/anholt/libepoxy"
PKG_URL="https://github.com/anholt/libepoxy/releases/download/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="https://github.com/anholt/libepoxy/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="graphics"
PKG_SHORTDESC="libepoxy: a library for handling OpenGL function pointer management for you."
PKG_LONGDESC="Epoxy is a library for handling OpenGL function pointer management for you."

PKG_MESON_OPTS_TARGET="-Ddocs=false \
			  -Dx11=true \
			  -Dglx=yes \
			  -Degl=yes"
