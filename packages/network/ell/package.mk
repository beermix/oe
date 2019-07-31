PKG_NAME="ell"
PKG_VERSION="726ca36"
PKG_LICENSE="GPL"
PKG_SITE="https://git.kernel.org/cgit/libs/ell/ell.git/about"
PKG_URL="https://git.kernel.org/pub/scm/libs/ell/ell.git/snapshot/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="network"
PKG_SHORTDESC="Embedded Linux library"
PKG_LONGDESC="Embedded Linux library"

pre_configure_target() {
  cd $PKG_BUILD
  ./bootstrap-configure --host=$TARGET_NAME --build=$HOST_NAME --prefix=/usr 
}

