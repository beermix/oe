PKG_NAME="rar2fs"
PKG_VERSION="37ea170"
PKG_URL="https://github.com/hasse69/rar2fs/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl zlib"

PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"
  
TARGET_CFLAGS="$CFLAGS -fPIC -DPIC"
TARGET_CPPFLAGS="$CPPFLAGS -fexceptions"

