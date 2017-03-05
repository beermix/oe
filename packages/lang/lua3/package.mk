PKG_NAME="lua"
PKG_VERSION="5.3.4"
PKG_SITE="https://www.lua.org/download.html"
PKG_URL="http://www.lua.org/ftp/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/depends"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

_MAJORVER=${PKG_VERSION%.*}

make_target() {
  cd src
  make CC="$CC" CFLAGS="$CFLAGS -fPIC" MYCFLAGS="-lreadline -lhistory -lncurses -DLUA_COMPAT_5_2" linux
}

makeinstall_target() {
  make \
  TO_LIB="liblua.a liblua.so liblua.so.$_MAJORVER liblua.so.$PKG_VERSION" \
  INSTALL_DATA='cp -d' \
  INSTALL_TOP=$SYSROOT_PREFIX/usr \
  INSTALL_MAN=$SYSROOT_PREFIX/usr/share/man/man1 \
  install

  ln -sf $SYSROOT_PREFIX/usr/bin/lua $SYSROOT_PREFIX/usr/bin/lua$_MAJORVER
  ln -sf $SYSROOT_PREFIX/usr/bin/luac $SYSROOT_PREFIX/usr/bin/luac$_MAJORVER

  mkdir -p $SYSROOT_PREFIX/usr/lib/pkgconfig
    cp -P $PKG_DIR/config/lua.pc $SYSROOT_PREFIX/usr/lib/pkgconfig/lua5.3.pc
  ln -sf $SYSROOT_PREFIX/usr/lib/pkgconfig/lua5.3.pc $SYSROOT_PREFIX/usr/lib/pkgconfig/lua.pc
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin
    cp -P $ROOT/$PKG_BUILD/src/lua $INSTALL/usr/bin
    cp -P $ROOT/$PKG_BUILD/src/luac $INSTALL/usr/bin
  ln -sf /usr/bin/lua $INSTALL/usr/bin/lua$_MAJORVER
  ln -sf /usr/bin/luac $INSTALL/usr/bin/luac$_MAJORVER

  #mkdir -p $INSTALL/usr/lib
    #cp -P $ROOT/$PKG_BUILD/src/liblua.so $INSTALL/usr/lib
    #cp -P $ROOT/$PKG_BUILD/src/liblua.so.* $INSTALL/usr/lib
}