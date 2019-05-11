PKG_NAME="inputstream.adaptive"
PKG_VERSION="c51b9a9"
PKG_SHA256="872a6ffefb90b6201a1e01fe5a52e05877e2040737e052b2f249725b9a8a44ff"
PKG_SITE="http://www.kodi.tv"
PKG_URL="https://github.com/peak3d/inputstream.adaptive/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain kodi-platform"
PKG_SHORTDESC="inputstream.adaptive"
PKG_TOOLCHAIN="cmake-make"

PKG_IS_ADDON="yes"

post_makeinstall_target() {
  mkdir -p wv && cd wv
    cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DDECRYPTERPATH=special://home/cdm \
        $PKG_BUILD/wvdecrypter
    make

  cp -P $PKG_BUILD/.$TARGET_NAME/wv/libssd_wv.so $INSTALL/usr/lib
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/
  cp -R $PKG_BUILD/.install_pkg/usr/share/$MEDIACENTER/addons/$PKG_NAME/* $ADDON_BUILD/$PKG_ADDON_ID/

  ADDONSO=$(xmlstarlet sel -t -v "/addon/extension/@library_linux" $ADDON_BUILD/$PKG_ADDON_ID/addon.xml)
  cp -L $PKG_BUILD/.install_pkg/usr/lib/$MEDIACENTER/addons/$PKG_NAME/$ADDONSO $ADDON_BUILD/$PKG_ADDON_ID/

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib/
  cp -P $PKG_BUILD/.$TARGET_NAME/wv/libssd_wv.so $ADDON_BUILD/$PKG_ADDON_ID/lib
}