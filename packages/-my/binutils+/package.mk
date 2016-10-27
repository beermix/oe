PKG_NAME="binutils"
PKG_VERSION="2.26"
PKG_URL="http://ftpmirror.gnu.org/gzip/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain lzo tar"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


make_target() {
make 
make check
make install
}