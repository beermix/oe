PKG_NAME="gawk"
#$PKG_VERSION="4.2.1"
#PKG_SHA256="d1119785e746d46a8209d28b2de404a57f983aa48670f4e225531d3bdc175551"
PKG_VERSION="5.0.1"
PKG_SHA256="8e4e86f04ed789648b66f757329743a0d6dfb5294c3b91b756a474f1ce05a794"
# http://git.savannah.gnu.org/cgit/gawk.git/log/?h=gawk-4.2-stable
PKG_URL="http://ftpmirror.gnu.org/gawk/gawk-$PKG_VERSION.tar.xz"
#PKG_URL="http://git.savannah.gnu.org/cgit/gawk.git/snapshot/gawk-$PKG_VERSION.tar.gz"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline"
PKG_DEPENDS_HOST="ccache:host mpfr:host"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--disable-mpfr --disable-rpath"
PKG_CONFIGURE_OPTS_HOST="--without-libsigsegv"

post_makeinstall_target() {
  ln -sf gawk $INSTALL/usr/bin/awk
}

post_makeinstall_host() {
  mkdir -p $TOOLCHAIN/bin
  ln -sf gawk $TOOLCHAIN/bin/awk
}
