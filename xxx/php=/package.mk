PKG_NAME="php"
PKG_VERSION="7.0.15"
PKG_SITE="http://www.php.net"
PKG_URL="http://www.php.net/distributions/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain zlib pcre curl openssl sqlite pcre pcre freetype libpng libjpeg-turbo tiff glu glu giflib gmp"
PKG_SECTION="tools"


pre_configure_target() {
   export LIBS="-lterminfo"
   strip_lto
}

PKG_CONFIGURE_OPTS_TARGET="--disable-all \
                           --without-pear \
                           --prefix=/usr \
                           --with-config-file-path=/storage/.config/php \
                           --localstatedir=/var \
                           --enable-cli \
                           --enable-cgi \
                           --enable-sockets \
                           --enable-posix \
                           --enable-spl \
                           --enable-session \
                           --with-openssl=$SYSROOT_PREFIX/usr \
                           --disable-xml \
                           --disable-xmlreader \
                           --disable-xmlwriter \
                           --disable-simplexml \
                           --with-zlib=$SYSROOT_PREFIX/usr \
                           --enable-exif \
                           --disable-ftp \
                           --with-gettext \
                           --with-gmp=$SYSROOT_PREFIX/usr \
                           --enable-json \
                           --without-readline \
                           --enable-pcntl \
                           --enable-sysvmsg \
                           --enable-sysvsem \
                           --enable-sysvshm \
                           --disable-zip \
                           --enable-filter \
                           --disable-calendar \
                           --with-curl=$SYSROOT_PREFIX/usr \
                           --with-pcre-regex \
                           --without-sqlite3 \
                           --enable-pdo \
                           --without-pdo-sqlite \
                           --with-pdo-mysql \
                           --disable-libxml"

makeinstall_target() {
  make
  make install
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin
  cp sapi/cgi/php-cgi $INSTALL/usr/bin/php
}
