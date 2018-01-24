PKG_NAME="wine"
PKG_VERSION="3.0"
#PKG_URL="https://dl.winehq.org/wine/source/2.x/wine-$PKG_VERSION.tar.xz"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain wine:host glib gmp x11 mesa xorg-server pcre libXcursor freetype fontconfig libjpeg-turbo libpng tiff libdrm glu libexif expat harfbuzz libxcb libXcursor libXrender libX11 x11 libXext libXtst cairo unclutter xdotool  libXScrnSaver libexif libXcomposite libXcursor libXtst libpcap"
PKG_DEPENDS_HOST="freetype:host"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--with-wine-tools=$PKG_BUILD/.$HOST_NAME \
			      --enable-win64 \
			      --disable-tests \
			      --with-x \
			      --without-gsm \
			      --without-hal \
			      --without-opencl \
			      --without-oss \
			      --with-freetype \
			      --with-fontconfig \
			      --with-jpeg \
			      --with-png \
			      --with-alsa \
			      --without-gnutls \
			      --with-pcap \
			      --with-curses \
			      --with-dbus \
			      --with-pthread \
			      --without-pulse"

PKG_CONFIGURE_OPTS_HOST="--enable-win64 \
			    --disable-tests \
			    --disable-win16 \
			    --without-alsa \
			    --without-capi \
			    --without-cms \
			    --without-coreaudio \
			    --without-cups \
			    --without-curses \
			    --without-dbus \
			    --without-fontconfig \
			    --without-gphoto \
			    --without-glu \
			    --without-gnutls \
			    --without-gsm \
			    --without-gstreamer \
			    --without-hal \
			    --without-ldap \
			    --without-mpg123 \
			    --without-netapi \
			    --without-openal \
			    --without-opencl \
			    --without-opengl \
			    --without-osmesa \
			    --without-oss \
			    --without-sane \
			    --without-tiff \
			    --without-v4l \
			    --without-x \
			    --without-xcomposite \
			    --without-xcursor \
			    --without-xinerama \
			    --without-xinput \
			    --without-xinput2 \
			    --without-xrandr \
			    --without-xrender \
			    --without-xshape \
			    --without-xshm \
			    --without-xslt \
			    --without-xxf86vm"

makeinstall_host() {
  : # nop
}