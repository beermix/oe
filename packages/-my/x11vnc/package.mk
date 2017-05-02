PKG_NAME="x11vnc"
PKG_VERSION="8172d3e"
PKG_GIT_URL="https://github.com/LibVNC/x11vnc"
PKG_DEPENDS_TARGET="toolchain libX11 libXext libXtst libjpeg-turbo libvncserver"
PKG_SECTION="x11"
PKG_AUTORECONF="yes"

pre_build_target() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
  #export MAKEFLAGS="-j1"
  export LIBS="-lxcb -lXau -ljpeg -lsystemd -lpng16"
  export LDFLAGS="-lpthread -lstdc++ -lz -lm"
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
			      --with-cairo=no \
			      --without-zlib \
			      --without-gnutls \
			      --without-client-tls \
			      --enable-silent-rules \
			      --with-pic"