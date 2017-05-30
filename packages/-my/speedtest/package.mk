PKG_NAME="speedtest"
PKG_VERSION="54a2998"
PKG_GIT_URL="https://github.com/taganaka/SpeedTest"
PKG_DEPENDS_TARGET="toolchain curl libxml2 openssl"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="-lterminfo"
}

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"