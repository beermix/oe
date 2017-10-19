PKG_NAME="net-tools"
PKG_VERSION="1.60"
PKG_URL="https://netcologne.dl.sourceforge.net/project/net-tools/net-tools-1.60.tar.bz2"
PKG_DEPENDS_TARGET="toolchain readline openssl"
PKG_SECTION="my"

PKG_AUTORECONF="no"


make_target() {
  make SHELL='sh -x' CC="$CC" CFLAGS="$CFLAGS -DDEBUG=0" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS" -j1
}
