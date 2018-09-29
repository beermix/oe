PKG_NAME="gawk"
#PKG_VERSION="4.1.4"
PKG_VERSION="4.2.1"
PKG_SHA256="d1119785e746d46a8209d28b2de404a57f983aa48670f4e225531d3bdc175551"
PKG_URL="http://ftpmirror.gnu.org/gawk/gawk-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline mpfr libsigsegv"
PKG_DEPENDS_HOST="mpfr:host libsigsegv:host"

post_makeinstall_target() {
  ln -sfv gawk $INSTALL/usr/bin/awk
}

post_makeinstall_host() {
 mkdir -p $TOOLCHAIN/bin
 ln -sf gawk $TOOLCHAIN/bin/awk
}