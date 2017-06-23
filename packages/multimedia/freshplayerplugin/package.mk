################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
################################################################################

PKG_NAME="freshplayerplugin"
PKG_VERSION="84f0a53"
PKG_REV="1"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/01org/libva"
PKG_GIT_URL="https://github.com/i-rinat/freshplayerplugin"
PKG_DEPENDS_TARGET="toolchain ragel:host alsa xrandr libXrender libXcursor libdrm libevent cairo pango freetype openssl icu libva"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"

PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DWITH_LIBV4L2=0 \
			  -DWITH_JACK=0 \
			  -DWITH_PEPPERFLASH=1 \
			  -DWITH_PULSEAUDIO=0 \
			  -DCMAKE_BUILD_TYPE=Release"