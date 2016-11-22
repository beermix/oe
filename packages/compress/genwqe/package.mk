PKG_NAME="genwqe"
PKG_VERSION="v4.0.17"
PKG_GIT_URL="https://github.com/ibm-genwqe/genwqe-user"
PKG_DEPENDS_TARGET=""
PKG_DEPENDS_HOST=""
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


make_host() {
   make lib DISABLE_LIBCXL=1
 }

makeinstall_host() {
  make LIB_INSTALL_PATH=$ROOT/$TOOLCHAIN/lib install
}

post_makeinstall_host() {
  rm $ROOT/$TOOLCHAIN/lib/libz.so
  rm $ROOT/$TOOLCHAIN/lib/libz.so.1
  rm $ROOT/$TOOLCHAIN/lib/libzADC.so
  rm $ROOT/$TOOLCHAIN/lib/libzADC.so.4
  rm $ROOT/$TOOLCHAIN/lib/libzADC.so.4.0.17
}