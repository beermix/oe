PKG_NAME="aria2"
PKG_VERSION="release-1.32.0"
PKG_SITE="https://github.com/aria2/aria2/releases"
PKG_GIT_URL="https://github.com/aria2/aria2"
PKG_DEPENDS_TARGET="toolchain expat pcre curl libev libxml2 libuv"
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
                           --without-gnutls \
                           --without-libssh2 \
                           --with-libexpat \
                           --with-zlib \
                           --with-libuv \
                           --without-libgcrypt \
                           --without-sqlite3 \
                           --with-libxml2 \
                           --with-gnu-ld \
                           --with-ca-bundle=/etc/ssl/cert.pem"