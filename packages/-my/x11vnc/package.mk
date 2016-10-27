PKG_NAME="x11vnc"
PKG_VERSION="0.9.14"
PKG_URL="https://dl.dropboxusercontent.com/s/op6flmf34zabkvf/x11vnc-0.9.14-dev.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11 libXext libXtst libjpeg-turbo libxcb libXau"
PKG_PRIORITY="optional"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="-enable-static \
			   --with-x11vnc \
			   --with-x \
			   --with-jpeg \
			   --without-xkeyboard \
			   --without-xinerama \
			   --without-xrandr \
			   --without-xfixes \
			   --without-xdamage \
			   --without-xtrap \
			   --without-xrecord \
			   --without-fbpm \
			   --without-dpms \
			   --without-v4l \
			   --without-fbdev \
			   --without-uinput \
			   --without-macosx-native \
			   --without-crypt \
			   --without-crypto \
			   --without-ssl \
			   --without-libz \
			   --without-avahi \
			   --without-gnutls \
			   --without-client-tls"

pre_configure_target() {
  export LIBS="$LIBS -ljpeg -lpng -lpthread -lresolv"
}

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}


addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp $PKG_BUILD/.$TARGET_NAME/src/x11vnc $ADDON_BUILD/$PKG_ADDON_ID/bin
}
