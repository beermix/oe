PKG_NAME="iw"
PKG_VERSION="4.9"
PKG_SITE="http://wireless.kernel.org/en/users/Documentation/iw"
PKG_URL="https://www.kernel.org/pub/software/network/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libnl"

PKG_SECTION="tools"



configure_target() {
   strip_lto
   export CFLAGS="-O2 -g -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wsign-compare"
   export LDFLAGS="-s -Wl,--gc-sections -pthread" 
   export LIBS="-lm"
   export MAKEFLAGS=-j1
}

