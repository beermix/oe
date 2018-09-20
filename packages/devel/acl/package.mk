PKG_NAME="acl"
PKG_VERSION="2.2.53"
PKG_SHA256="06be9865c6f418d851ff4494e12406568353b891ffe1f596b34693c387af26c7"
PKG_URL="https://mirrors.up.pt/pub/nongnu/acl/acl-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain attr"
PKG_DEPENDS_HOST="toolchain attr:host"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"