PKG_NAME="netdata"
PKG_VERSION="1.6.0"
PKG_URL="https://github.com/firehol/netdata/releases/download/v$PKG_VERSION/netdata-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain util-linux netbsd-curses sysstat libmnl zlib libnetfilter_acct lm_sensors mysqlclient fping"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--with-zlib \
			      --with-math \
			      --with-user=netdata \
			      --with-webdir=/storage/.config/webdir \
			      --sysconfdir=/storage/.config \
                           --datadir=/storage/.config \
                           --libdir=/storage/.config \
                           --libexecdir=/storage/.config \
                           --sharedstatedir=/storage/.config \
                           --localstatedir=/storage/.config \
                           --includedir=/storage/.config \
                           --oldincludedir=/storage/.config \
                           --datarootdir=/storage/.config \
                           --infodir=/storage/.config \
                           --localedir=/storage/.config"
                 
post_install() {
  add_user nobody x 990 990 "netdata" "/storage" "/bin/sh"
  add_group netdev 990
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}
