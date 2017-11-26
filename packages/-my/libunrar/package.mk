PKG_NAME="libunrar"
PKG_VERSION="4.0.7"
PKG_URL="http://www.rarlab.com/rar/unrarsrc-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl zlib"
PKG_SOURCE_DIR="unrar"
PKG_SECTION="my"


  
pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
}

TARGET_CFLAGS="$CFLAGS -fPIC -DPIC"


make_target() {
make -f makefile.unix all
}