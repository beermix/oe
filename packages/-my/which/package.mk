PKG_NAME="which"
PKG_VERSION="2.21"
PKG_URL="http://ftpmirror.gnu.org/which/which-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="debug/tools"
PKG_SHORTDESC="htop: Htop is an ncurses based interactive process viewer for Linux."
PKG_LONGDESC="Htop is an ncurses based interactive process viewer for Linux."


PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr --enable-static --with-gnu-ld"