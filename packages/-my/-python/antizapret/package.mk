PKG_NAME="antizapret"
PKG_VERSION="c94c0c1"
PKG_GIT_URL="https://github.com/afedchin/antizapret"
PKG_DEPENDS_TARGET="toolchain Python"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_LOCALE_INSTALL="yes"

make_target() {
  : # nothing to make here
}

makeinstall_target() {
  DESTDIR=$INSTALL ./install
}

post_install() {
  enable_service aceproxy.service
}
