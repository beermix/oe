
PKG_NAME="automake"
PKG_VERSION="f389ecb"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://sources.redhat.com/automake/"
PKG_GIT_URL="git://git.savannah.gnu.org/automake.git"
PKG_DEPENDS_HOST="ccache:host autoconf:host m4:host"
PKG_PRIORITY="optional"
PKG_SECTION="toolchain/devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_build_host() {
# broken autoreconf
  ( cd $ROOT/$PKG_BUILD
    NOCONFIGURE=1 ./bootstrap
  )
}



PKG_CONFIGURE_OPTS_HOST="--target=$TARGET_NAME --disable-silent-rules"

post_makeinstall_host() {
  make prefix=$SYSROOT_PREFIX/usr install
}
