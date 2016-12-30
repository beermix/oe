PKG_NAME="netdata"
PKG_VERSION="1.4.0"
PKG_URL="https://github.com/firehol/netdata/releases/download/v$PKG_VERSION/netdata-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain util-linux netbsd-curses sysstat"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

MAKEFLAGS="-j1"

PKG_CONFIGURE_OPTS_TARGET="--with-zlib \
			      --with-math \
			      --enable-plugin-nfacct \
			      --enable-pedantic \
			      --with-webdir=/storage/.config/netdata/webdir \
			      --sysconfdir=/storage/.config/netdata \
                           --datadir=/storage/.config/netdata \
                           --libdir=/storage/.config/netdata \
                           --libexecdir=/storage/.config/netdata \
                           --sharedstatedir=/storage/.config/netdata \
                           --localstatedir=/storage/.config/netdata \
                           --includedir=/storage/.config/netdata \
                           --oldincludedir=/storage/.config/netdata \
                           --datarootdir=/storage/.config/netdata \
                           --infodir=/storage/.config/netdata \
                           --localedir=/storage/.config/netdata"
                 
post_install() {
  add_user nobody x 990 990 "netdata" "/storage" "/bin/bash"
  add_group netdev 990
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}
