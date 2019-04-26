PKG_NAME="rsync"
PKG_VERSION="881addc"
PKG_GIT_URL="git://git.samba.org/rsync.git"
PKG_DEPENDS_TARGET="toolchain popt attr"
PKG_SECTION="network/backup"


PKG_CONFIGURE_OPTS_TARGET="--with-included-popt=no --disable-ipv6 --disable-debug"