PKG_NAME="texinfo"
PKG_VERSION="6.5"
PKG_URL="https://ftp.gnu.org/gnu/texinfo/texinfo-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="make:host"
PKG_SECTION="security"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"
 
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"