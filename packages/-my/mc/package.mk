PKG_NAME="mc"
PKG_VERSION="83127bd"
PKG_GIT_URL="git://github.com/MidnightCommander/mc.git"
PKG_DEPENDS_TARGET="toolchain libtool:host gettext:host e2fsprogs util-linux glib pcre fuse libssh2 libevent expat slang"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
  #export LIBS="$LIBS -lssh2 -lcrypto"
  #export MAKEFLAGS="-j1"
  #export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/ncurses"
  export LDFLAGS="$(echo $LDFLAGS | sed -e "s|-Wl,--as-needed||")"
}

PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/storage/.config \
                           --datadir=/storage/.config \
                           --libdir=/storage/.config \
                           --libexecdir=/storage/.config \
                           --sharedstatedir=/storage/.config \
                           --localstatedir=/storage/.config \
                           --includedir=/storage/.config \
                           --oldincludedir=/storage/.config \
                           --datarootdir=/storage/.config \
                           --infodir=/storage/.config \     
                           --localedir=/storage/.config \
                           --disable-doxygen-doc \
                           --disable-doxygen-rtf \
                           --disable-doxygen-xml \
                           --disable-doxygen-chm \
                           --disable-doxygen-chi \
                           --disable-doxygen-dot \
                           --disable-doxygen-html \
                           --without-internal-edit \
                           --disable-silent-rules \
                           --enable-background \
                           --enable-charset \
                           --enable-largefile \
                           --enable-vfs-sftp \
                           --with-internal-edit \
                           --with-mmap \
                           --with-subshell \
                           --without-gpm-mouse \
                           --without-included-gettext \
                           --without-x
                           --without-gpm-mouse \
                           --with-screen=slang \
                           --with-x \
                           --enable-vfs-sftp \
                           --enable-vfs-tar \
                           --enable-vfs-extfs \
                           --enable-vfs-cpio \
                           --without-vfs-smb"