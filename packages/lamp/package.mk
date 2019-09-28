# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)
# Copyright (C) 2014-present ultraman

# needs
#   PKG_NAME="libssh2"
#   PKG_NAME="libxslt"
#   PKG_BUILD_FLAGS="+pic"

#   ./scripts/rebuild libxslt

PKG_NAME="lamp"
PKG_VERSION="1.0"
PKG_REV="105"
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain expat httpd php mysqld ssh2 phpMyAdmin eglibc-localedef:host smbclient msmtp aria2 apcu"
PKG_LONGDESC="LAMP ($PKG_VERSION.$PKG_REV): (Linux Apache MySQL PHP) software bundle."
PKG_TOOLCHAIN="manual"
#PKG_TOOLCHAIN="configure"

PKG_IS_ADDON="yes"
PKG_SECTION="service/web"
PKG_ADDON_NAME="LAMP"
PKG_ADDON_TYPE="xbmc.service"
# PKG_ADDON_PROVIDES="executable"
# PKG_MAINTAINER="John Doe (email)"

post_unpack() {
  echo "lamp post_unpack"
  #read a
}

configure_target() {
  echo "lamp configure_target"
  #read a
}

post_configure_target() {
  echo "lamp post_configure_target"
  #read a
}

make_target() {
  echo "lamp make_target"
  #read a
}

makeinstall_target() {
  echo "lamp make_target"
  #read a
}

