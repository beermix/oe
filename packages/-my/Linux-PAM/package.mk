PKG_NAME="Linux-PAM"
PKG_VERSION="1.2.0"
PKG_URL="https://dl.dropboxusercontent.com/s/cjds2bp5okus09y/Linux-PAM-1.2.0.tar.bz2"
PKG_DEPENDS_HOST="toolchain linux"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="\
	--enable-shared \
	--enable-static \
	--with-sysroot=$SYSROOT_PREFIX \
	--enable-pamlocking \
	--disable-prelude \
	--disable-lckpwdf \
	--disable-selinux \
	--disable-nls \
	--disable-rpath \
	--disable-nis \
	--disable-regenerate-docu \
	--enable-db=no"
	
PKG_CONFIGURE_OPTS_HOST="--enable-static"

post_makeinstall_target() {
  mkdir -p $INSTALL/lib
  cp -aP $INSTALL/lib64/* $INSTALL/lib
  rm -rf $INSTALL/lib64
}