################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2015 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="kodi-addon-xvdr"
PKG_VERSION="ae66610"
PKG_GIT_URL="https://github.com/pipelka/xbmc-addon-xvdr"
PKG_DEPENDS_TARGET="toolchain zlib kodi"
PKG_SECTION="mediacenter"
PKG_SHORTDESC="XVDR addon for Kodi"
PKG_LONGDESC="This addon allows Kodi PVR to connect to the VDR server."
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr/share/kodi"

export CXXFLAGS="$CXXFLAGS -DZLIB_INTERNAL=1"

pre_make_target() {
  # dont build parallel
  MAKEFLAGS=-j1
}

post_makeinstall_target() {
  $STRIP $INSTALL/usr/share/kodi/addons/pvr.vdr.xvdr/XBMC_VDR_xvdr.pvr
}
