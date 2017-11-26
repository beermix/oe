PKG_NAME="tree"
PKG_VERSION="1.7.0"
PKG_URL="ftp://mama.indstate.edu/linux/tree/tree-$PKG_VERSION.tgz"
#PKG_DEPENDS_TARGET="toolchain readline"
PKG_SECTION="tools"



make_target() {
  make CC="$CC" LD="$LD" XCFLAGS="$CFLAGS" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS" -j1
}