PKG_NAME="sysdig"
PKG_VERSION="0.25"
PKG_URL="https://github.com/draios/sysdig"
PKG_URL="https://github.com/draios/sysdig/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="-lto -gold -hardening"

PKG_CMAKE_OPTS_TARGET="-DBUILD_DRIVER=0 -DBUILD_LIBSCAP_EXAMPLES=0 -DENABLE_DKMS=0 
-DCMAKE_BUILD_TYPE=Release"
