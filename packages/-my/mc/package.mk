PKG_NAME="mc"
PKG_VERSION="4.8.22"
PKG_URL="http://ftp.midnight-commander.org/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libtool:host e2fsprogs util-linux pcre fuse libssh2"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export LIBS="$LIBS -lssh2"
}

pre_configure_host() {
  export LIBS="$LIBS -lssh2"
}

configure_package() {

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
                           --disable-background \
                           --enable-charset \
                           --without-gpm-mouse \
                           --with-screen=ncurses \
                           --with-subshell=no \
                           --disable-vfs-sftp \
                           --disable-vfs-tar \
                           --disable-vfs-extfs \
                           --disable-vfs-cpio \
                           --disable-vfs-smb"

 PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
}