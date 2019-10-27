PKG_NAME="pure-ftpd"
PKG_VERSION="1.0.46"
PKG_SHA256="0609807335aade4d7145abdbb5cb05c9856a3e626babe90658cb0df315cb0a5c"
PKG_URL="https://download.pureftpd.org/pub/pure-ftpd/releases/obsolete/$PKG_NAME-$PKG_VERSION.tar.gz"
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