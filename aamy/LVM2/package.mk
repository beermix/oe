PKG_NAME="LVM2"
PKG_VERSION="2.02.173"
PKG_SITE="ftp://sources.redhat.com/pub/lvm2/"
PKG_URL="ftp://sources.redhat.com/pub/lvm2/${PKG_NAME}.${PKG_VERSION}.tgz"
PKG_SOURCE_DIR="${PKG_NAME}.${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain libdaemon readline"
PKG_SECTION="system"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
			   ac_cv_func_realloc_0_nonnull=yes \
			   ac_cv_flag_HAVE_PIE=no \
			   --disable-testing \
			   --disable-blkid_wiping \
			   --with-lvm1=none"
