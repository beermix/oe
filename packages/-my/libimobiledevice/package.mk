PKG_NAME="libimobiledevice"
PKG_VERSION="1.2.0"
PKG_URL="http://www.libimobiledevice.org/downloads/libimobiledevice-1.2.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libxml2 glib"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="libplist: a library for manipulating Apple Binary and XML Property Lists"
PKG_LONGDESC="libplist is a library for manipulating Apple Binary and XML Property Lists"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  ./configure --prefix=/usr
}