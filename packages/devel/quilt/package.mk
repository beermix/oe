PKG_NAME="quilt"
PKG_VERSION="0.65"
PKG_URL="http://download.savannah.gnu.org/releases/quilt/quilt-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET=""
PKG_DEPENDS_HOST=""
PKG_SECTION="dev"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_host() {
  cd $ROOT/$PKG_BUILD
}