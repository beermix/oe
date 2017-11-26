PKG_NAME="wine"
PKG_VERSION="2.18"
PKG_URL="https://fossies.org/linux/misc/wine-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain glib gmp x11 mesa xorg-server pcre libXcursor freetype fontconfig libjpeg-turbo libpng tiff libdrm glu libexif expat harfbuzz libxcb libXcursor libXrender libX11 x11 libXext libXtst wine:host gstreamer"
PKG_SECTION="tools"



pre_configure_target() {
  #export LIBS="-lfreetype"
  strip_lto
}

PKG_CONFIGURE_OPTS_TARGET="--with-wine-tools=$PKG_BUILD/.$HOST_NAME \
			      --disable-tests \
			      --with-x \
			      --enable-win64 \
			      --without-capi \
			      --without-coreaudio \
			      --with-gettext \
			      --without-gettextpo \
			      --without-gphoto \
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
			      --with-gstreamer \
			      --with-curses \
			      --with-dbus \
			      --with-pthread \
			      --without-pulse"
			      
PKG_CONFIGURE_OPTS_HOST="--enable-win64 \
			    --disable-tests \
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
			    --without-jpeg \
			    --without-ldap \
			    --without-mpg123 \
			    --without-netapi \
			    --without-openal \
			    --without-opencl \
			    --without-opengl \
			    --without-osmesa \
			    --without-oss \
			    --without-pcap \
			    --without-pulse \
			    --without-png \
			    --without-sane \
			    --without-tiff \
			    --without-v4l \
			    --without-x \
			    --without-xcomposite \
			    --without-xcursor \
			    --without-xinerama \
			    --without-xinput \
			    --without-xinput2 \
			    --without-xml \
			    --without-xrandr \
			    --without-xrender \
			    --without-xshape \
			    --without-xshm \
			    --without-xslt \
			    --without-xxf86vm \
			    --without-zlib \
			    --without-udev"

makeinstall_host() {
  : # nop
}