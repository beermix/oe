PKG_NAME="aria2"
PKG_VERSION="release-1.30.0"
PKG_GIT_URL="https://github.com/aria2/aria2"
PKG_DEPENDS_TARGET="toolchain libssh2 expat gmp pcre curl libuv libev xmlstarlet libxml2 c-ares"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
                           --enable-static \
                           --sysconfdir=/storage/.config \
                           --datadir=/storage/.config \
                           --libdir=/storage/.config \
                           --libexecdir=/storage/.config \
                           --without-libnettle \
                           --with-openssl \
                           --disable-ipv6 \
                           --with-libgmp \
                           --without-gnutls \
                           --with-libssh2 \
                           --with-libexpat \
                           --with-zlib \
                           --with-libuv \
                           --without-libgcrypt \
                           --without-sqlite3 \
                           --with-xmltest \
                           --with-libxml2 \
                           --with-libcares=$SYSROOT_PREFIX/usr \
                           --with-ca-bundle=/etc/ssl/cert.pem"