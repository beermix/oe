PKG_NAME="ActivePerl"
PKG_VERSION="5.24.0.2400-x86_64-linux-glibc-2.15-300561"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.acestream.com/"
PKG_URL="http://downloads.activestate.com/ActivePerl/releases/5.24.0.2400/ActivePerl-5.24.0.2400-x86_64-linux-glibc-2.15-300561.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="torrenter"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  : # nothing todo
}

makeinstall_target() {
  DESTDIR=$INSTALL ./install.sh
}

