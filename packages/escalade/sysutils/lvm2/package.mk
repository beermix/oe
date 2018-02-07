# Made by github.com/escalade
#
PKG_NAME="lvm2"
PKG_VERSION="2.02.176"
PKG_ARCH="any"
PKG_LICENSE="GPLv2 LGPL2.1"
PKG_SITE="https://sourceware.org/lvm2"
PKG_URL="http://mirrors.kernel.org/sourceware/lvm2/releases/LVM2.$PKG_VERSION.tgz"
PKG_SOURCE_DIR="LVM2.$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain systemd readline util-linux"
PKG_SECTION="escalade"
PKG_SHORTDESC="Logical Volume Manager 2 utilities"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
			   ac_cv_func_realloc_0_nonnull=yes \
			   --enable-pkgconfig \
			   --enable-cmdlib \
			   --enable-applib"
