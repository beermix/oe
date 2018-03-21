PKG_NAME="i7z"
PKG_VERSION="5023138"
PKG_URL="https://github.com/ajaiantilal/i7z/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline"
PKG_SECTION="tools"
PKG_TOOLCHAIN="manual"

make_target() {
   LIBS="-lncursesw -ltinfo" make CC="$CC" AR="$AR" CFLAGS="$CFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS" -j1
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  mkdir -p $INSTALL_DEV/usr/bin/
  cp $PKG_BUILD/i7z $INSTALL/usr/bin/
}