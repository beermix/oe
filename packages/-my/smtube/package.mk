PKG_NAME="smtube"
PKG_VERSION="16.7.2"
PKG_URL="https://sourceforge.net/projects/smtube/files/SMTube/16.7.2/smtube-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_AUTORECONF="no"

make_target() {
make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS -DDEBUG=0"
}