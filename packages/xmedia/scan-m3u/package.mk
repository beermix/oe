################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="scan-m3u"
PKG_VERSION="1.3"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.alexelec.in.ua"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="xmedia/tools"
PKG_SHORTDESC="scan-m3u: scan IPTV channels for VDR"
PKG_LONGDESC="scan-m3u: scan IPTV channels for VDR."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
  export LDFLAGS="$LDFLAGS -fPIC"
}

make_target() {
  CC=$CC CFLAGS=$CFLAGS ./shc -v -r -B -f m3u_info.src
  CC=$CC CFLAGS=$CFLAGS ./shc -v -r -B -f scan-m3u.src
  CC=$CC CFLAGS=$CFLAGS ./shc -v -r -B -f scan-ttv.src
  CC=$CC CFLAGS=$CFLAGS ./shc -v -r -B -f live-ttv.src
  CC=$CC CFLAGS=$CFLAGS ./shc -v -r -B -f live-ttv-get.src
  CC=$CC CFLAGS=$CFLAGS ./shc -v -r -B -f iptvx.src
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp m3u_kill $INSTALL/usr/bin/m3u_kill
    cp m3u_info.src.x $INSTALL/usr/bin/m3u_info
    cp scan-m3u.src.x $INSTALL/usr/bin/scan-m3u
    cp scan-ttv.src.x $INSTALL/usr/bin/scan-ttv
    cp live-ttv.src.x $INSTALL/usr/bin/live-ttv
    cp live-ttv-get.src.x $INSTALL/usr/bin/live-ttv-get
    cp iptvx.src.x $INSTALL/usr/bin/iptvx
  mkdir -p $INSTALL/usr/config/acestream
    cp $PKG_DIR/config/ttv-logo.list $INSTALL/usr/config/acestream
  mkdir -p $INSTALL/usr/config/iptvx
    cp $PKG_DIR/config/playlist.conf $INSTALL/usr/config/iptvx
}
