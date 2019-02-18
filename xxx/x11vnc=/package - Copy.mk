PKG_NAME="x11vnc"
PKG_VERSION="0.9.13"
PKG_SITE="http://www.karlrunge.com/x11vnc/#downloading"
PKG_URL="https://sourceforge.net/projects/libvncserver/files/x11vnc/$PKG_VERSION/x11vnc-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11 libXext libXtst libjpeg-turbo"
PKG_SECTION="service/system"
PKG_TOOLCHAIN="autotools"

pre_build_target() {
   mkdir -p $PKG_BUILD/.$TARGET_NAME
   cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
   #export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --with-x11vnc \
			      --with-x \
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
			      --without-avahi \
			      --with-jpeg \
			      --without-libz \
			      --without-zlib \
			      --without-gnutls \
			      --without-client-tls \
			      --with-gnu-ld \
			      --disable-nls"
			      
post_install () {
  enable_service x11vnc.service
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share
}