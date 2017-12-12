PKG_NAME="chrpath"
PKG_VERSION="0.16"
PKG_URL="https://dl.dropboxusercontent.com/s/toh840hns83gr4b/chrpath-0.16.tar.xz"
PKG_DEPENDS_TARGET="toolchain"


PKG_TOOLCHAIN="autotools"



PKG_CONFIGURE_OPTS_TARGET="\
		--disable-shared \
		--prefix=/usr \
		--enable-static"
		

post_makeinstall_target() {
  rm -rf $INSTALL/usr/doc
}