PKG_NAME="x11vnc"
PKG_VERSION="0.9.13"
PKG_SITE="http://www.karlrunge.com/x11vnc/#downloading"
PKG_URL="https://sourceforge.net/projects/libvncserver/files/x11vnc/$PKG_VERSION/x11vnc-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11 libXext libXtst libjpeg-turbo"
PKG_SECTION="service/system"
PKG_AUTORECONF="yes"

pre_build_target() {
   mkdir -p $ROOT/$PKG_BUILD/.$TARGET_NAME
   cp -RP $ROOT/$PKG_BUILD/* $ROOT/$PKG_BUILD/.$TARGET_NAME
   #export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --with-x11vnc \
			      --with-x \
			      --disable-nls"
			      
post_install () {
  enable_service x11vnc.service
}