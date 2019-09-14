PKG_NAME="gawk"
PKG_VERSION="4.2.1"
PKG_SHA256="d1119785e746d46a8209d28b2de404a57f983aa48670f4e225531d3bdc175551"
#PKG_VERSION="5.0.1"
#PKG_VERSION="7f684e83cdfa0647d8e197271fe318d2c185d291"
# http://git.savannah.gnu.org/cgit/gawk.git/log/?h=gawk-4.2-stable
PKG_URL="http://ftpmirror.gnu.org/gawk/gawk-$PKG_VERSION.tar.xz"
#PKG_URL="http://git.savannah.gnu.org/cgit/gawk.git/snapshot/gawk-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_HOST="ccache:host mpfr:host"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--without-libsigsegv  --without-mpfr"
PKG_CONFIGURE_OPTS_HOST="--without-libsigsegv"

post_makeinstall_target() {
  ln -sf gawk $INSTALL/usr/bin/awk
}

post_makeinstall_host() {
  mkdir -p $TOOLCHAIN/bin
  ln -sf gawk $TOOLCHAIN/bin/awk
}
