PKG_NAME="mc"
PKG_VERSION="4.8.19"
PKG_URL="http://ftp.midnight-commander.org/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libtool:host gettext:host e2fsprogs util-linux glib pcre fuse libssh2 libevent expat ncurses"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LIBS="$LIBS -lssh2 -lmbedcrypto"
  export MAKEFLAGS="-j1"
}

PKG_CONFIGURE_OPTS_TARGET="fu_cv_sys_stat_statfs2_bsize=yes \
                           --sysconfdir=/storage/.config \
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
                           --mandir=/dev/null \
                           --disable-doxygen-doc \
                           --disable-doxygen-rtf \
                           --disable-doxygen-xml \
                           --disable-doxygen-chm \
                           --disable-doxygen-chi \
                           --disable-doxygen-dot \
                           --disable-doxygen-html \
                           --without-internal-edit \
                           --disable-silent-rules \
                           --enable-largefile \
                           --enable-background \
                           --enable-charset \
                           --without-gpm-mouse \
                           --with-screen=ncurses \
                           --without-x \
                           --with-subshell \
                           --enable-vfs-sftp \
                           --enable-vfs-tar \
                           --enable-vfs-extfs \
                           --enable-vfs-cpio \
                           --disable-vfs-smb \
                           --without-mmap \
                           --with-pcre=$SYSROOT_PREFIX/usr \
                           --without-debug \
                           --without-gnome \
                           --without-samba"