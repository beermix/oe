PKG_NAME="aria2"
PKG_VERSION="release-1.33.0"
PKG_SITE="https://github.com/aria2/aria2/releases"
PKG_URL="https://github.com/aria2/aria2/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain expat pcre curl libev libxml2 libuv libssh2"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --sysconfdir=/storage/.config \
                           --datadir=/storage/.config \
                           --libdir=/storage/.config \
                           --libexecdir=/storage/.config \
                           --without-libnettle \
                           --with-openssl \
                           --disable-ipv6 \
                           --without-gnutls \
                           --with-libssh2 \
                           --with-libexpat \
                           --with-zlib \
                           --with-libuv \
                           --with-libgcrypt \
                           --without-sqlite3 \
                           --with-libxml2 \
                           --with-ca-bundle=/etc/ssl/cert.pem"