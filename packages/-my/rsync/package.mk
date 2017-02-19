PKG_NAME="rsync"
PKG_VERSION="87bc224"
PKG_GIT_URL="git://git.samba.org/rsync.git"
PKG_DEPENDS_TARGET="toolchain popt attr"
PKG_SECTION="network/backup"
PKG_AUTORECONF="no"


PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --without-gssapi \
			      --disable-ipv6 \
			      --disable-debug"