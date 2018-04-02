PKG_NAME="filebench"
PKG_VERSION="1.4.9.1"
PKG_URL="http://downloads.sourceforge.net/project/filebench/filebench/filebench-$PKG_VERSION/filebench-$PKG_VERSION.tar.gz"
#PKG_SOURCE_DIR="${PKG_NAME}-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain openssl curl grep libgcrypt"
PKG_TOOLCHAIN="autotools"

configure_target() {
  cd $PKG_BUILD
  ./configure --prefix=/usr --enable-rdtsc=yes --enable-system=yes --datarootdir=/storage/.config LDFLAGS="-static"
}

