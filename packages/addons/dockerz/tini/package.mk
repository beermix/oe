PKG_NAME="tini"
PKG_VERSION="949e6fa"
PKG_SITE="https://github.com/krallin/tini"
PKG_GIT_URL="https://github.com/krallin/tini"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="system"
PKG_SHORTDESC="Tini is the simplest init you could think of"
PKG_LONGDESC="Tini is the simplest init you could think of"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_TARGET_OPTS="-DCMAKE_BUILD_TYPE=Release -DMINIMAL=1"

PKG_MAKE_TARGET_OPTS="tini-static"

pre_configure_target(){
  sed -i "s|@tini_VERSION_GIT@| - git.${PKG_VERSION}|" $ROOT/$PKG_BUILD/src/tiniConfig.h.in
}

makeinstall_target() {
  :
}
