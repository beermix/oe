PKG_NAME="xtables-addons"
PKG_VERSION="3.2"
PKG_SITE="https://github.com/aria2/aria2/releases"
PKG_URL="https://master.dl.sourceforge.net/project/xtables-addons/Xtables-addons/xtables-addons-3.2.tar.xz"
PKG_DEPENDS_TARGET="toolchain expat pcre curl libev libxml2 libuv"
PKG_SECTION="tools"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --sysconfdir=/storage/.config \
                           --datadir=/storage/.config \
                           --libdir=/storage/.config \
                           --libexecdir=/storage/.config \
                           --without-libnettle \
                           --with-openssl \
                           --disable-ipv6 \
                           --without-gnutls \
                           --without-libssh2 \
                           --with-ca-bundle=/etc/ssl/cacert.pem \
                           --with-libexpat \
                           --with-zlib \
                           --with-libuv \
                           --without-libgcrypt \
                           --with-sqlite3 \
                           --with-libxml2"