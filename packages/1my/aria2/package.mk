PKG_NAME="aria2"
PKG_VERSION="1.35.0"
PKG_SHA256="1e2b7fd08d6af228856e51c07173cfcf987528f1ac97e04c5af4a47642617dfd"
#PKG_VERSION="7f6578a"
PKG_SITE="https://github.com/aria2/aria2/releases"
PKG_URL="https://github.com/aria2/aria2/releases/download/release-$PKG_VERSION/aria2-$PKG_VERSION.tar.xz"
#PKG_URL="https://github.com/aria2/aria2/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain expat pcre curl libev gmp libuv c-ares"
PKG_TOOLCHAIN="configure"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/storage/.config \
                           --datadir=/storage/.config \
                           --libdir=/storage/.config \
                           --libexecdir=/storage/.config \
                           --without-included-gettext \
                           --disable-nls \
                           --without-libnettle \
                           --with-libcares \
                           --with-openssl \
                           --disable-ipv6 \
                           --without-gnutls \
                           --without-libssh2 \
                           --with-ca-bundle=/run/libreelec/cacert.pem \
                           --without-libexpat \
                           --without-libxml2 \
                           --without-sqlite3 \
                           --with-zlib \
                           --with-libuv \
                           --with-libgmp \
                           --without-libgcrypt \
                           ARIA2_STATIC=no"