PKG_NAME="x11vnc"
PKG_VERSION="38e295a"
PKG_SITE="http://www.karlrunge.com/x11vnc/"
PKG_URL="http://x11vnc.sourceforge.net/dev/x11vnc-0.9.14-dev.tar.gz"
PKG_URL="https://github.com/LibVNC/x11vnc/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11 libXtst libXfixes libjpeg-turbo libvncserver"
PKG_PRIORITY="optional"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+hardening"

pre_configure_target() {
  export LIBS="$LIBS -lm -lz -lm  -pthread -lpthread -lpng -ljpeg -lresolv -lssl -lcrypto -lvncserver"
  export LIBS="-lxcb -lXau -ljpeg -lpng16 -lz -ldl -lpthread -lpng -ljpeg -lresolv -lssl -lcrypto -lvncserver"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --with-x11vnc \
			      --with-x \
			      --with-xfixes \
			      --without-xkeyboard \
			      --without-xinerama \
			      --with-xrandr \
			      --without-xdamage \
			      --without-xtrap \
			      --without-xrecord \
			      --without-fbpm \
			      --without-dpms \
			      --without-v4l \
			      --without-fbdev \
			      --without-uinput \
			      --without-macosx-native \
			      --with-ssl=$SYSROOT_PREFIX/usr/lib \
			      --without-avahi \
			      --with-jpeg \
			      --without-libz \
			      --with-zlib \
			      --without-gnutls \
			      --without-client-tls"

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
    cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share
  cp -P $PKG_DIR/bin/* $INSTALL/usr/bin

  mkdir -p $INSTALL/usr/config/x11vnc
    cp -P $PKG_DIR/config/* $INSTALL/usr/config/x11vnc
}

post_install() {
  enable_service x11vnc.service
}
