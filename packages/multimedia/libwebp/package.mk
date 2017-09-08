PKG_NAME="libwebp"
PKG_VERSION="8635973"
PKG_GIT_URL="https://github.com/webmproject/libwebp"
PKG_DEPENDS_TARGET="toolchain intel-vaapi-driver libva"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"

post_makeinstall_target() {
  rm -rf $INSTALL
}