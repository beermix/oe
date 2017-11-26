
PKG_NAME="sthttpd"
PKG_VERSION="2.27.0"
PKG_SITE="http://opensource.dyc.edu/pub/sthttpd/"
PKG_URL="http://opensource.dyc.edu/pub/sthttpd/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="system"
PKG_SHORTDESC="sthttpd"
PKG_LONGDESC="This is a fork of Jef Poskanzer's popular thttpd server"




make_target() {
  cd $PKG_BUILD
  ./configure --prefix=/usr --srcdir=$PKG_BUILD/ --host=$TARGET_NAME
  cd src
  make
}

