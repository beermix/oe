PKG_NAME="pure-ftpd"
PKG_VERSION="1.0.46"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libsodium libevent libcap"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-ssp --with-altlog --with-nonroot --with-rfc2640 --disable-ssp --with-ftpwho --sysconfdir=/storage/.config --datadir=/storage/.config --libdir=/storage/.config --libexecdir=/storage/.config --sharedstatedir=/storage/.config --localstatedir=/storage/.config --includedir=/storage/.config --oldincludedir=/storage/.config --datarootdir=/storage/.config --infodir=/storage/.config --localedir=/storage/.config --enable-largefile"

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}

post_install () {
  enable_service ftpd.service
  enable_service acestream.service
  enable_service iperf3.service
}