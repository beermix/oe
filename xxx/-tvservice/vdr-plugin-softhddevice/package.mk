################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="vdr-plugin-softhddevice"
PKG_VERSION="4de20b9"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/pesintta/vdr-plugin-softhddevice"
PKG_URL="https://github.com/pesintta/vdr-plugin-softhddevice/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain vdr xcb-util-keysyms xcb-util-wm xcb-util-renderutil xcb-util-image"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/tvservice"
PKG_SHORTDESC="vdr softhddevice"
PKG_LONGDESC="vdr softhddevice"


PKG_LOCALE_INSTALL="yes"

make_target() {
  VDR_DIR=$(get_build_dir vdr)
  make VDRDIR=$VDR_DIR \
       GIT_REV=$PKG_VERSION \
       OSS=0
}
