################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="php"
PKG_VERSION="7.2.0RC2"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="OpenSource"
PKG_SITE="http://fi2.php.net/downloads.php"
PKG_URL="http://www.php.net/distributions/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="https://downloads.php.net/~pollita/php-7.2.0RC2.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib pcre curl libxml2 openssl libxslt libiconv icu"
PKG_SECTION="xmedia/tools"
PKG_SHORTDESC="php: Scripting language especially suited for Web development"
PKG_LONGDESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."

PKG_TOOLCHAIN="autotools"

post_unpack() {
  PHP_BUILD_DIR=$(get_build_dir php)
  echo "downloading pear..."
  if [ ! -f "$PHP_BUILD_DIR/../go-pear.phar" ]; then
    wget -O $PHP_BUILD_DIR/../go-pear.phar http://pear.php.net/go-pear.phar
  fi
  cp $PHP_BUILD_DIR/../go-pear.phar $PHP_BUILD_DIR/pear/go-pear.phar

  # libtool fix
  rm $PKG_BUILD/aclocal.m4
}

configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME

  # Dynamic Library support
  export LDFLAGS="$LDFLAGS -ldl -lpthread -lstdc++"

  # libiconv
  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/iconv"
  export LDFLAGS="$LDFLAGS -L$SYSROOT_PREFIX/usr/lib/iconv -liconv"

#  export CXXFLAGS="$CFLAGS"
#  export CPPFLAGS="$CFLAGS"

  PKG_CONFIGURE_OPTS_TARGET="--enable-cli \
                             --enable-cgi \
                             --with-config-file-path=/storage/.config/php \
                             --enable-opcache=no \
                             --without-pear \
                             --localstatedir=/var \
                             --disable-phpdbg \
                             --disable-rpath \
                             --enable-sockets \
                             --enable-session \
                             --enable-posix \
                             --enable-mbstring \
                             --enable-dom \
                             --enable-ctype \
                             --enable-zip \
                             --enable-ftp \
                             --enable-json \
                             --with-openssl-dir=$SYSROOT_PREFIX/usr \
                             --enable-libxml \
                             --enable-xml \
                             --enable-xmlreader \
                             --enable-xmlwriter \
                             --enable-simplexml \
                             --enable-fileinfo \
                             --with-libxml-dir=$SYSROOT_PREFIX/usr \
                             --with-curl=$SYSROOT_PREFIX/usr \
                             --with-openssl=$SYSROOT_PREFIX/usr \
                             --with-zlib=$SYSROOT_PREFIX/usr \
                             --with-bz2=$SYSROOT_PREFIX/usr \
                             --with-iconv \
                             --with-gettext \
                             --without-gmp \
                             --enable-pcntl \
                             --disable-sysvmsg \
                             --disable-sysvsem \
                             --disable-sysvshm \
                             --enable-filter \
                             --enable-calendar \
                             --with-pcre-regex=$SYSROOT_PREFIX/usr \
                             --with-sqlite3=$SYSROOT_PREFIX/usr \
                             --with-pdo-sqlite=$SYSROOT_PREFIX/usr \
                             --with-mysql=$SYSROOT_PREFIX/usr \
                             --with-mysql-sock=/var/tmp/mysql.sock \
                             --with-gd \
                             --enable-gd-native-ttf \
                             --enable-gd-jis-conv \
                             --enable-exif \
                             --with-jpeg-dir=$SYSROOT_PREFIX/usr \
                             --with-freetype-dir=$SYSROOT_PREFIX/usr \
                             --with-png-dir=$SYSROOT_PREFIX/usr"

  ac_cv_func_strcasestr=yes \
  $PKG_CONFIGURE_SCRIPT $TARGET_CONFIGURE_OPTS $PKG_CONFIGURE_OPTS_TARGET
}

makeinstall_target() {
  make -j1 install INSTALL_ROOT=$INSTALL $PKG_MAKEINSTALL_OPTS_TARGET
  rm -f $INSTALL/usr/bin/php-config
  rm -f $INSTALL/usr/bin/phpize
  rm -fr $INSTALL/usr/lib
  rm -fr $INSTALL/usr/php
  mkdir -p $INSTALL/usr/config/php
    cp php.ini-production $INSTALL/usr/config/php/php.ini
}
