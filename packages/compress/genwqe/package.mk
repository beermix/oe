PKG_NAME="genwqe"
PKG_VERSION="v4.0.17"
PKG_GIT_URL="https://github.com/ibm-genwqe/genwqe-user"
PKG_DEPENDS_TARGET=""
PKG_DEPENDS_HOST=""

PKG_AUTORECONF="no"


make_host() {
   make tools DISABLE_LIBCXL=1
 }

makeinstall_host() {
  make LIB_INSTALL_PATH=$TOOLCHAIN/lib install
}

