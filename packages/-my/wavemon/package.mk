PKG_NAME="wavemon"
PKG_VERSION="a33b956"
PKG_URL="https://github.com/uoaerg/wavemon/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libstatgrab"
PKG_PRIORITY="optional"
PKG_SECTION="network/analyzer"
PKG_AUTORECONF="no"

configure_target() {
cd $ROOT/$PKG_BUILD
LIBS="-lcurses -lterminfo" ./configure
make LDFLAGS="-lcurses -lterminfo" install
}


