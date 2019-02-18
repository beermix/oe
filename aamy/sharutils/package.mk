PKG_NAME="sharutils"
PKG_VERSION="4.15.2"
PKG_URL="ftp://ftp.gnu.org/gnu/sharutils/sharutils-4.15.2.tar.xz"
PKG_DEPENDS_HOST="gettext:host binutils:host"

PKG_SECTION="debug/tools"
PKG_SHORTDESC="htop: Htop is an ncurses based interactive process viewer for Linux."
PKG_LONGDESC="Htop is an ncurses based interactive process viewer for Linux."


PKG_CONFIGURE_OPTS_HOST="--with-gnu-ld --disable-nls --enable-static"