PKG_NAME="netdata"
PKG_VERSION="1.10.0"
PKG_URL="https://github.com/firehol/netdata/releases/"
PKG_URL="https://github.com/firehol/netdata/releases/download/v$PKG_VERSION/netdata-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain util-linux ncurses sysstat libmnl zlib lm_sensors libcap libnetfilter_acct"
PKG_USE_CMAKE="no"
PKG_TOOLCHAIN="autotools"
                           
PKG_CONFIGURE_OPTS_TARGET="--with-zlib \
			      --with-math \
			      --enable-x86-sse \
			      --disable-lto \
			      --with-user=root \
			      --with-libcap \
			      --enable-plugin-nfacct \
			      --with-webdir=/storage/.config/netdata/webdir \
			      --sysconfdir=/storage/.config \
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

# mysqlclient

#post_install() {
#  add_user nobody x 990 990 "netdata" "/storage" "/bin/sh"
#  add_group netdev 990
#}

#post_makeinstall_target() {
#  rm -rf $INSTALL/storage
#}
