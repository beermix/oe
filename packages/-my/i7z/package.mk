PKG_NAME="i7z"
PKG_VERSION="5023138"
PKG_GIT_URL="https://github.com/ajaiantilal/i7z"
PKG_DEPENDS_TARGET="toolchain readline"
PKG_SECTION="tools"


make_target() {
  LIBS="$LIBS -lncursesw -ltinfo" make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS" -j1
}

pre_configure_target() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fno-strict-aliasing||g"`
  export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-fno-strict-aliasing||g"`
}