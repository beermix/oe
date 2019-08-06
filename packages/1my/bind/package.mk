PKG_NAME="bind"
PKG_VERSION="9.15.2"
PKG_SHA256="69108ea935e9272287c3863cd17395ebeac8a70945130fbfb3cce95cfcc3fc54"
PKG_URL="https://fossies.org/linux/misc/dns/bind9/$PKG_VERSION/bind-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain sqlite libcap openssl"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-randomdev="/dev/urandom" \
			      --with-openssl=$SYSROOT_PREFIX/usr \
			      --without-libjson \
			      --with-libxml2 \
			      --without-lmdb \
			      --with-eddsa=no \
			      --enable-epoll \
			      --with-gost=no \
			      --without-gssapi \
			      --with-ecdsa=yes \
			      --with-libtool \
			      --with-readline \
			      --without-python \
			      --sysconfdir=/storage/.config"


