PKG_NAME="madplay"
PKG_VERSION="0.15.2b"
PKG_SITE="http://www.mars.org/home/rob/proj/mpeg/"
PKG_URL="ftp://ftp.mars.org/pub/mpeg/madplay-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libmad libid3tag"
PKG_SECTION="audio"

PKG_TOOLCHAIN="autotools"


PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"