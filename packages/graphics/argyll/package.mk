PKG_NAME="argyll"
PKG_VERSION="1.9.2"
PKG_URL="https://dl.dropboxusercontent.com/s/99fg6i9kh30imi2/argyll-1.9.2.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="graphics"

make_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  make \
  	CXX="$CXX" \
  	CXXFLAGS="$TARGET_CXXFLAGS" \
  	CPPFLAGS="$CPPFLAGS" \
  	RANLIB="$RANLIB" \
  	AR="$AR" -j1
}