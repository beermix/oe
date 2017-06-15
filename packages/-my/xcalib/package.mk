PKG_NAME="xcalib"
PKG_VERSION="95c9329"
PKG_GIT_URL="https://github.com/OpenICC/xcalib"
PKG_DEPENDS_TARGET="toolchain libX11 libXrandr libXxf86vm libxcb libXext"
PKG_SECTION="my"
PKG_AUTORECONF="no"
PKG_USE_CMAKE="yes"

pre_configure_target() {
  export LDFLAGS="$LDFLAGS -lX11 -lXext -lm"
}

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr"