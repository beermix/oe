PKG_NAME="libyami"
PKG_VERSION="master"
PKG_GIT_URL="https://github.com/01org/libyami"
PKG_GIT_BRANCH="master"
PKG_KEEP_CHECKOUT="no"
PKG_DEPENDS_TARGET="toolchain libva-intel-driver"

PKG_SECTION="security"
PKG_TOOLCHAIN="autotools"



PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_realloc_0_nonnull=yes"
