PKG_NAME="texinfo"
PKG_VERSION="6.3"
PKG_URL="https://ftp.gnu.org/gnu/texinfo/texinfo-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET=""
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_AUTORECONF="no"

pre_configure_host() {
   CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-gnu-ld"
			  
			  
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"