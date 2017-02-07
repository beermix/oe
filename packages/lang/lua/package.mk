################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="lua"
PKG_VERSION="5.3.4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="http://www.lua.org/"
PKG_URL="http://www.lua.org/ftp/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/depends"
PKG_SHORTDESC="lua: A lightweight, extensible programming language"
PKG_LONGDESC="Lua is a powerful light-weight programming language designed for extending applications. Lua is also frequently used as a general-purpose, stand-alone language."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

_MAJORVER=${PKG_VERSION%.*}

make_target() {
  make CC="$CC" LD="$LD" CFLAGS="$CFLAGS -fPIC" MYCFLAGS="-DLUA_COMPAT_5_3 -DLUA_COMPAT_5_2 -DLUA_COMPAT_5_1" linux -j1
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

  mkdir -p $INSTALL/usr/lib
    cp -P $ROOT/$PKG_BUILD/src/liblua.so $INSTALL/usr/lib
    cp -P $ROOT/$PKG_BUILD/src/liblua.so.* $INSTALL/usr/lib
}