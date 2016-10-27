PKG_NAME="knot"
PKG_VERSION="2.2.1"
PKG_URL="https://secure.nic.cz/files/knot-dns/knot-2.2.1.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl jansson gnutls"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --enable-recvmmsg=no \
			   --disable-fastparser \
			   --without-libidn \
			   --with-rundir=/var/run/knot \
			   --with-storage=/var/lib/knot \
			   --with-configdir=/etc/knot \
			   --with-timer-mapsize=50 \
			   --with-conf-mapsize=50"