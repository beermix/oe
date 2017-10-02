PKG_NAME="rsync"
PKG_VERSION="3.1.2"
PKG_SITE="http://www.samba.org/ftp/rsync/rsync.html"
PKG_URL="https://download.samba.org/pub/rsync/src/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain popt attr"
PKG_SECTION="network/backup"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--with-included-popt=no --with-included-zlib=no"