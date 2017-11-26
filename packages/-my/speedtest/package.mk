PKG_NAME="speedtest"
PKG_VERSION="cdf7087"
PKG_GIT_URL="https://github.com/taganaka/SpeedTest"
PKG_DEPENDS_TARGET="toolchain curl libxml2 openssl"
PKG_USE_CMAKE="yes"


PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"