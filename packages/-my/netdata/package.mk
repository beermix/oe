PKG_NAME="netdata"
PKG_VERSION="1.4.0"
PKG_URL="https://github.com/firehol/netdata/releases/download/v$PKG_VERSION/netdata-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--with-webdir=/storage/.config/netdata/webdir \
			      --with-zlib \
			      --with-math \
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