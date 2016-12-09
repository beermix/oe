PKG_NAME="xfsprogs"
PKG_VERSION="4.7.0"
PKG_URL="ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-$PKG_VERSION.tar.gz"
PKG_DEPENDS_INIT="toolchain readline"
PKG_DEPENDS_TARGET="toolchain util-linux readline"

PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
   cd $ROOT/$PKG_BUILD
}

pre_configure_init() {
   cd $ROOT/$PKG_BUILD
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_header_aio_h=yes \
			   ac_cv_lib_rt_lio_listio=yes \
			   --prefix=/usr \
			   --enable-lib64=no \
			   --enable-gettext=no \
			   --enable-static \
			   --disable-shared \
			   --enable-readline=no \
			   --enable-blkid=yes \
			   INSTALL_USER=root \
			   INSTALL_GROUP=root"

			   
PKG_CONFIGURE_OPTS_INIT="$PKG_CONFIGURE_OPTS_TARGET"


