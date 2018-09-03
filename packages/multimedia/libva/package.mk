# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libva"
PKG_VERSION="2.2.0"
PKG_SHA256="327181061056b49f8f9b5c5ee08fdd9832df06f4282451b218d1d0bde26a99b7"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://01.org/linuxmedia"
PKG_URL="https://github.com/intel/libva/archive/$PKG_VERSION.tar.gz"
PKG_SECTION="multimedia libX11 libXext libXfixes libdrm"
PKG_SHORTDESC="Libva is an implementation for VA-API (VIdeo Acceleration API)."
PKG_LONGDESC="Libva is an open source software library and API specification to provide access to hardware accelerated video decoding/encoding and video processing."

PKG_MESON_OPTS_TARGET="-Ddocs=false \
			  -Ddisable_drm=false \
			  -Dwith_x11=yes \
			  -Dwith_wayland=no \
			  -Denable_docs=false"
