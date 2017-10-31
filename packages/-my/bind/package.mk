PKG_NAME="bind"
PKG_VERSION="9.11.2"
PKG_URL="https://fossies.org/linux/misc/dns/bind9/$PKG_VERSION/bind-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain sqlite libcap openssl libidn2 readline"
PKG_SECTION="my"
PKG_AUTORECONF="yes"

LTO_SUPPORT="yes"
  
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
			      --enable-epoll=yes \
			      --with-gost=no \
			      --with-gssapi=no \
			      --with-ecdsa=yes \
			      --with-readline \
			      --sysconfdir=/storage/.config"


