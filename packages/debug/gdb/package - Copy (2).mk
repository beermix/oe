PKG_NAME="gdb"
PKG_VERSION="8.0.1"
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/software/gdb/"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain zlib ncurses expat"
PKG_SECTION="debug"
PKG_SHORTDESC="gdb: The GNU Debugger"
PKG_LONGDESC="The purpose of a debugger such as GDB is to allow you to see what is going on ``inside'' another program while it executes--or what another program was doing at the moment it crashed."
PKG_TOOLCHAIN="autotools"

CC_FOR_BUILD="$HOST_CC"
CFLAGS_FOR_BUILD="$HOST_CFLAGS"

unpack() {
  mkdir -p $PKG_BUILD
  cp -r $(get_build_dir binutils)/gdb/* $PKG_BUILD/
}

pre_configure_target() {
  # gdb could fail on runtime if build with LTO support
    strip_lto
    strip_hard
}

PKG_CONFIGURE_OPTS_TARGET="bash_cv_have_mbstate_t=set \
                           --disable-shared \
                           --enable-static \
                           --with-auto-load-safe-path=/ \
                           --disable-nls \
                           --disable-sim \
                           --without-x \
                           --disable-tui \
                           --disable-libada \
                           --without-lzma \
                           --disable-libquadmath \
                           --disable-libquadmath-support \
                           --enable-libada \
                           --enable-libssp \
                           --disable-werror"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/gdb/python
}
