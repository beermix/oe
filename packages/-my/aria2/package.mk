PKG_NAME="aria2"
PKG_VERSION="1.31.0"
PKG_URL="https://github.com/aria2/aria2/releases/download/release-$PKG_VERSION/aria2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain expat gmp pcre curl libuv libev openssl xmlstarlet libxml2"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-option-checking \
                           --disable-shared \
                           --disable-nls \
                           --with-gnu-ld \
                           --with-sysroot=$SYSROOT_PREFIX \
                           --sysconfdir=/storage/.config \
                           --datadir=/storage/.config \
                           --libdir=/storage/.config \
                           --libexecdir=/storage/.config \
                           --with-ca-bundle=/etc/ssl/cert.pem \
                           --with-openssl \
                           --disable-ipv6 \
                           --with-libgmp \
                           --enable-gnutls-system-crypto-policy
                           --without-libssh2 \
                           --with-libexpat \
                           --with-zlib \
                           --with-libz \
                           --with-libuv \
                           --without-libgcrypt \
                           --without-sqlite3 \
                           --with-xmltest \
                           --with-libxml2 \
                           --without-libcares \
                           LT_SYS_LIBRARY_PATH=$SYSROOT_PREFIX/lib:$SYSROOT_PREFIX/usr/lib"