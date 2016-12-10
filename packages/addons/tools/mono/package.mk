PKG_NAME="mono"
PKG_VERSION="4.6.0.245"
PKG_REV="101"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="http://www.mono-project.com"
PKG_URL="http://download.mono-project.com/sources/mono/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_SOURCE_DIR="$PKG_NAME-${PKG_VERSION%.*}"
PKG_DEPENDS_TARGET="toolchain mono:host libgdiplus sqlite zlib"
PKG_IS_ADDON="yes"
PKG_AUTORECONF="yes"


prefix="/storage/.kodi/addons/$PKG_SECTION.$PKG_NAME"
options="--disable-gtk-doc \
	  --with-mcs-docs=no \
	  --with-moonlight=no \
	  --with-ikvm-native=no \
	  --enable-minimal=profiler,debug \
	  --enable-static"

configure_host() {
  cp -PR ../* .
  ./configure $options --host=$HOST_NAME
}

makeinstall_host() {
  : # nop
}

configure_target() {
  cp -PR ../* .
  strip_lto
  ./configure $options --host=$TARGET_NAME \
                       --disable-mcs-build
}

makeinstall_target() {
  make -C "$ROOT/$PKG_BUILD/.$HOST_NAME" install DESTDIR="$INSTALL"
  make -C "$ROOT/$PKG_BUILD/.$TARGET_NAME" install DESTDIR="$INSTALL"
  $STRIP "$INSTALL/storage/.kodi/addons/$PKG_SECTION.$PKG_NAME/bin/mono"
}

addon() {
  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID"
  
  cp -PR "$PKG_BUILD/.install_pkg/storage/.kodi/addons/$PKG_SECTION.$PKG_NAME"/* \
         "$ADDON_BUILD/$PKG_ADDON_ID/"

  rm -fr "$ADDON_BUILD/$PKG_ADDON_ID/include" \
         "$ADDON_BUILD/$PKG_ADDON_ID/share/man"

  mv "$ADDON_BUILD/$PKG_ADDON_ID/bin/mono-sgen" \
     "$ADDON_BUILD/$PKG_ADDON_ID/bin/mono"

  cp -L "$(get_build_dir libX11)/.install_pkg/usr/lib/libX11.so.6" \
        "$(get_build_dir libXext)/.install_pkg/usr/lib/libXext.so.6" \
        "$(get_build_dir pixman)/.install_pkg/usr/lib/libpixman-1.so.0" \
        "$ADDON_BUILD/$PKG_ADDON_ID/lib"
}