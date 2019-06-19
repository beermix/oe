PKG_NAME="pure-ftpd"
PKG_VERSION="1.0.47"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libcap"
#PKG_DEPENDS_TARGET="toolchain libcap libevent libsodium"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--with-minimal"

#post_makeinstall_target() {
#  rm -rf $INSTALL/storage
#}

post_install () {
  enable_service ftpd.service
}