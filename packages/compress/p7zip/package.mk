PKG_NAME="p7zip"
PKG_VERSION="16.02"
PKG_SITE="http://p7zip.sourceforge.net/"
PKG_URL="http://downloads.sourceforge.net/project/p7zip/p7zip/${PKG_VERSION}/p7zip_${PKG_VERSION}_src_all.tar.bz2"
PKG_SOURCE_DIR="${PKG_NAME}_${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_USE_CMAKE="yes"
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  export CFLAGS="$CFLAGS -O3 -fexpensive-optimizations -fstack-protector-strong"
  export CXXFLAGS="$CXXFLAGS -O3 -ffast-math -fexpensive-optimizations -fstack-protector-strong"
}

make_target() {
  make all OPTFLAGS="$CFLAGS" 
}

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp $PKG_BUILD/bin/7za $INSTALL/usr/bin
}