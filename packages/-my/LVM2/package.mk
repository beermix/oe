PKG_NAME="LVM2"
PKG_VERSION="2.02.168"
PKG_SITE="http://sources.redhat.com/lvm2/"
PKG_URL="ftp://sources.redhat.com/pub/lvm2/${PKG_NAME}.${PKG_VERSION}.tgz"
PKG_SOURCE_DIR="${PKG_NAME}.${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain libdaemon readline"
PKG_PRIORITY="optional"
PKG_SECTION="system"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
			      ac_cv_func_realloc_0_nonnull=yes \
			      --disable-lvm1_fallback \
			      --disable-static_link \
			      --disable-readline \
			      --enable-realtime \
			      --disable-debug \
			      --disable-profiling \
			      --enable-devmapper \
			      --disable-compat \
			      --enable-o_direct \
			      --enable-applib \
			      --enable-cmdlib \
			      --enable-pkgconfig \
			      --enable-fsadm \
			      --disable-dmeventd \
			      --disable-selinux \
			      --disable-nls"