PKG_NAME="x11vnc"
PKG_VERSION="0.9.15"
PKG_SITE="http://www.karlrunge.com/x11vnc/"
PKG_URL="http://x11vnc.sourceforge.net/dev/x11vnc-0.9.14-dev.tar.gz"
PKG_URL="https://github.com/LibVNC/libvncserver/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11 libXtst libXfixes libjpeg-turbo libvncserver"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/tools"
PKG_SHORTDESC="x11vnc allows one to view remotely and interact with real X displays"
PKG_LONGDESC="x11vnc allows one to view remotely and interact with real X displays"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --with-x11vnc \
			      --with-x \
			      --without-xfixes \
			      --without-xkeyboard \
			      --without-xinerama \
			      --without-xrandr \
			      --without-xdamage \
			      --without-xtrap \
			      --without-xrecord \
			      --without-fbpm \
			      --without-dpms \
			      --without-v4l \
			      --without-fbdev \
			      --without-uinput \
			      --without-macosx-native \
			      --without-crypto \
			      --without-ssl \
			      --without-avahi \
			      --without-jpeg \
			      --without-libz \
			      --without-zlib \
			      --without-gnutls \
			      --without-client-tls"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share
  cp -P $PKG_DIR/bin/* $INSTALL/usr/bin

  mkdir -p $INSTALL/usr/config/x11vnc
    cp -P $PKG_DIR/config/* $INSTALL/usr/config/x11vnc
}

post_install() {
  enable_service x11vnc.service
}
