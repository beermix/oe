################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="vdr-plugin-femon"
PKG_VERSION="a2a2a27"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/rofafor/vdr-plugin-femon.git"
PKG_URL="https://github.com/rofafor/$PKG_NAME/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain vdr"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/tvservice"
PKG_SHORTDESC="VDR -- DVB Frontend Status Monitor plugin"
PKG_LONGDESC="vdr-femon is a plugin for VDR, the Video Disk Recorder. This plugin displays some signal information parameters of the current tuned channel on OSD. You can zap through all your channels and the plugin should be monitoring always the right frontend. The transponder and stream information are also available in advanced display modes"


PKG_LOCALE_INSTALL="yes"

make_target() {
  VDR_DIR=$(get_build_dir vdr)
  make VDRDIR=$VDR_DIR \
  STRIP=$STRIP
}
