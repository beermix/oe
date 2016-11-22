PKG_NAME="texinfo"
PKG_VERSION="6.3"
PKG_URL="https://ftp.gnu.org/gnu/texinfo/texinfo-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET=""
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_AUTORECONF="no"

pre_configure_host() {
  export CFLAGS="-march=native -O3 -pipe -I$ROOT/$TOOLCHAIN/include"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"
			  
			  
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"