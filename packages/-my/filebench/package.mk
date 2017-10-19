PKG_NAME="filebench"
PKG_VERSION="1.4.9.1"
PKG_URL="http://downloads.sourceforge.net/project/filebench/filebench/filebench-1.4.9.1/filebench-1.4.9.1.tar.gz"
#PKG_SOURCE_DIR="${PKG_NAME}-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain openssl curl grep libgcrypt"

PKG_SECTION="devel"

PKG_AUTORECONF="yes"

configure_target() {
  cd $PKG_BUILD
  ./configure --prefix=/usr --enable-rdtsc=yes --enable-system=yes --datarootdir=/storage/.config LDFLAGS="-static"
}