addon() {
  HTTPD_DIR=$(get_build_dir httpd)/.install_dev
  MYSQL_DIR=$(get_build_dir mysqld)/.install_pkg
  PHPMYADMIN_BASE_NAME=$(basename $(get_build_dir phpMyAdmin))
  PHPMYADMIN_ZIP_DIR=$(readlink -f $SOURCES/phpMyAdmin)

  # create bin folder and copy binaries
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $HTTPD_DIR/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $HTTPD_DIR/usr/sbin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
  
  # allow mounting SMB share in owncloud (just copy correct file)
  if [ -f $(get_build_dir samba)/.$TARGET_NAME/bin/smbclient ]; then
  	cp $(get_build_dir samba)/.$TARGET_NAME/bin/smbclient $ADDON_BUILD/$PKG_ADDON_ID/bin
  else
    cp $(get_build_dir samba)/bin/smbclient               $ADDON_BUILD/$PKG_ADDON_ID/bin
  fi
   
  cp $(get_build_dir php)/.install_dev/usr/bin/php $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $(get_build_dir msmtp)/.install_pkg/usr/bin/msmtp $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $(get_build_dir aria2)/.$TARGET_NAME/src/aria2c $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $MYSQL_DIR/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin

  # create lib folder and copy libraries
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib
  
  # copy samba libs (just in case)
  cp -PR $(get_build_dir samba)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PR $(get_build_dir avahi)/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp     $(get_build_dir popt)/.install_pkg/usr/lib/libpopt.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  
  cp -PR $MYSQL_DIR/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  
  cp -PR $HTTPD_DIR/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PR $(get_build_dir openssl)/.install_pkg/usr/lib/lib*.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PR $(get_build_dir apr)/.install_dev/usr/lib/lib*.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PR $(get_build_dir apr-util)/.install_dev/usr/lib/lib*.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PR $(get_build_dir apr-util)/.install_dev/usr/lib/apr-util-1/*.so* $ADDON_BUILD/$PKG_ADDON_ID/lib

  cp $(get_build_dir ssh2)/modules/ssh2.so $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir apcu)/modules/apcu.so $ADDON_BUILD/$PKG_ADDON_ID/lib

  cp $(get_build_dir php)/.install_dev/usr/lib/libphp5.so $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir bzip2)/.install_pkg/usr/lib/libbz2.so.1.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir curl)/.install_pkg/usr/lib/libcurl.so.4 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir expat)/.install_pkg/usr/lib/libexpat.so.1 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir freetype)/.install_pkg/usr/lib/libfreetype.so.6 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir libxml2)/.install_pkg/usr/lib/libxml2.so.2 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir zlib)/.install_pkg/usr/lib/libz.so.1 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir libgcrypt)/.install_pkg/usr/lib/libgcrypt.so.20 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir icu4c)/.install_pkg/usr/lib/lib*.so.* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir libtool)/.install_pkg/usr/lib/libltdl.so.7 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # locale stuff (en_US.UTF8)
  cp -a $(get_build_dir eglibc-localedef)/lib/locale $ADDON_BUILD/$PKG_ADDON_ID/lib

  # add httpd www folder
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/www

  cp -PR $HTTPD_DIR/usr/htdocs $ADDON_BUILD/$PKG_ADDON_ID/www
  cp -PR $HTTPD_DIR/usr/icons $ADDON_BUILD/$PKG_ADDON_ID/www

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/www/htdocs
  cp -a $PKG_DIR/config/php-tests $ADDON_BUILD/$PKG_ADDON_ID/www/htdocs
  cp $PKG_DIR/config/*.php $ADDON_BUILD/$PKG_ADDON_ID/www/htdocs/
  cp $PKG_DIR/config/*.sql $ADDON_BUILD/$PKG_ADDON_ID/
  cp $PKG_DIR/config/ssl-server.conf $ADDON_BUILD/$PKG_ADDON_ID/

  # create httpd server root
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot

  # add httpd configuration files to server root
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $HTTPD_DIR/etc/original $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $HTTPD_DIR/etc/magic $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $HTTPD_DIR/etc/mime.types $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $PKG_DIR/config/httpd.conf $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $PKG_DIR/config/extra $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $PKG_DIR/config/php.ini $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $PKG_DIR/config/mysqld.cnf $ADDON_BUILD/$PKG_ADDON_ID
  cp -PR $PKG_DIR/config/msmtprc $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf

  # add other httpd files to server root
  cp -PR $HTTPD_DIR/usr/error $ADDON_BUILD/$PKG_ADDON_ID/srvroot

  # create httpd server root log dir
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot/logs

  # copy share and config files
  cp -PR $MYSQL_DIR/usr/share $ADDON_BUILD/$PKG_ADDON_ID

  # phpMyAdmin stuff
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/www/htdocs
(
  cd $ADDON_BUILD/$PKG_ADDON_ID/www/htdocs
  unzip -qq "$PHPMYADMIN_ZIP_DIR/$PHPMYADMIN_BASE_NAME.zip"
  mv phpMyAdmin-* phpMyAdmin
)

  cp $PKG_DIR/config/config.inc.php $ADDON_BUILD/$PKG_ADDON_ID

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf/certs
  # how to fix this
  cp /etc/ssl/certs/ca-certificates.crt $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf/certs
  
  # missing other libs
  cp -PR \
    $SYSROOT_PREFIX/usr/lib/libdbus-1.so* \
    $SYSROOT_PREFIX/usr/lib/libsqlite3.so* \
    $SYSROOT_PREFIX/usr/lib/libsystemd.so* \
    $SYSROOT_PREFIX/usr/lib/libmount.so* \
    $SYSROOT_PREFIX/usr/lib/libblkid.so* \
  $ADDON_BUILD/$PKG_ADDON_ID/lib

  # list libraries
  echo
  echo "LAMP build complete."
  echo
  echo "Required libraries:"

  find $BUILD/addons/lamp/service.web.lamp/ -type f -exec objdump -x "{}" ";" 2>/dev/null | \
    grep NEEDED | sort -u  | \
    grep -Ev "libc.so|libdl.so|libgcc_s.so|libm.so|libnsl.so|libpthread.so|libresolv.so|librt.so|librtmp.so|libstdc\+\+.so|libuuid.so|libcrypt.so|ld-linux-x86-64.so.2" | \
    awk '{printf("  %s\n", $2)}' | tee $ADDON_BUILD/libs-required.dat

  cat $ADDON_BUILD/libs-required.dat
  missing_lib="0"

  # dont use 'cat file | while read f; do' because variable scope is inside loop only
  while read f; do
    ff=$(find $ADDON_BUILD -name $f 2>/dev/null)
    if [ ! -f "$ff" ]; then
      if [ "$f" != "ld-linux-x86-64.so.2" ] && [ "$f" != "ld-linux-armhf.so.3" ]; then
        echo "not copied: $f"
        missing_lib="1"
      fi
    fi
  done < $ADDON_BUILD/libs-required.dat

	echo ""
  if [ "$missing_lib" == "0" ]; then
    echo "no missing libraries"
  else
    echo "missing libraries"
  fi
  echo ""
}

dummy() {
: #

find packages/lamp/ -name package.mk |sed 's|packages/lamp/\(.*\)/package.mk|\1|' | xargs -I {} basename {} | xargs printf "rm -fr build*/%s*\n" $1

}
