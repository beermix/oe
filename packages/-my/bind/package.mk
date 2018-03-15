PKG_NAME="bind"
PKG_VERSION="9.12.0"
PKG_URL="https://fossies.org/linux/misc/dns/bind9/$PKG_VERSION/bind-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain sqlite libcap openssl readline"
PKG_SECTION="my"
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
			      --enable-epoll=yes \
			      --with-gost=no \
			      --with-gssapi=no \
			      --with-ecdsa=yes \
			      --with-readline \
			      --sysconfdir=/storage/.config"


