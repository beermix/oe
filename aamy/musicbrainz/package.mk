PKG_NAME="musicbrainz"
PKG_VERSION="1.3.2"
PKG_URL="ftp://ftp.eu.metabrainz.org/pub/musicbrainz/picard/picard-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl"

PKG_SECTION="security"


make_target() {
make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS -DDEBUG=0"
}