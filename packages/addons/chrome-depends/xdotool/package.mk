PKG_NAME="xdotool"
PKG_VERSION="2.20110530.1"
PKG_SHA256="e7b42c8b1d391970e1c1009b256033f30e57d8e0a2a3de229fd61ecfc27baf67"
PKG_LICENSE="GPL"
PKG_SITE="http://www.semicomplete.com/projects/xdotool/"
PKG_URL="http://semicomplete.googlecode.com/files/${PKG_NAME}-${PKG_VERSION}.tar.gz"
#PKG_DEPENDS_TARGET="toolchain libXinerama libXtst"

pre_configure_target() {
  unset CPPFLAGS
  LDFLAGS="$LDFLAGS -lXext"
}

make_target() {
  make LDFLAGS="-Wl,-z -Wl,now -lXext" xdotool.static
  mv xdotool.static xdotool
}

makeinstall_target() {
  : # nothing to do here
}
