PKG_NAME="zabbix"
PKG_VERSION="3.2.1"
PKG_URL="http://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/$PKG_VERSION/zabbix-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain curl libxml2 mariadb netbsd-curses openssl libssh2 net-snmp"

PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
   cd $ROOT/$PKG_BUILD
   export LDFLAGS="-lpthread -lrt"
   export LIBS="$LIBS -lssh2 -lmbedcrypto"
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			      --bindir=/usr/bin \
			      --sbindir=/usr/sbin \
			      --datadir=/storage/.config \
			      --sysconfdir=/storage/.config/zabbix \
			      --enable-server \
			      --enable-proxy \
			      --enable-agent \
			      --with-mysql \
			      --without-net-snmp \
			      --with-ssh2=$SYSROOT_PREFIX/usr \
			      --with-openssl=$SYSROOT_PREFIX/usr"


post_install() {
  add_user zabbix x 990 990 "zabbix server" "/storage" "/bin/bash"
  add_group zabbix 990
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}