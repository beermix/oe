PKG_NAME="linux-pam"
PKG_VERSION="Linux-PAM-1.3.0"
PKG_GIT_URL="https://github.com/linux-pam/linux-pam"
PKG_DEPENDS_HOST="toolchain linux"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_SECTION="devel"


PKG_TOOLCHAIN="autotools"


PKG_CONFIGURE_OPTS_TARGET="\
	--disable-shared \
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

post_makeinstall_target() {
  mkdir -p $INSTALL/lib
  cp -aP $INSTALL/lib64/* $INSTALL/lib
  rm -rf $INSTALL/lib64
}