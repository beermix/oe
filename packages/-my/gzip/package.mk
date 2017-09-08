PKG_NAME="gzip"
PKG_VERSION="1.8"
PKG_URL="http://ftpmirror.gnu.org/gzip/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain lzo tar"
PKG_SECTION="network"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="-D_GNU_SOURCE"
  export CPPFLAGS="-D_GNU_SOURCE"
}

make_target() {
make 
make check
make install
}