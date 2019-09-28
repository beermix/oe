# SPDX-License-Identifier: GPL-2.0
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv) -Dssse3=enabled

PKG_NAME="pixman"
PKG_VERSION="0.38.4"
PKG_SHA256="84abb7fa2541af24d9c3b34bf75d6ac60cc94ac4410061bbb295b66a29221550"
PKG_LICENSE="OSS"
PKG_SITE="http://www.x.org/"
PKG_URL="http://xorg.freedesktop.org/archive/individual/lib/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST="gcc:host"
PKG_DEPENDS_TARGET="toolchain util-macros libpng"
PKG_LONGDESC="Pixman is a generic library for manipulating pixel regions, contains low-level pixel manipulation routines."
PKG_TOOLCHAIN="meson"

PKG_MESON_OPTS_TARGET="-Dloongson-mmi=disabled \
			  -Dvmx=disabled \
			  -Darm-simd=disabled \
			  -Dneon=disabled \
			  -Diwmmxt=disabled \
			  -Dmips-dspr2=disabled \
			  -Dgtk=disabled \
			  -Dopenmp=disabled \
			  -Dlibpng=enabled \
			  -Dmmx=enabled \
			  -Dsse2=enabled \
			  -Dsse3=enabled"