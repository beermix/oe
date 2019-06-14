PKG_NAME="thoradia-mono"
PKG_REV="9"
PKG_DEPENDS_TARGET="toolchain libmediainfo-shared"
PKG_SECTION="virtual"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Thoradia Mono Tools"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_REQUIRES="tools.mono:0.0.0"
PKG_MAINTAINER="thoradia"
PKG_SHORTDESC="$PKG_ADDON_NAME: a bundle of tools required by Mono add-ons"
PKG_LONGDESC="$PKG_ADDON_NAME ($PKG_REV) includes libmediainfo shared library."
PKG_DISCLAIMER="Keep it legal and carry on"

addon() {
  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID/lib"
  cp -L $(get_build_dir libmediainfo-shared)/.install_pkg/usr/lib/libmediainfo.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib/
}
