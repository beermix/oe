PKG_NAME="aria2"
PKG_VERSION="1.31.0"
PKG_URL="https://github.com/aria2/aria2/releases/download/release-$PKG_VERSION/aria2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain expat gmp pcre curl libuv libev openssl xmlstarlet libxml2 libssh2"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

CONCURRENCY_MAKE_LEVEL=4

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --sysconfdir=/storage/.config \
                           --datadir=/storage/.config \
                           --libdir=/storage/.config \
                           --libexecdir=/storage/.config \
                           --with-ca-bundle=/etc/ssl/cert.pem \
                           --with-random=/dev/urandom \
                           --with-openssl=$SYSROOT_PREFIX/usr \
                           --with-gnutls=$SYSROOT_PREFIX/usr \
                           --disable-ipv6 \
                           --with-gnu-ld \
                           --with-libgmp=$SYSROOT_PREFIX/usr \
                           --with-libssh2=$SYSROOT_PREFIX/usr \
                           --with-libexpat=$SYSROOT_PREFIX/usr \
                           --with-zlib=$SYSROOT_PREFIX/usr \
                           --with-libz=$SYSROOT_PREFIX/usr \
                           --with-libuv=$SYSROOT_PREFIX/usr \
                           --with-libgcrypt=no \
                           --with-xmltest=$SYSROOT_PREFIX/usr \
                           --with-libxml2=$SYSROOT_PREFIX/usr \
                           --without-libcares \
                           --with-libexpat=$SYSROOT_PREFIX/usr \
                           --enable-largefile"