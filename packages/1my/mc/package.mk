PKG_NAME="mc"
PKG_VERSION="4.8.23"
PKG_SHA256="dd7f7ce74183307b0df25b5c3e60ad3293fd3d3d27d2f37dd7a10efce13dff1c"
PKG_URL="http://ftp.midnight-commander.org/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libtool:host e2fsprogs util-linux pcre fuse libssh2"
PKG_TOOLCHAIN="autotools"

#LTO_SUPPORT="yes"
#GOLD_SUPPORT="yes"


PKG_CONFIGURE_OPTS_TARGET=" \
  --datadir=/storage/.config/mc/data \
  --libexecdir=/storage/.config/mc/mclib \
  --with-homedir=/storage/.config/mc \
  --sysconfdir=/storage/.config/mc/etc \
  --with-screen=ncurses \
  --with-sysroot=$SYSROOT_PREFIX \
  --disable-aspell \
  --without-diff-viewer \
  --disable-doxygen-doc \
  --disable-doxygen-dot \
  --disable-doxygen-html \
  --with-gnu-ld \
  --without-libiconv-prefix \
  --without-libintl-prefix \
  --with-internal-edit \
  --disable-mclib \
  --with-subshell \
  --enable-vfs-extfs \
  --enable-vfs-ftp \
  --enable-vfs-sftp \
  --enable-vfs-tar \
  --without-x"

pre_configure_target() {
  export LIBS="$LIBS -lcrypto -lssl -lssh2"
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage/.config/mc/data/locale
  rm -rf $INSTALL/storage/.config/mc/data/mc/help/mc.hlp.*
  mv $INSTALL/usr/bin/mc $INSTALL/usr/bin/mc-bin
  rm -f $INSTALL/usr/bin/{mcedit,mcview}
  cp $PKG_DIR/wrapper/* $INSTALL/usr/bin
}

