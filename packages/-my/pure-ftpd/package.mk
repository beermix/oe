PKG_NAME="pure-ftpd"
PKG_VERSION="1.0.43"
PKG_URL="ftp://ftp.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libsodium libevent"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --prefix=/usr \
			      --disable-ssp \
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
                           
post_makeinstall_target() {
  rm -rf $INSTALL/storage
}