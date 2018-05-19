PKG_NAME="quilt"
PKG_VERSION="0.65"
PKG_URL="http://download.savannah.gnu.org/releases/quilt/quilt-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET=""
PKG_DEPENDS_HOST=""
PKG_SECTION="dev"
PKG_TOOLCHAIN="autotools"

pre_configure_host() {
  cd $PKG_BUILD
  rm -rf .$HOST_NAME
}