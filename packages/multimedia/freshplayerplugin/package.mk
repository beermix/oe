################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
################################################################################

PKG_NAME="freshplayerplugin"
PKG_VERSION="963f43e"
PKG_REV="1"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/01org/libva"
PKG_GIT_URL="https://github.com/i-rinat/freshplayerplugin"
PKG_DEPENDS_TARGET="toolchain intel-vaapi-driver libva libevent libvdpau libvdpau-va-gl libXcursor pango gtk+"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"

PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"


#PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"

pre_configure_target() {
  export LIBS="-lv4lconvert -lrt -lm"
}