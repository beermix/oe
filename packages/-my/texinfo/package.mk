PKG_NAME="texinfo"
PKG_VERSION="6.3"
PKG_URL="https://ftp.gnu.org/gnu/texinfo/texinfo-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET=""
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_AUTORECONF="no"


PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-gnu-ld"
			  
			  
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"