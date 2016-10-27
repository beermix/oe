PKG_NAME="davfs2"
PKG_VERSION="1.5.4"
PKG_URL="http://download.savannah.gnu.org/releases/davfs2/davfs2-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain fuse neon"
PKG_PRIORITY="optional"
PKG_SECTION="system"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


AM_CFLAGS="-Wall -Werror=format-security"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
			   ne_cv_lib_neonver=yes \
			   --with-neon=$SYSROOT_PREFIX/usr \
			   --sysconfdir=/storage/.config \
			   --datarootdir=/storage/.config"
			  
post_makeinstall_target() {
  rm -rf $INSTALL/sbin/
  rm -rf $INSTALL/storage/
}