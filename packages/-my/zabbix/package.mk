PKG_NAME="zabbix"
PKG_VERSION="3.4.1"
PKG_URL="https://fossies.org/linux/misc/zabbix-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain curl libxml2 mariadb ncurses openssl libevent"
PKG_SECTION="devel"

pre_configure_host() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
}

PKG_CONFIGURE_OPTS_TARGET="--datadir=/storage/.config/zabbix \
			      --sysconfdir=/storage/.config/zabbix \
			      --disable-ipv6 \
			      --disable-java \
			      --enable-server \
			      --enable-proxy \
			      --enable-agent \
			      --with-mysql=$SYSROOT_PREFIX/usr \
			      --with-net-snmp=no \
			      --with-ssh2=no \
			      --with-gnutls=no \
			      --with-libxml2=$SYSROOT_PREFIX/usr \
			      --with-iconv=$SYSROOT_PREFIX/usr \
			      --with-libpcre=$SYSROOT_PREFIX/usr \
			      --with-libevent=$SYSROOT_PREFIX/usr"

post_install() {
  add_user zabbix x 990 990 "zabbix server" "/storage" "/bin/sh"
  add_group zabbix 990
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}