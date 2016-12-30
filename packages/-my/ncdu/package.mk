PKG_NAME="ncdu"
PKG_VERSION="e4f211d"
PKG_GIT_URL="git://g.blicky.net/ncdu.git"
PKG_DEPENDS_TARGET="toolchain netbsd-curses readline"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
 export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr --enable-largefile"