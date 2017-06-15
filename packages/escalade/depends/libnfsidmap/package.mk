# Made by github.com/escalade
PKG_NAME="libnfsidmap"
PKG_VERSION="0.26"
PKG_ARCH="any"
PKG_LICENSE="custom"
PKG_SITE="http://www.citi.umich.edu/projects/nfsv4/linux/"
PKG_URL="https://fedorapeople.org/~steved/libnfsidmap/0.26/libnfsidmap-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="escalade"
PKG_SHORTDESC="Library to help mapping IDs, mainly for NFSv4"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes"
