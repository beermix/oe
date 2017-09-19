################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2014-2015 ultraman
#      Copyright (C) 2014 streppuiu
#      Copyright (C) 2014 dominic7il
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="php"

# taken from environment
#PHP_VERSION=5.3.3

if [ -z "$PHP_VERSION" ]; then
  #PKG_VERSION="5.5.8"

	# test latest
	PKG_VERSION="5.6.9"
	#PKG_SOURCE_DIR="php-src-php-$PKG_VERSION"
else
  PKG_VERSION="$PHP_VERSION"
fi

PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="OpenSource"
PKG_SITE="http://www.php.net"

if [ -z "$PHP_VERSION" ]; then
  # PKG_URL="http://www.php.net/distributions/$PKG_NAME-$PKG_VERSION.tar.bz2"
  PKG_URL="http://www.php.net/distributions/$PKG_NAME-$PKG_VERSION.tar.xz"
else
  PKG_URL="http://museum.php.net/php5/php-$PKG_VERSION.tar.bz2"
fi

# add some other libraries which are need by php extensions
PKG_DEPENDS_TARGET="toolchain zlib pcre curl libxml2 libressl libmcrypt libiconv mysql httpd"
PKG_PRIORITY="optional"
PKG_SECTION="web"
PKG_SHORTDESC="php: Scripting language especially suited for Web development"
PKG_LONGDESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
PKG_MAINTAINER="ultraman"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

#export MAKEFLAGS=-j1

post_unpack() {
	PHP_BUILD_DIR=$(get_build_dir php)
	echo "downloading pear..."
	if [ ! -f "$PHP_BUILD_DIR/../go-pear.phar" ]; then
		wget -O $PHP_BUILD_DIR/../go-pear.phar http://pear.php.net/go-pear.phar
	fi
	cp $PHP_BUILD_DIR/../go-pear.phar $PHP_BUILD_DIR/pear/go-pear.phar
	
	# libtool fix
	rm $ROOT/$PKG_BUILD/aclocal.m4
}

configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME 

  # quick hack - freetype is in different folder
  # not for new
  #sed -i "s|freetype2/freetype/freetype.h|freetype2/freetype.h|g" configure
  
  ICONV_DIR=$(get_build_dir libiconv)/.install_dev
  LIBMCRYPT_DIR_TARGET=$(get_build_dir libmcrypt)/.install_dev
  HTTPD_DIR=$(get_build_dir httpd)/.install_dev

	export CFLAGS="$CFLAGS -DSQLITE_OMIT_LOAD_EXTENSION"
	export CFLAGS="$CFLAGS -I$HTTPD_DIR/usr/include"
	
  # Dynamic Library support
  export LDFLAGS="$LDFLAGS -ldl -lpthread"

  APXS_FILE=$(get_build_dir httpd)/.install_dev/usr/bin/apxs
  chmod +x $APXS_FILE
    
  PKG_CONFIGURE_OPTS_TARGET="--enable-cli \
                             --enable-opcache=no \
                             --with-pear \
                             --with-config-file-path=/storage/.kodi/userdata/addon_data/service.web.lamp/srvroot/conf \
                             --localstatedir=/var \
                             --enable-sockets \
                             --enable-session \
                             --enable-posix \
                             --enable-mbstring \
                             --enable-dom \
                             --enable-ctype \
                             --enable-zip \
                             --enable-ftp \
                             --with-openssl-dir=$SYSROOT_PREFIX/usr \
                             --enable-libxml \
                             --enable-xml \
                             --enable-xmlreader \
                             --enable-xmlwriter \
                             --enable-simplexml \
                             --enable-fileinfo \
                             --with-curl=$SYSROOT_PREFIX/usr \
                             --with-openssl=$SYSROOT_PREFIX/usr \
                             --with-zlib=$SYSROOT_PREFIX/usr \
                             --with-bz2=$SYSROOT_PREFIX/usr \
                             --with-zlib=$SYSROOT_PREFIX/usr \
                             --with-iconv=$ICONV_DIR/usr \
                             --disable-cgi \
                             --without-gettext \
                             --without-gmp \
                             --enable-json \
                             --enable-pcntl \
                             --disable-sysvmsg \
                             --disable-sysvsem \
                             --disable-sysvshm \
                             --enable-filter \
                             --enable-calendar \
                             --with-pcre-regex \
                             --with-sqlite3=$SYSROOT_PREFIX/usr \
                             --with-pdo-sqlite=$SYSROOT_PREFIX/usr \
                             --enable-pdo \
                             --with-mcrypt=$LIBMCRYPT_DIR_TARGET/usr \
                             --with-mysqli=$SYSROOT_PREFIX/usr/bin/mysql_config \
                             --with-mysql=$SYSROOT_PREFIX/usr \
                             --with-mysql-sock=/var/tmp/mysql.socket \
                             --with-pdo-mysql=$SYSROOT_PREFIX/usr \
                             --with-gd \
                             --enable-gd-native-ttf \
                             --enable-gd-jis-conv \
                             --enable-exif \
                             --with-jpeg-dir=$SYSROOT_PREFIX/usr \
                             --with-freetype-dir=$SYSROOT_PREFIX/usr \
                             --with-png-dir=$SYSROOT_PREFIX/usr \
                             --with-apxs2=$APXS_FILE"
  
  ac_cv_func_strcasestr=yes \
	$PKG_CONFIGURE_SCRIPT $TARGET_CONFIGURE_OPTS $PKG_CONFIGURE_OPTS_TARGET
}

post_configure_target() {
	: # dummy
  # quick hack
  # not for new
  sed -i "s|-I/usr/include|-I$SYSROOT_PREFIX/usr/include|g" Makefile
  sed -i "s|-L/usr/lib|-L$SYSROOT_PREFIX/usr/lib|g" Makefile
  
  PHP_BIN=$(which php)
  
  sed -i "s|PHP_EXECUTABLE =.*|PHP_EXECUTABLE = $PHP_BIN|g" Makefile
  sed -i 's|$(top_builddir)/$(SAPI_CLI_PATH)|dummy_sapi_cli_path|g' Makefile
}

makeinstall_target() {
  export INSTALL_DEV=$(pwd)/.install_dev
  
  mkdir -p $INSTALL_DEV/etc/
  cp $(get_build_dir httpd)/.install_dev/etc/httpd.conf $INSTALL_DEV/etc/httpd.conf 
  
  #sed -i "s|install-pear-installer:.*|install-pear-installer:\ndummy123:|g" Makefile
  
  #
  sed -i 's|@$(top_builddir)/sapi/cli/php|php|g' Makefile
  
  make -j1 install INSTALL_ROOT=$INSTALL_DEV $PKG_MAKEINSTALL_OPTS_TARGET
  	
	sed -i "/prefix/ s|/usr|$INSTALL_DEV/usr|" $INSTALL_DEV/usr/bin/phpize
	sed -i "/extension_dir/ s|/usr|$INSTALL_DEV/usr|" $INSTALL_DEV/usr/bin/php-config
	sed -i "/prefix/ s|/usr|$INSTALL_DEV/usr|" $INSTALL_DEV/usr/bin/php-config
}

# zamenjaj php in naj namesti pear tudi
