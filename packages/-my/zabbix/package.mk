PKG_NAME="zabbix"
PKG_VERSION="3.2.7"
PKG_URL="https://fossies.org/linux/misc/zabbix-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain curl libxml2 mariadb netbsd-curses openssl libssh2"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
   cd $ROOT/$PKG_BUILD
   export LDFLAGS="-lpthread -lrt"
   #export LIBS="$LIBS -lssh2 -lmbedcrypto"
   #export CPPFLAGS="-I$(get_pkg_build linux)"
}

PKG_CONFIGURE_OPTS_TARGET="--datadir=/storage/.config \
			      --sysconfdir=/storage/.config/zabbix \
			      --enable-server \
			      --enable-proxy \
			      --enable-agent \
			      --with-mysql \
			      --with-net-snmp=no \
			      --with-ssh2=no \
			      --with-openssl=$SYSROOT_PREFIX/usr"


post_install() {
  add_user zabbix x 990 990 "zabbix server" "/storage" "/bin/sh"
  add_group zabbix 990
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}