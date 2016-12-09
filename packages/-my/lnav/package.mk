PKG_NAME="lnav"
PKG_VERSION="2e68f48"
PKG_GIT_URL="https://github.com/tstack/lnav"
PKG_DEPENDS_HOST="toolchain sqlite"

PKG_SECTION="tools"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

export CC=$LOCAL_CC
export CCX=$LOCAL_CCX