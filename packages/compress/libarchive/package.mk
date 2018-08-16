PKG_NAME="libarchive"
PKG_VERSION="3.3.2"
PKG_SHA256="ed2dbd6954792b2c054ccf8ec4b330a54b85904a80cef477a1c74643ddafa0ce"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libarchive/libarchive/releases"
PKG_URL="https://www.libarchive.org/downloads/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain lzo:host lz4:host xz:host bzip2:host expat"
PKG_DEPENDS_TARGET="toolchain lzo lz4 bzip2"
PKG_SECTION="compress"
PKG_SHORTDESC="libarchive data compressor/decompressor"
PKG_TOOLCHAIN="cmake-make"
PKG_CMAKE_OPTS_TARGET="-DENABLE_SHARED=0 -DENABLE_STATIC=1 -DCMAKE_POSITION_INDEPENDENT_CODE=1 -DENABLE_EXPAT=0 -DENABLE_ICONV=0 -DENABLE_LIBXML2=0 -DENABLE_LZO=1 -DENABLE_TEST=0 -DENABLE_COVERAGE=0"

post_makeinstall_target() {
  rm -rf $INSTALL
}
