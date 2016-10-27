PKG_NAME="lzlib"
PKG_VERSION="1.8-rc3"
PKG_URL="http://download.savannah.gnu.org/releases/lzip/lzlib/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain lzo tar"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


make_target() {
make 
make check
make install
}