aPKG_NAME="mc"
PKG_VERSION="4.8.18"
PKG_URL="http://ftp.midnight-commander.org/${PKG_NAME}-${PKG_VERSION}.tar.xz"
#PKG_GIT_URL="https://github.com/MidnightCommander/mc.git"
#PKG_GIT_BRANCH="master"
#PKG_KEEP_CHECKOUT="no"
PKG_DEPENDS_TARGET="toolchain libtool:host gettext:host e2fsprogs util-linux glib pcre fuse libssh2 libevent expat git gawk"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="$LIBS -lssh2 -lz -pthread"
}
CFLAGS="-march=corei7-avx -mtune=corei7-avx -O3 -Wa,--noexecstack"
LDFLAGS="-s -Wl,-O1,--as-needed"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
                           --disable-doxygen-doc \
                           --disable-doxygen-rtf \
                           --disable-doxygen-xml \
                           --disable-doxygen-chm \
                           --disable-doxygen-chi \
                           --disable-doxygen-dot \
                           --disable-doxygen-html \
                           --without-internal-edit \
                           --disable-silent-rules \
                           --enable-nls \
                           --enable-background \
                           --enable-charset \
                           --without-gpm-mouse \
                           --with-screen=ncurses \
                           --without-x \
                           --without-subshell \
                           --enable-vfs-sftp \
                           --enable-vfs-tar \
                           --enable-vfs-extfs \
                           --enable-vfs-cpio \
                           --disable-vfs-smb \
                           --with-gnu-ld \
                           --with-mmap \
                           --with-pcre=$SYSROOT_PREFIX/usr \
                           --with-search-engine=glib"