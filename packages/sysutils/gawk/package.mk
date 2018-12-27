PKG_NAME="gawk"
PKG_VERSION="4.1.4"
PKG_VERSION="4.2.1"
#PKG_VERSION="7f684e83cdfa0647d8e197271fe318d2c185d291"
# http://git.savannah.gnu.org/cgit/gawk.git/log/?h=gawk-4.2-stable
PKG_URL="http://ftpmirror.gnu.org/gawk/gawk-$PKG_VERSION.tar.xz"
#PKG_URL="http://git.savannah.gnu.org/cgit/gawk.git/snapshot/gawk-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline"
PKG_DEPENDS_HOST="mpfr:host"
PKG_TOOLCHAIN="configure"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--without-libsigsegv"

PKG_CONFIGURE_OPTS_HOST="--without-libsigsegv"

#post_makeinstall_target() {
#  ln -sf gawk $INSTALL/usr/bin/awk
#  make check
#}

post_makeinstall_host() {
  mkdir -p $TOOLCHAIN/bin
  ln -sf gawk $TOOLCHAIN/bin/awk
}