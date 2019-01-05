PKG_NAME="gzip"
PKG_VERSION="1.10"
PKG_URL="http://ftpmirror.gnu.org/gzip/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_HOST="ccache:host"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="gl_cv_func_fflush_stdin=yes ac_cv_path_shell=/bin/bash"

PKG_CONFIGURE_OPTS_TARGET="gl_cv_func_fflush_stdin=yes ac_cv_path_shell=/bin/bash"