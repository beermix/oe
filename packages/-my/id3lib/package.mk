PKG_NAME="id3lib"
PKG_VERSION="3.8.3"
PKG_REV="2"
PKG_ARCH="x86_64"
PKG_URL="https://sourceforge.net/projects/id3lib/files/id3lib/3.8.3/id3lib-3.8.3.tar.gz"
PKG_DEPENDS_TARGET="toolchain libxml2 sqlite"

PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC -DPIC"
  strip_lto
  ./configure --host=$TARGET_NAME --prefix=/usr

}

