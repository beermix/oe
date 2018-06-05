PKG_NAME="mc"
PKG_VERSION="4.8.21"
PKG_URL="http://ftp.midnight-commander.org/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libtool:host gettext:host e2fsprogs util-linux glib pcre fuse libssh2 libevent expat"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export LIBS="$LIBS -lssh2"
}

PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/storage/.config/mc \
                           --datadir=/storage/.config/mc \
                           --libdir=/storage/.config/mc \
                           --libexecdir=/storage/.config/mc \
                           --sharedstatedir=/storage/.config/mc \
                           --localstatedir=/storage/.config/mc \
                           --includedir=/storage/.config/mc \
                           --oldincludedir=/storage/.config/mc \
                           --datarootdir=/storage/.config/mc \
                           --infodir=/storage/.config/mc \     
                           --localedir=/storage/.config/mc \
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
                           --without-gpm-mouse \
                           --with-screen=ncurses \
                           --with-subshell=no \
                           --enable-vfs-sftp \
                           --enable-vfs-tar \
                           --enable-vfs-extfs \
                           --enable-vfs-cpio \
                           --disable-vfs-smb"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"