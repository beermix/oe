PKG_NAME="libtorrent"
PKG_VERSION="0.13.7"
PKG_SHA256="86b4b1753385aaddf9e59ad94f1292eee5102139eb57520e84d1af2f04693708"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/rakshasa/libtorrent"
PKG_URL="https://github.com/rakshasa/$PKG_NAME/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl zlib"
PKG_LONGDESC="libtorrent"

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-debug \
                           --disable-shared"
