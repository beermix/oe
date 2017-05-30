PKG_NAME="bind"
PKG_VERSION="9.11.1"
PKG_URL="http://www.mirrorservice.org/sites/ftp.isc.org/isc/bind9/9.11.1/bind-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain sqlite libcap openssl libidn2"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_taret() {
  export LIBS="-lterminfo"
  #export LDFLAGS="$LDFLAGS -lz -lpthread -lm -ldl"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-randomdev="/dev/urandom" \
			      --enable-threads \
			      --disable-linux-caps \
			      --with-openssl=$SYSROOT_PREFIX/usr \
			      --with-libjson=no \
			      --with-libtool \
			      --with-libxml2=no \
			      --enable-epoll=yes \
			      --with-gost=no \
			      --with-gssapi=no \
			      --with-ecdsa \
			      --with-readline=no"


