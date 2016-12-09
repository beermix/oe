PKG_NAME="madplay"
PKG_VERSION="0.15.2b"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.mars.org/home/rob/proj/mpeg/"
PKG_URL="ftp://ftp.mars.org/pub/mpeg/madplay-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libmad libid3tag"

PKG_SECTION="audio"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"