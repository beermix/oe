PKG_NAME="clzip"
PKG_VERSION="1.8-rc2"
PKG_URL="http://download.savannah.gnu.org/releases/lzip/clzip/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain lzo tar"

PKG_SECTION="network"




make_target() {
make 
make check
make install
}