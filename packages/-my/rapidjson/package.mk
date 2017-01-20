PKG_NAME="rapidjson"
PKG_VERSION="v1.1.0"
PKG_GIT_URL="https://github.com/miloyip/rapidjson"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="devel"
PKG_SHORTDESC="rapidjson: JSON parser/generator"
PKG_LONGDESC="A fast JSON parser/generator for C++ with both SAX/DOM style API"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=OFF -DBUILD_TESTING=OFF"