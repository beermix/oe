PKG_NAME="mc"
PKG_VERSION="4.8.20"
PKG_URL="http://ftp.midnight-commander.org/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libtool:host gettext:host e2fsprogs util-linux glib pcre fuse libssh2 libevent expat slang"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/home/user/.bin/mcc \
                           --datadir=/home/user/.bin/mcc \
                           --libdir=/home/user/.bin/mcc \
                           --libexecdir=/home/user/.bin/mcc \
                           --sharedstatedir=/home/user/.bin/mcc \
                           --localstatedir=/home/user/.bin/mcc \
                           --includedir=/home/user/.bin/mcc \
                           --oldincludedir=/home/user/.bin/mcc \
                           --datarootdir=/home/user/.bin/mcc \
                           --infodir=/home/user/.bin/mcc \     
                           --localedir=/home/user/.bin/mcc \
                           --disable-doxygen-doc \
                           --disable-doxygen-rtf \
                           --disable-doxygen-xml \
                           --disable-doxygen-chm \
                           --disable-doxygen-chi \
                           --disable-doxygen-dot \
                           --disable-doxygen-html \
                           --without-internal-edit \
                           --enable-silent-rules \
                           --enable-background \
                           --enable-charset \
                           --without-gpm-mouse \
                           --with-screen=slang \
                           --with-subshell=no \
                           --enable-vfs-sftp \
                           --enable-vfs-tar \
                           --enable-vfs-extfs \
                           --enable-vfs-cpio \
                           --disable-vfs-smb"
                           
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"