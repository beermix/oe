PKG_NAME="zabbix"
PKG_VERSION="8d1f0fe"
PKG_GIT_URL="https://github.com/zabbix/zabbix"
PKG_DEPENDS_TARGET="toolchain curl libxml2 mariadb netbsd-curses openssl libssh2"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="-lterminfo"
  #export MAKEFLAGS=-j1
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
			   --without-ssh2 \
			   --without-zlibbxcrypto"


#post_makeinstall_target() {
#  rm -rf $INSTALL/storage
#}

