PKG_NAME="rsync"
PKG_VERSION="3.1.2"
PKG_SITE="http://www.samba.org/ftp/rsync/rsync.html"
PKG_URL="https://download.samba.org/pub/rsync/src/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain popt attr"
PKG_PRIORITY="optional"
PKG_SECTION="network/backup"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			      --enable-static \
			      --without-gssapi \
			      --disable-option-checking \
			      --disable-ipv6"