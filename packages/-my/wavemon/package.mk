PKG_NAME="wavemon"
PKG_VERSION="a33b956"
PKG_URL="https://github.com/uoaerg/wavemon/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libstatgrab"

PKG_SECTION="network/analyzer"


configure_target() {
cd $PKG_BUILD
LIBS="-lcurses -lterminfo" ./configure
make LDFLAGS="-lcurses -lterminfo" install
}


