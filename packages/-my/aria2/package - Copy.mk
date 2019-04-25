sPKG_NAME="aria2"
PKG_VERSION="2cfe192"
PKG_GIT_URL="https://github.com/aria2/aria2"
PKG_DEPENDS_TARGET="toolchain expat pcre curl libev xmlstarlet libxml2 c-ares"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"

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
                           --without-libuv \
                           --without-libgcrypt \
                           --with-sqlite3 \
                           --with-xmltest \
                           --with-libxml2 \
                           --with-libcares=$SYSROOT_PREFIX/usr \
                           --with-ca-bundle=/etc/ssl/cert.pem"