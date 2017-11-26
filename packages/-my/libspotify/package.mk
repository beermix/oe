PKG_NAME="libspotify"
PKG_VERSION="12.1.51-Linux-x86_64-release"
PKG_SITE="https://pypi.python.org/pypi/PyAMF/"
PKG_URL="https://developer.spotify.com/download/libspotify/libspotify-12.1.51-Linux-x86_64-release.tar.gz"
#PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="python/system"



pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC -DPIC"
  strip_lto
  mkdir -p $INSTALL/usr
  mkdir -p $INSTALL/usr/lib
  mkdir -p $INSTALL/usr/include
}


configure_target() {
make install make install prefix=/usr
}


post_makeinstall_target() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/daemon/transmission-daemon $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/daemon/transmission-remote $ADDON_BUILD/$PKG_ADDON_ID/bin
}
