################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
 ################################################################################  libSM

PKG_NAME="xf86-video-intel"
PKG_VERSION="7418d53"
PKG_ARCH="x86_64"
PKG_LICENSE="OSS"
PKG_SITE="https://cgit.freedesktop.org/xorg/driver/xf86-video-intel/log/"
PKG_URL="https://cgit.freedesktop.org/xorg/driver/xf86-video-intel/snapshot/$PKG_VERSION.tar.xz"
PKG_SOURCE_DIR="$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain libXcomposite libXxf86vm libXdamage util-macros systemd xorg-server libXvMC libXtst libXcursor libXScrnSaver"
PKG_SECTION="x11/driver"
PKG_SHORTDESC="xf86-video-intel: The Xorg driver for Intel video chips"
PKG_LONGDESC="The Xorg driver for Intel i810, i815, 830M, 845G, 852GM, 855GM, 865G, 915G, 915GM and 965G video chips."
# xf86-video-intel is broken enough. dont link with LTO
PKG_BUILD_FLAGS="-lto -gold"

PKG_MESON_OPTS_TARGET="-Ddefault-dri=3 \
			  -Dxvmc=false \
			  -Dvalgrind=false \
			  -Dxcursor=true \
			  -Dbacklight-helper=false \
			  -Dbacklight=false \
			  -Dtools=false \
			  -Ddebug=no \
			  -Ddefault-accel=sna \
			  -Dxorg-module-dir=$XORG_PATH_MODULES"

pre_configure_target() {
  export LC_ALL=en_US.UTF-8

  # meson needs a host compiler and it's detected through the environment. meh.
  export CC="$HOST_CC"
  export CXX="$HOST_CXX"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/polkit-1
}
