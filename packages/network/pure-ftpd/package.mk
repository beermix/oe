PKG_NAME="pure-ftpd"
PKG_VERSION="1.0.47"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libcap"
#PKG_DEPENDS_TARGET="toolchain libcap libevent libsodium"
PKG_SECTION="network"

PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/storage/.config \
			      --datadir=/storage/.config \
			      --libdir=/storage/.config \
			      --libexecdir=/storage/.config \
			      --sharedstatedir=/storage/.config \
			      --localstatedir=/storage/.config \
			      --includedir=/storage/.config \
			      --oldincludedir=/storage/.config \
			      --datarootdir=/storage/.config \
			      --infodir=/storage/.config \
			      --localedir=/storage/.config \
			      --with-minimal \
			      --enable-largefile"

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}

#post_install () {
#  enable_service ftpd.service
#}