PKG_NAME="x11vnc"
PKG_VERSION="1ae1ef1"
PKG_SITE="http://www.karlrunge.com/x11vnc/#downloading"
PKG_GIT_URL="https://github.com/LibVNC/x11vnc"
PKG_DEPENDS_TARGET="toolchain libX11 libXext libXtst libjpeg-turbo libvncserver"
PKG_SECTION="service/system"
PKG_TOOLCHAIN="autotools"

pre_build_target() {
  export LIBS="$LIBS -lpthread -lsystemd -lz -ljpeg"
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_c_bigendian=no \
			      --without-crypto \
			      --without-ssl \
			      --without-crypt \
			      --with-x \
			      --without-v4l \
			      --without-avahi"
			      
post_install () {
  enable_service x11vnc.service
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share
}