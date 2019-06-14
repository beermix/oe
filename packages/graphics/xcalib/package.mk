PKG_NAME="xcalib"
PKG_VERSION="a70156d"
PKG_URL="https://github.com/OpenICC/xcalib/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11 libXrandr libXxf86vm libxcb libXext"
PKG_SECTION="graphics"
PKG_TOOLCHAIN="cmake-make"

#pre_configure_target() {
#  export LDFLAGS="$LDFLAGS -lX11 -lXext -lm"
#}

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"