################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-present Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="libcroco"
PKG_VERSION="0.6.12"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.linuxfromscratch.org/blfs/view/svn/general/libcroco.html"
PKG_URL="http://ftp.gnome.org/pub/GNOME/sources/libcroco/0.6/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libxml2 glib"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/depends"
PKG_SHORTDESC="CSS parsing library"
PKG_LONGDESC="Libcroco is a standalone CSS2 parsing and manipulation library."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_makeinstall_target() {
  mkdir -p $TOOLCHAIN/bin
    cp $SYSROOT_PREFIX/usr/bin/croco-0.6-config $TOOLCHAIN/bin
    $SED "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $SYSROOT_PREFIX/usr/bin/croco-0.6-config

  rm -rf $INSTALL/usr/bin
}
