PKG_NAME="ncurses"
PKG_VERSION="6.0-20160709"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="http://www.gnu.org/software/ncurses/"
PKG_URL="http://invisible-mirror.net/archives/ncurses/current/$PKG_NAME-$PKG_VERSION.tgz"
PKG_DEPENDS_TARGET="toolchain zlib"

PKG_SECTION="devel"
PKG_SHORTDESC="ncurses: The ncurses (new curses) library"
PKG_LONGDESC="The ncurses (new curses) library is a free software emulation of curses in System V Release 4.0, and more. It uses terminfo format, supports pads and color and multiple highlights and forms characters and function-key mapping, and has all the other SYSV-curses enhancements over BSD curses."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#TARGET_CPPFLAGS="-D_GNU_SOURCE -fPIC"

TARGET_CFLAGS="-D_GNU_SOURCE -I${includedir}"

PKG_CONFIGURE_OPTS_TARGET="\
        --enable-echo \
        --enable-const \
        --enable-overwrite \
        --enable-pc-files \
        --disable-rpath \
        --without-ada \
        --without-debug \
        --without-manpages \
        --without-profile \
        --without-progs \
        --without-tests \
        --disable-big-core \
        --disable-home-terminfo \
        --with-normal \
        --without-shared \
        --with-terminfo-dirs=/usr/share/terminfo \
        --with-default-terminfo-dir=/usr/share/terminfo \
        --enable-widec"

pre_configure_target() {
  # causes some segmentation fault's (dialog) when compiled with gcc's link time optimization.
  strip_lto
  CFLAGS="$CFLAGS -fPIC"
}

post_makeinstall_target() {
  cp misc/ncurses-config $ROOT/$TOOLCHAIN/bin
    chmod +x $ROOT/$TOOLCHAIN/bin/ncurses-config
    $SED "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $ROOT/$TOOLCHAIN/bin/ncurses-config
  ln -sf ncurses-config $ROOT/$TOOLCHAIN/bin/ncurses5-config
  ln -sf ncurses-config $ROOT/$TOOLCHAIN/bin/ncursesw5-config
  ln -sf ncurses5-config $ROOT/$TOOLCHAIN/bin/ncurses6-config

  rm -rf $INSTALL/usr/bin/ncurses*-config
}
