PKG_NAME="php"
PKG_VERSION="5.6.21"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="OpenSource"
PKG_SITE="http://www.php.net"
PKG_URL="http://www.php.net/distributions/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain zlib pcre curl openssl sqlite pcre pcre2 freetype libpng libjpeg-turbo tiff glu glu giflib"

PKG_SECTION="tools"
PKG_AUTORECONF="no"



PKG_CONFIGURE_OPTS_TARGET="--disable-all \
                           --without-pear \
                           --prefix=/usr \
                           --with-config-file-path=/storage/.config/php \
                           --localstatedir=/var \
                           --disable-cli \
                           --enable-cgi \
                           --disable-sockets \
                           --enable-posix \
                           --disable-spl \
                           --disable-session \
                           --with-openssl=$SYSROOT_PREFIX/usr \
                           --disable-libxml \
                           --disable-xml \
                           --disable-xmlreader \
                           --disable-xmlwriter \
                           --disable-simplexml \
                           --with-zlib=$SYSROOT_PREFIX/usr \
                           --disable-exif \
                           --disable-ftp \
                           --without-gettext \
                           --without-gmp \
                           --enable-json \
                           --without-readline \
                           --disable-pcntl \
                           --disable-sysvmsg \
                           --disable-sysvsem \
                           --disable-sysvshm \
                           --disable-zip \
                           --disable-filter \
                           --disable-calendar \
                           --with-curl=$SYSROOT_PREFIX/usr \
                           --with-pcre-regex \
                           --without-sqlite3 \
                           --disable-pdo \
                           --without-pdo-sqlite \
                           --without-pdo-mysql"

makeinstall_target() {
make
make install
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp $PKG_BUILD/.$TARGET_NAME/sapi/cgi/php-cgi $ADDON_BUILD/$PKG_ADDON_ID/bin/php-cgi
}
