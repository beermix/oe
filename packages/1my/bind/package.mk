PKG_NAME="bind"
PKG_VERSION="9.14.2"
PKG_SHA256="0e4027573726502ec038db3973a086c02508671723a4845e21da1769a5c27f0c"
PKG_URL="https://fossies.org/linux/misc/dns/bind9/$PKG_VERSION/bind-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain sqlite libcap openssl"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-randomdev="/dev/urandom" \
			      --disable-threads \
			      --disable-linux-caps \
			      --with-openssl=$SYSROOT_PREFIX/usr \
			      --with-libjson=no \
			      --with-libtool \
			      --with-libxml2=no \
			      --without-lmdb \
			      --with-eddsa=no \
			      --enable-epoll \
			      --with-gost=no \
			      --without-gssapi \
			      --with-ecdsa=yes \
			      --with-libtool \
			      --without-readline \
			      --without-python \
			      --sysconfdir=/storage/.config"


