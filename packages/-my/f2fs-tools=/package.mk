PKG_NAME="f2fs-tools"
PKG_VERSION="v1.6.1"
PKG_GIT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git"
PKG_DEPENDS_TARGET="toolchain util-linux"

PKG_SECTION="security"
PKG_TOOLCHAIN="autotools"


PKG_CONFIGURE_OPTS_TARGET="ac_cv_file__git=no \
			   --prefix=/usr \
			   --sbindir=/usr/bin \
			   --enable-static \
			   --disable-shared \
			   --with-gnu-ld"


PKG_CONFIGURE_OPTS_INIT="$PKG_CONFIGURE_OPTS_TARGET"