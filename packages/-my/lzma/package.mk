PKG_NAME="lzma"
PKG_VERSION="4.65"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_URL="http://downloads.openwrt.org/sources/lzma-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET=""
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

export CC=$LOCAL_CC
pre_configure_host() {
  make -f makefile.gcc
}