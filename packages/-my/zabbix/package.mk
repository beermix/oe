PKG_NAME="zabbix"
PKG_VERSION="3.2.0beta2"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_URL="http://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Development/3.2.0beta2/zabbix-3.2.0beta2.tar.gz"
PKG_DEPENDS_TARGET="toolchain curl libxml2 netbsd-curses openssl libssh2"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


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

